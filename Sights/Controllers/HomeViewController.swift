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
import Kingfisher

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    var sceneLocationView = SceneLocationView()
     var db: Firestore!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices() // checks if location is authorized
        //start the AR view
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        db = Firestore.firestore()
        
        //--------------------------------CREATING AR OBJECTS----------------------------------
        
        
                //first
                let coordinate = CLLocationCoordinate2D(latitude: 24.775496, longitude: 46.773772) //noura
                let location = CLLocation(coordinate: coordinate, altitude: 620)
                let image = UIImage(named: "drop")!
                let annotationNode = LocationAnnotationNode(location: location, image: image)
                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

        
                //try loading images from firebase and maybe using Kingfisher
//               let docRef = self.db.collection("POIs").document("y7VpeKHTHY6fDbmcYTUj")
//                docRef.getDocument { (document, error) in
//                     if let document = document, document.exists {
//                           let property = document.get("image")
//                        print("Document data:", property)
//        //                let img = UIImage(data: property as! Data)
//
//                        let url = URL(string: property as! String)
//                        let data = try? Data(contentsOf: url!)
//                        let img = UIImage(data: data!)
//
//
//                        let annotationNode = LocationAnnotationNode(location: location, image: img!)
//                        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
//
//                       } else {
//                           print("Document does not exist")
//                       }
//                }
        
                
                
                //second
                let coordinate2 = CLLocationCoordinate2D(latitude: 24.777697, longitude: 46.767996) //drees
                let location2 = CLLocation(coordinate: coordinate2, altitude: 620)
                let image2 = UIImage(named: "drop")!
                      
                let annotationNode2 = LocationAnnotationNode(location: location2, image: image2)
                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode2)
            
                //user's location
                let userLoc = locationManager.location
                let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
                
                let coor = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
                let loc = CLLocation(coordinate: coor, altitude: 620)
               
                let distance = locationManager.location!.distance(from:location2) //in meters
                print("distance: ", distance)
               
        //handling when an AR object is tapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))

        
//                if distance > 700 {
//                    print("no objects")  // outside the range
//                }
//                else {
//                    //display objects
//                    sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode2)
//                    sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
//                }
        
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
                    let r = CGRect(x: 67, y: 606, width: 240, height: 128)
                    let view = UIView(frame: r)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: 24.775496, longitude: 46.773772) //noura
                    let location = CLLocation(coordinate: coordinate, altitude: 590)
                    let image = UIImage(named: "image")!

                    let annotationNode = LocationAnnotationNode(location: location, image: image)
                    sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

                }
           }
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      sceneLocationView.frame = view.bounds
    }
    
        //-------------------------------------------------------------------------------------

    
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
