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
    
    let coreMotion = CoreMotionManager() //for the activity of user (walking or driving)
    
    let regionInMeters: Double = 10000
    var userLoc = CLLocation()
    static var activity: String = " "
    
    //Foursquare API
    let client = FoursquareAPIClient(clientId: Constants.FoursquareClient.clientId, clientSecret: Constants.FoursquareClient.clientSecret)
    
    var timer = Timer()
    
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
        
        coreMotion.startUpdates { (activityType) in
            HomeViewController.activity = activityType
//            if (activityType == "walking"){
//                print("$$$inside walking$$$")
//                 Alert.showBasicAlert(on: self, with: "You're currently walking..", message: "For a better experience continue walking and explore Riyadh!")
//            }
        } //To get the user's motion when first started
        
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
        annotationNode.scaleRelativeToDistance = false
        annotationNode.ignoreAltitude = false
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
            
        // ********* we need to also check every a certain distance to check for other POI object *********
            
        if (HomeViewController.activity == "driving") {
                Alert.showBasicAlert(on: self, with: "Seems like you're currently driving 🚗", message: "For a better experience start walking to enjoy AR!")
                let distance = self.userLoc.distance(from: userLocation!)
                if distance >= 10 { // if diff more than 100 fire the notification search and look for AR....? I suggest distance to be 50?
                searchVenues(lat: (userLocation?.coordinate.latitude)!, lng: (userLocation?.coordinate.longitude)!)
                userLoc = locations.last! //previous location
                print("inside")  }//end if distance
            coreMotion.startUpdates { (activityType) in
                HomeViewController.activity = activityType
            }

        }//end if driving


            //just for testing purposes
        if (HomeViewController.activity == "walking" || HomeViewController.activity == "stationary"){
                Alert.showBasicAlert(on: self, with: "I bet you're currently walking huh?🚶🏻", message: "For a better experience continue walking and explore Riyadh!") //THIS WILL BE DELETED LATER *FOR TESTING PURPOSES*
                let distance = self.userLoc.distance(from: userLocation!)
                if distance >= 10 { // if diff more than 100 fire the notification search....? //change to desired distance ..?
                searchVenues(lat: (userLocation?.coordinate.latitude)!, lng: (userLocation?.coordinate.longitude)!)
                userLoc = locations.last! //previous location
                print("inside")
                    
            }//end if distance
            coreMotion.startUpdates { (activityType) in
                HomeViewController.activity = activityType
            }
        }//end if walking

    
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    //----------------------------------------------------------------------------------------------
    
    func searchVenues(lat: Double, lng: Double) {
        let parameter: [String: String] = [
            "ll": "24.753579, 46.738136",
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
                
                let name = json["response"]["venues"][0]["name"].string //first venue
                print("NAME FROM JSON: ", name)
                
                let id = json["response"]["venues"][0]["id"].string
                print("id of foursquare", id)
                
                self.start(json: json, key: 0)
                
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
        

    } // end searchVenues
    
    
    // recursive func to iterate through all venues and find a venue with a high rating to notify user
    func start(json: JSON, key: Int) {
        var isSent2 = false
        let placeId = json["response"]["venues"][key]["id"].string
        let name = json["response"]["venues"][key]["name"].string
        print("name:",name)
        print("placeId:",placeId)
        
        if placeId != nil {
            self.getVenueDetails(id: placeId!) { (isSent) in
                isSent2 = isSent
                if isSent2 == false {
                    print("works",isSent)
                    self.start(json: json, key: key+1)
                }
            }
        }
    } // end start
    
    
    //-------------------------------------------------------------------------------------------------------------
    
    func getVenueDetails(id: String, completionHandler: @escaping (Bool)->Void)  {
        
        var isSent: Bool = false
        
        let parameter: [String: String] = [
            "VENUE_ID": "\(id)",
            
        ];
        
        client.request(path: "venues/\(id)", parameter: parameter) { result in
            
            switch result {
            case let .success(data):
                
                let jsonResponse = try! JSONSerialization.jsonObject(with: data, options: [])
                
                let json = JSON(jsonResponse)
                let name = json["response"]["venue"]["name"].string
                
                var loc = json["response"]["venue"]["location"]["address"].string
                if loc == nil {
                    loc = "Riyadh, Saudi Arabia."
                }
               var desc = json["response"]["venue"]["location"]["description"].string
                if desc == nil {
                    desc = "" //? idk
                }
                var hours = json["response"]["venue"]["hours"]["status"].string //?
                if hours == nil {
                    hours = "8:00 AM - 10:00 PM"
                }
                
                let lat = json["response"]["venue"]["location"]["lat"].double
                let lng = json["response"]["venue"]["location"]["lng"].double

                if let rating:Double = json["response"]["venue"]["rating"].double {
                    print("rating from: ", rating)
                    
                    if (rating > 2)  {
                        self.foursquareNotification(name: name!)
                        
                        // here we need to create a POI object with all info needed then add POI to user's notification list
                        // also later on check to not send notification that exists in the notification list
                        let poi = POI(ID: id, name: name!, location: loc!, latitude: lat!, longitude: lng!, rating: rating, briefInfo: desc!, openingHours: hours!, image: "", markState: false)
                        
                        //then add POIObject to notification list
                        print("here inside lol")
                        isSent = true
                        print("isSent hereee", isSent)
                        completionHandler(isSent)
                    }
                    
                } //end if rating
                    
                else {
                    isSent = false
                    completionHandler(isSent)
                }
                
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
        
    }//end getVenueDetails
    
    
    //-----------------------------------------------NOTIFICATIONS-----------------------------------------------------
    
    
    func foursquareNotification(name: String) {
        
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Hey there, Riyadh is waiting for you 🌏"
        //content.subtitle = "\(place.name.unsafelyUnwrapped) is near you!"
        content.body = "You've just passed \(name), come check it out and explore Riyadh."
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
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    //update notification badge when entered
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        //UI updates are done in the main thread
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber -= 1
        }

        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: {requests in
            //Update only the notifications that have userInfo["timeInterval"] set
            let newRequests: [UNNotificationRequest] =
                requests
                    .filter{ rq in
                        return rq.content.userInfo["timeInterval"] is Double?
                    }
                    .map { request in
                        let newContent: UNMutableNotificationContent = request.content.mutableCopy() as! UNMutableNotificationContent
                        newContent.badge = (Int(truncating: request.content.badge ?? 0) - 1) as NSNumber
                        let newRequest: UNNotificationRequest =
                            UNNotificationRequest(identifier: request.identifier,
                                                  content: newContent,
                                                  trigger: request.trigger)
                        return newRequest
            }
            newRequests.forEach { center.add($0, withCompletionHandler: { (error) in
                // Handle error
            })
            }
        })
        completionHandler()
    }
    
    //------------------------------------------------END NOTIFICATIONS----------------------------------------------------
    
    
    //  LOCK ORIENTATION TO PORTRAIT
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }

    
    
}
