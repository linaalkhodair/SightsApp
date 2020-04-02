//
//  HomeViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase
import ARCL
import CoreLocation
import SceneKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    var sceneLocationView = SceneLocationView()
    var poiview = POIView()
    var drivingPopup = DrivingPopUp()
    static var challengeID: String = ""
   // var challengeview = ChallengeView()
    
    var db: Firestore!
    
    let locationManager = CLLocationManager()
    
    let coreMotion = CoreMotionManager() //for the activity of user (walking or driving)
    
    let regionInMeters: Double = 10000
    var userLoc = CLLocation()
    static var activity: String = " "
    
    
    var timer = Timer()
    
//    @IBOutlet weak var navBar: UINavigationBar!
//    @IBOutlet weak var navItem: UIBarButtonItem!
//    @IBOutlet weak var listImg: UIImageView!
//    @IBOutlet weak var profileImg: UIImageView!
//    @IBOutlet weak var cameraImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CheckInternet.Connection(){
            
            sceneLocationView.run()
            view.addSubview(sceneLocationView)
            
            //adding navigation bar
//            view.addSubview(navBar)
//            view.addSubview(listImg)
//            view.addSubview(profileImg)
//            view.addSubview(cameraImg)
            
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
            view.addSubview(drivingPopup.contentView)
        //    view.addSubview(challengeview.contentView)
            //view.addSubview(logoutButton)
            
            //adding navigation bar
//            view.addSubview(navBar)
//            view.addSubview(listImg)
//            view.addSubview(profileImg)
//            view.addSubview(cameraImg)
            
            poiview.contentView.alpha = 0
            drivingPopup.contentView.alpha = 0
          //  challengeview.contentView.alpha = 0
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
                
            })
            //--------------------------------CREATING AR OBJECTS----------------------------------
            
            timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (_) in
                print("timer works")
                // we will use it to get user updated loc and call the func again
            })
            print("UID",UserDefaults.standard.string(forKey: "uid"))
            
            //iterate through all poi's in DB
            self.getPOI()
            
            //handling when an AR object is tapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
            sceneLocationView.addGestureRecognizer(tap)
            
        }// end of else
        //set nav bar to transparent
//        self.navBar.setBackgroundImage(UIImage(), for: .default)
//        self.navBar.shadowImage=UIImage()
        
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
                        self.poiview.contentView.alpha = 0.95
                        
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
                    let hasChallenge = document.get("hasChallenge") as! String
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
                        if (hasChallenge != ""){
                            //create challenge and start displaying
                            print("theres a challenge")
                            //display popup want to start a challenge..
                            //if yes direct to challengevc
                           // self.challengeview.contentView.alpha = 1
                           // let challengeVC = ChallengePopUpVC()

                            HomeViewController.challengeID = hasChallenge

                            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChallengePopUpVC") as! ChallengePopUpVC

                            self.addChild(popOverVC)

                            popOverVC.view.frame = self.view.frame
                            self.view.addSubview(popOverVC.view)
                            popOverVC.didMove(toParent: self)
                            
//                            let challenge = Challenge()
//                            let hiddenObject = challenge.getChallenge(ID: hasChallenge)
//                            self.displayPOIobjects(latitude: hiddenObject.latitude, longitude: hiddenObject.longitude, img: hiddenObject.image, ID: hiddenObject.ID)

                        }
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
        //set up for the image
        let url = URL(string: img)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        //create the object
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
            
            self.view.addSubview(self.drivingPopup.contentView)
            drivingPopup.contentView.alpha = 0.85
            
//Alert.showBasicAlert(on: self, with: "Seems like you're currently driving 🚗", message: "For a better experience start walking to enjoy AR!")
            let distance = self.userLoc.distance(from: userLocation!)
           
            if distance >= 10 { // if diff more than 100 fire the notification search and look for AR....? I suggest distance to be 50?
               
                let FQnotification = LBNotification(lat: (userLocation?.coordinate.latitude)!, lng: (userLocation?.coordinate.longitude)!)
                FQnotification.searchVenues()
                
                userLoc = locations.last! //previous location
               
                print("inside")
                
            }//end if distance
            
            coreMotion.startUpdates { (activityType) in
                HomeViewController.activity = activityType
            }
            
        }//end if driving
        
        
        //just for testing purposes
        if (HomeViewController.activity == "walking" || HomeViewController.activity == "stationary"){
            
    //        self.view.addSubview(self.drivingPopup.contentView)
    //        drivingPopup.contentView.alpha = 0.85
            Alert.showBasicAlert(on: self, with: "I bet you're currently walking huh?🚶🏻", message: "For a better experience continue walking and explore Riyadh!") //THIS WILL BE DELETED LATER *FOR TESTING PURPOSES*
            let distance = self.userLoc.distance(from: userLocation!)
            
            if distance >= 10 { // if diff more than 100 fire the notification search....? //change to desired distance ..?
               
                let FQnotification = LBNotification(lat: (userLocation?.coordinate.latitude)!, lng: (userLocation?.coordinate.longitude)!)
                FQnotification.searchVenues()
              
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
    
    
    
//    //  LOCK ORIENTATION TO PORTRAIT
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
