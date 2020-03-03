//
//  HomeViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import ARCL
import CoreLocation
import SceneKit
import UserNotifications
import FoursquareAPIClient
import SwiftyJSON


class HomeViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    var sceneLocationView = SceneLocationView()
    var poiview = POIView()

    var db: Firestore!
    
    let locationManager = CLLocationManager()
   
    
    let regionInMeters: Double = 10000
    var userLoc = CLLocation()
    
    //Foursquare API
    let client = FoursquareAPIClient(clientId: "HKDOVXAY2F54P505WTDL4AQZHXQIGKSFVAYJ3OLL0FYTXIAK", clientSecret: "F5U1CR4QU4OF4IYB4GWJHGSOHDQZKFS43WAR22J1N1MAOGKV")
    
     var timer = Timer()
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UIBarButtonItem!
    @IBOutlet weak var listImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var cameraImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CheckInternet.Connection(){
            
            sceneLocationView.run()
            view.addSubview(sceneLocationView)
            
            //adding navigation bar
            view.addSubview(navBar)
            view.addSubview(listImg)
            view.addSubview(profileImg)
            view.addSubview(cameraImg)
            
            Alert.showBasicAlert(on: self, with: "WiFi is Turned Off", message: "Please turn on cellular data or use  Wi-Fi to access data.")

            //****** we should add the buttons to make it the same appearance as if there's wifi *******
        }
        else {
        
        checkLocationServices() // checks if location is authorized
        //start the AR view
        sceneLocationView.run()
        
        view.addSubview(sceneLocationView)
            
        db = Firestore.firestore()
        
        //Adding the popup view for additional info
        view.addSubview(poiview.contentView)
        //view.addSubview(logoutButton)
            
        //adding navigation bar
        view.addSubview(navBar)
        view.addSubview(listImg)
        view.addSubview(profileImg)
        view.addSubview(cameraImg)

        poiview.contentView.alpha = 0
                        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
                
        })
        //--------------------------------CREATING AR OBJECTS----------------------------------
        
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (_) in
            print("timer works")
            // we will use it to get user updated loc and call the func again
        })
        
        //iterate through all poi's in DB
        self.getPOI()
        
        //handling when an AR object is tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        sceneLocationView.addGestureRecognizer(tap)
        
        }// end of else
        //set nav bar to transparent
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage=UIImage()
        
    } //end viewDidLoad
    
    //Method called when tap on AR object
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneLocationView)
            let hits = self.sceneLocationView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                print("yes")
                let locationNode = getLocationNode(node: tappedNode!)
                //try
                //its adding them on top of each other
                print("ID:", locationNode!.name!)
                let ID = locationNode?.name
                
               let poiView = setPOIView(ID: ID!)

            }
        }
    }
     
    //---------------------------------------------------------------------------------------------------------------
    
    func setPOIView(ID: String) -> POIView {
//        let poiView = POIView()
        self.view.addSubview(self.poiview.contentView)
        poiview.contentView.alpha = 0
        
        print("id inside:",ID)
        
        poiview.setPoiId(ID: ID)
        
//        let docRef = db.collection("POIs").document(id)
//        db.collection("POIs").document(ID).getDocument { (DocumentSnapshot, error) in
//            if DocumentSnapshot!.exists {
//
//                poiView.POIName.text = DocumentSnapshot!.get("name") as! String
//                poiView.describtion.text = DocumentSnapshot!.get("briefInfo") as! String
//                poiView.openingHours.text = DocumentSnapshot!.get("openingHours") as! String
//                var rating = DocumentSnapshot!.get("rating") as! Double
//                poiView.rating.text = "rating \(rating)"
//                poiView.location.text = DocumentSnapshot!.get("location") as! String
//                print("here insiddee")
//                 self.sceneLocationView.addSubview(poiView)
//
//
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        
        
        db.collection("POIs").whereField("ID", isEqualTo: ID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        self.poiview.POIName.text = document.get("name") as! String
                        self.poiview.describtion.text = document.get("briefInfo") as! String
                        self.poiview.openingHours.text = document.get("openingHours") as! String
                        var rating = document.get("rating") as! Double
                        self.poiview.rating.text = "rating \(rating)"
                        self.poiview.location.text = document.get("location") as! String
                        print("here insiddee")
                        //self.sceneLocationView.addSubview(poiView)
                        self.poiview.contentView.alpha = 0.85

                    }
                }
        }
               
        return poiview
    }
    
    //---------------------------------------------------------------------------------------------------------------

    
    func getLocationNode(node: SCNNode) -> LocationAnnotationNode? {
        if node.isKind(of: LocationNode.self) {
            return node as? LocationAnnotationNode
        } else if let parentNode = node.parent {
            return getLocationNode(node: parentNode)
        }
        return nil
    }
    
    func getPOI(){
        
        //iterate through POIs
        db.collection("POIs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    let latitude = document.get("latitude")
                    let longitude = document.get("longitude")
                    let imageData = document.get("image")
                    let ID = document.get("ID")
                    //any additional data... maybe the get the describtion then pass it on to a method to display the additional info
                    
                    let coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    let location = CLLocation(coordinate: coordinate, altitude: 620)
                    if self.locationManager.location == nil {
                        Alert.showBasicAlert(on: self, with: "Cannot access location!", message: "To get better experience, please allow location access.")
                        break
                    } else {
                    self.userLoc = self.locationManager.location!
                      }
                    let distance = self.userLoc.distance(from:location) //in meters
                    print("distance: ", distance)
                    
                    if distance <= 150 { //sample distance
                        self.displayPOIobjects(latitude: latitude as! Double, longitude: longitude as! Double, img: imageData as! String, ID: ID as! String)
                    }
                    else {
                        print("POI is too far away!")
                    }
                } //end for loop
            }
        }
        
    } //end func getPOI
    
    //---------------------------------------------------------------------------------------------------------------

    
    func displayPOIobjects(latitude: Double, longitude: Double, img: String, ID: String){
        
//        locationManager.activityType = .fitness
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        // Until we come up with a heuristic to unpause it
//        locationManager.pausesLocationUpdatesAutomatically = false
//
//        // only give us updates when we have 10 meters of change (otherwise we get way too much data)
//        locationManager.distanceFilter = 10
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.delegate = self

        //set up for the image
        let url = URL(string: img)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        //create the object
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude) //noura
        let location = CLLocation(coordinate: coordinate, altitude: 620)
        
        let annotationNode = LocationAnnotationNode(location: location, image: image!)
        annotationNode.name = ID
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
              
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    //------------------------------------END AR--------------------------------------------
    
    
    //-------------------------------TRACK USER LOCATION------------------------------------
    
    func setupLocationManager() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = 10 //?? idk 100 maybe
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.startUpdatingLocation() //MAYBE NO NEED HERE???????
        
        //locationManager.stopMonitoringSignificantLocationChanges()
        userLoc = locationManager.location! //IDK WHY HEHE

    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
            //                    Alert.showBasicAlert(on: self, with: "Enhance your experience!", message: "Please make sure to turn on location permissions for Sights App.")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            Alert.showBasicAlert(on: self, with: "Cannot access location!", message: "To get better experience, please allow location access.")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            Alert.showBasicAlert(on: self, with: "Cannot access location!", message: "To get better experience, please allow location access.")
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation() //??????/mdry
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
          let userLocation = locations.last //new location
          
        
          let distance = self.userLoc.distance(from: userLocation!)
          if distance >= 10 { // if diff more than 100 fire the notification search....? //change to desired distance ..?
              
              searchVenues(lat: (userLocation?.coordinate.latitude)!, lng: (userLocation?.coordinate.longitude)!)
              
              userLoc = locations.last! //previous location
              print("inside")
          }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    //----------------------------------------------------------------------------------------------
        
        func searchVenues(lat: Double, lng: Double) {
            let parameter: [String: String] = [
                "ll": "\(24.631424),\(46.713370)",
                "radius": "600",
                "limit": "10",
                "intent": "browse",
                "categoryId": "4bf58dd8d48988d1e4931735,4bf58dd8d48988d1f1931735,4deefb944765f83613cdba6e,4bf58dd8d48988d17f941735,52e81612bcbc57f1066b79eb,4bf58dd8d48988d181941735,4bf58dd8d48988d1f4931735,4bf58dd8d48988d189941735,4bf58dd8d48988d182941735,4bf58dd8d48988d17b941735,4bf58dd8d48988d163941735,4bf58dd8d48988d164941735,4bf58dd8d48988d165941735,56aa371be4b08b9a8d57356a,4bf58dd8d48988d12f941735"
            ];

            
            client.request(path: "venues/search", parameter: parameter) { result in
                switch result {
                case let .success(data):
                   
                    let jsonResponse = try! JSONSerialization.jsonObject(with: data, options: [])
                    let json = JSON(jsonResponse)

                    if let name = json["response"]["venues"][1]["name"].string {
                      print("NAME FROM JSON: ", name)
                        
                        let id = json["response"]["venues"][1]["id"].string
                        print("id of foursquare", id)
                        
                        var rating:Double = self.getVenueDetails(id: id!)
                        
//                        if (rating != 0 )  {
//                            self.foursquareNotification(name: name)
//                            print("here inside lol")
//                        }
                    }
                    
                    for (key,subJson):(String, JSON) in json["response"]["venues"] {
                        let placeName = subJson["name"].string
                        print("place name:",placeName.unsafelyUnwrapped)
                    }
                    
                    
                  //  print("json == ", jsonResponse)
                case let .failure(error):
                    // Error handling
                    switch error {
                    case let .connectionError(connectionError):
                        print(connectionError)
                    case let .responseParseError(responseParseError):
                        print(responseParseError)   // e.g. JSON text did not start with array or object and option to allow fragments not set.
                    case let .apiError(apiError):
                        print(apiError.errorType)   // e.g. endpoint_error
                        print(apiError.errorDetail) // e.g. The requested path does not exist.
                    }
                }
            }
            
        }
        
        //-------------------------------------------------------------------------------------------------------------
    
        func getVenueDetails(id: String) -> Double {
        
        var rat:Double = 0
        
            
        let parameter: [String: String] = [
            "VENUE_ID": "\(id)",

        ];

        client.request(path: "venues/\(id)", parameter: parameter) { result in
            switch result {
            case let .success(data):
                // parse the JSON data with NSJSONSerialization or Lib like SwiftyJson
                // e.g. {"meta":{"code":200},"notifications":[{"...
                let jsonResponse = try! JSONSerialization.jsonObject(with: data, options: [])
               
                let json = JSON(jsonResponse)
               // print("json == ", jsonResponse)
                
                let name = json["response"]["venue"]["name"].string

                if let rating:Double = json["response"]["venue"]["rating"].double {
                    print("rating from: ", rating)
                    //rat = rating
                    
                    if (rating > 2  )  {
                        self.foursquareNotification(name: name!)
                        print("here inside lol")
                    }
                  
                }
                
                
                 
                
//                rat = json["response"]["venue"]["rating"].double!
//                print("rating from: ", rat)
//                //rat = rating.unsafelyUnwrapped
                 

            case let .failure(error):
                // Error handling
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .responseParseError(responseParseError):
                    print(responseParseError)   // e.g. JSON text did not start with array or object and option to allow fragments not set.
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                        }
                    }
                }
            return rat
        }
    
    //-------------------------------------------------------------------------------------------------------------

    
        func foursquareNotification(name: String) {
            
            //creating the notification content
            let content = UNMutableNotificationContent()
            
            //adding title, subtitle, body and badge
            content.title = "FQ, Hey you've just passed \(name) !"
            //content.subtitle = "\(place.name.unsafelyUnwrapped) is near you!"
            content.body = "Come check it out and explore Riyadh!"
            content.badge = 1
            content.sound = .default
            
            
            //getting the notification trigger
            //it will be called after 5 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //getting the notification request
            let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            
            //adding the notification to notification center
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }

    //-------------------------------------------------------------------------------------------------------------
    
 
    
    
}
