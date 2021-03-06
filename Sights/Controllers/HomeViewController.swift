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

var globalPOIList = [POI]()

class HomeViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, LNTouchDelegate {
    
    var sceneLocationView = SceneLocationView()
    var poiview = POIView()
    var drivingPopup = DrivingPopUp()
    
    
    var db: Firestore!
    
    let locationManager = CLLocationManager()
    
    let coreMotion = CoreMotionManager() //for the activity of user (walking or driving)
    
    let regionInMeters: Double = 10000
    var userLoc = CLLocation()
    static var activity: String = " "
    
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CheckInternet.Connection(){
            
            sceneLocationView.run()
            view.addSubview(sceneLocationView)
            Alert.showBasicAlert(on: self, with: "WiFi is Turned Off", message: "Please turn on cellular data or use  Wi-Fi to access data.")
            
        }
        else {
            
            checkLocationServices() // checks if location is authorized
            
            //start the AR view
            sceneLocationView.run()
            sceneLocationView.moveSceneHeadingClockwise()
            sceneLocationView.moveSceneHeadingAntiClockwise()
            
            self.sceneLocationView.locationNodeTouchDelegate = self
            
            view.addSubview(sceneLocationView)
            db = Firestore.firestore()
            
            //Adding the popup view for additional info
            view.addSubview(poiview.contentView)
            view.addSubview(drivingPopup.contentView)
            
            poiview.contentView.alpha = 0
            drivingPopup.contentView.alpha = 0
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
                
            })
            //--------------------------------------------CREATING AR OBJECTS----------------------------------------------------------
            
            print("UID",UserDefaults.standard.string(forKey: "uid") as Any)
            
            //iterate through all poi's in DB
            self.getPOI()
            self.getNotiPOI()
            
            
        }// end of else
        
        coreMotion.startUpdates { (activityType) in
            HomeViewController.activity = activityType
        } //To get the user's motion when first started
        
    } //end viewDidLoad
    
    //---------------------------------------------------------------------------------------------------------------
    
    func setPOIView(ID: String) -> POIView {
        //        let poiView = POIView()
        self.view.addSubview(self.poiview.contentView)
        poiview.contentView.alpha = 0
        
        print("id inside:",ID)
        
        poiview.setPoiId(ID: ID)
        
        db.collection("POIs").whereField("ID", isEqualTo: ID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.poiview.ID = ID
                        self.poiview.nameString = document.get("name") as! String
                        self.poiview.descString = document.get("briefInfo") as! String
                        self.poiview.hoursString = document.get("openingHours") as! String
                        let rating = document.get("rating") as! Double
                        self.poiview.rating.text = "Rating \(rating)"
                        self.poiview.locString = document.get("location") as! String
                        self.poiview.wanttovisit = false
                        self.poiview.visited = false
                        self.poiview.notinterested = false
                        
                        self.poiview.setContent() //prepare content
                        
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
                    
                    globalPOIList.append(POI(ID: document.documentID, name: document.get("name") as! String, rate: document.get("rating") as! Double, long: document.get("longitude") as! Double, lat:document.get("latitude") as! Double, description: document.get("briefInfo") as! String, openingHours: document.get("openingHours") as! String, locationName: document.get("location") as! String, imgUrl: document.get("image") as! String, category: document.get("category") as! String, fullimg: document.get("fullimg") as! String))
                    
                    let latitude = document.get("latitude")
                    let longitude = document.get("longitude")
                    let imageData = document.get("image")
                    let ID = document.get("ID")
                    let hasChallenge = document.get("hasChallenge") as! String
                    let has3D = document.get("has3D") as! Bool
                    
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
                        self.displayPOIobjects(latitude: latitude as! Double, longitude: longitude as! Double, img: imageData as! String, ID: ID as! String, name: document.get("name") as! String, has3D: has3D)
                        if (hasChallenge != ""){
                            print("theres a challenge")
                            
                            ChallengeViewController.chid = hasChallenge
                            
                            //CHECK IF REGISTERED USER
                            let user = Auth.auth().currentUser
                            let isAnon = user?.isAnonymous
                            
                            if !isAnon! {
                                //display challenge after some time..
                                self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (_) in
                                    print("timer works")
                                    self.displayChallenge(chid: hasChallenge)
                                })
                            }
                            
                        }
                    }
                    else {
                        print("POI is too far away!")
                    }
                } //end for loop
            }
        }
        
    } //end func getPOI
    
    
    func displayChallenge(chid: String) {
        let uid = Auth.auth().currentUser?.uid
        //CHECK IF USER HAS PLAYED THE CHALLENGE!
        db.collection("users/\(uid!)/playedChallenges").document(chid).getDocument { (docSnapshot, err) in
            if let err = err {
                print("Document doesn't exist \(err)")
            } else {
                
                if (!docSnapshot!.exists) {
                    
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChallengePopUpVC") as! ChallengePopUpVC
                    
                    self.addChild(popOverVC)
                    
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParent: self)
                }
            }
        }
        
    }
    
    //---------------------------------------------------------------------------------------------------------------
    
    
    func displayPOIobjects(latitude: Double, longitude: Double, img: String, ID: String, name: String, has3D: Bool){
        //set up for the image
        let url = URL(string: img)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        if has3D {
            display3DObject(latitude: latitude, longitude: longitude, img: img, ID: ID, name: name)
        }
            // if 2D
        else {
            // create the object
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let location = CLLocation(coordinate: coordinate, altitude: 620)
            
            let annotationNode = LocationAnnotationNode(location: location, image: image!)
            annotationNode.name = ID
            annotationNode.scaleRelativeToDistance = false
            annotationNode.ignoreAltitude = false
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
    
    
    func display3DObject(latitude: Double, longitude: Double, img: String, ID: String, name: String) {
        guard let location = sceneLocationView.sceneLocationManager.currentLocation, location.horizontalAccuracy < 25 else {
            print("Location fix not established yet, trying again shortly")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.display3DObject(latitude: latitude, longitude: longitude, img: img, ID: ID, name: name)
                
            }
            return
        }
        print("done")
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location1 = CLLocation(coordinate: coordinate, altitude: 620)
        
        let locationNode = LocationNode(location: location1)
        locationNode.scaleRelativeToDistance = false
        locationNode.ignoreAltitude = true
        let scene = SCNScene(named: name)
        let node = scene!.rootNode.childNode(withName: "model", recursively: true)
        node?.position = SCNVector3(0, 0, -1)
        
        locationNode.addChildNode(node!)
        locationNode.name = ID
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
        
    }
    
    func annotationNodeTouched(node: AnnotationNode) {
        let locationNode = getLocationNode(node: node)
        let id = locationNode?.name
        _ = setPOIView(ID: id!)
    }
    
    func locationNodeTouched(node: LocationNode) {
        let id = node.name
        _ = setPOIView(ID: id!)
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
            //Alert.showBasicAlert(on: self, with: "Enhance your experience!", message: "Please make sure to turn on location permissions for Sights App.")
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
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let userLocation = locations.last //new location
        
        // ********* check every a certain distance to check for other POI object *********
        
        if (HomeViewController.activity == "driving") {
            
            self.view.addSubview(self.drivingPopup.contentView)
            drivingPopup.contentView.alpha = 0.85
            
            //Alert.showBasicAlert(on: self, with: "Seems like you're currently driving 🚗", message: "For a better experience start walking to enjoy AR!")
            let distance = self.userLoc.distance(from: userLocation!)
            
            if distance >= 10 { // if diff more than 100 fire the notification search and look for AR
                
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
            let distance = self.userLoc.distance(from: userLocation!)
            
            if distance >= 10 { // if diff more than 100 fire the notification search and look for AR
                
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
    
    func getNotiPOI(){
        
        //iterate through POIs
        db.collection("NotificationsPOIs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    globalPOIList.append(POI(ID: document.documentID, name: document.get("name") as! String, rate: document.get("rating") as! Double, long: document.get("longitude") as! Double, lat:document.get("latitude") as! Double, description: document.get("briefInfo") as! String, openingHours: document.get("openingHours") as! String, locationName: document.get("location") as! String, imgUrl: document.get("image") as! String, category: document.get("category") as! String, fullimg: document.get("image") as! String))
                    
                }//end for
            }
        }
        
    } //end func getPOI
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    
    
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
