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


class HomeViewController: UIViewController, CLLocationManagerDelegate {

    var sceneLocationView = SceneLocationView()
    var db: Firestore!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    @IBOutlet weak var logoutButton: UIButton!
    var userLoc = CLLocation()
    var timer = Timer()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices() // checks if location is authorized
        //start the AR view
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        db = Firestore.firestore()
        
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
        
    } //end viewDidLoad
    
    //Method called when tap on AR object
    @objc func handleTap(rec: UITapGestureRecognizer){
        
           if rec.state == .ended {
                let location: CGPoint = rec.location(in: sceneLocationView)
                let hits = self.sceneLocationView.hitTest(location, options: nil)
                if !hits.isEmpty{
                    let tappedNode = hits.first?.node
                    print("yes")
                    //try
              
                    let poiView = POIView()
                    sceneLocationView.addSubview(poiView)

                }
           }
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
                    //any additional data... maybe the get the describtion then pass it on to a method to display the additional info
                    
                    let coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    let location = CLLocation(coordinate: coordinate, altitude: 620)
                    self.userLoc = self.locationManager.location!
                    let distance = self.userLoc.distance(from:location) //in meters
                    print("distance: ", distance)
                    
                    if distance <= 150 { //sample distance
                    self.displayPOIobjects(latitude: latitude as! Double, longitude: longitude as! Double, image: imageData as! String)
                    }
                    else {
                        print("POI is too far away!")
                    }
                } //end for loop
            }
        }
        
    } //end func getPOI
    
    
    func displayPOIobjects(latitude: Double, longitude: Double, image: String){
        
        //set up for the image
        let url = URL(string: image)
        let data = try? Data(contentsOf: url!)
        let img = UIImage(data: data!)
        
        //create the object
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude) //noura
        let location = CLLocation(coordinate: coordinate, altitude: 620)
        
        let annotationNode = LocationAnnotationNode(location: location, image: img!)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

    }
    
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }
    
        //------------------------------------END AR--------------------------------------------

    
        //-------------------------------TRACK USER LOCATION------------------------------------
        
        func setupLocationManager() {
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
                          break
                      case .notDetermined:
                          locationManager.requestWhenInUseAuthorization()
                      case .restricted:
                          // Show an alert letting them know what's up
                          break
                      case .authorizedAlways:
                          break
                      }
                  }


           func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

               let locValue:CLLocationCoordinate2D = manager.location!.coordinate
               print("locations = \(locValue.latitude) \(locValue.longitude)")
                let userLocation = locations.last

           }


           func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
               checkLocationAuthorization()
           }
        
        //----------------------------------------------------------------------------------------------

    @IBAction func logoutTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        //Direct to sign up and login page...
        
        let mainViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController) as? ViewController
                            
                            
        self.view.window?.rootViewController = mainViewController
        self.view.window?.makeKeyAndVisible()
    }
    

}
