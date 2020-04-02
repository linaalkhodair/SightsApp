//
//  ChallengeViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase
import ARCL
import CoreLocation
import SceneKit

class ChallengeViewController: UIViewController {
    
    var sceneLocationView = SceneLocationView()
   // var poiview = POIView()

    var db: Firestore!

    let regionInMeters: Double = 10000
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CheckInternet.Connection(){
            
            sceneLocationView.run()
            view.addSubview(sceneLocationView)
                        
            Alert.showBasicAlert(on: self, with: "WiFi is Turned Off", message: "Please turn on cellular data or use  Wi-Fi to access data.")

            
        }
        else {
            print("inside challenges")
            //start the AR view
            sceneLocationView.run()
            
            view.addSubview(sceneLocationView)
            db = Firestore.firestore()
            
            displayHiddenObjects()
            
            //Adding the popup view for additional info
            //view.addSubview(poiview.contentView)

            //poiview.contentView.alpha = 0
            //drivingPopup.contentView.alpha = 0

            //--------------------------------CREATING AR OBJECTS----------------------------------------------------------------------

            
            //handling when an AR object is tapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
            sceneLocationView.addGestureRecognizer(tap)
            
        }// end of else
       
 

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
                
              //  let poiView = setPOIView(ID: ID!)
                
            }
        }
    }
    
    
    
    //---------------------------------------------------------------------------------------------------------------
    
    func setChallengeView(ID: String)  {
     
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
    
        
    //---------------------------------------------------------------------------------------------------------------
    
    
     func displayHiddenObjects(){
        
        let challenge = Challenge()
        //print("challengID", HomeViewController.challengeID)
       // let hiddenObject = challenge.getChallenge(ID: HomeViewController.challengeID)
        challenge.getChallenge(ID: HomeViewController.challengeID)
        
        //set up for the image
//        let url = URL(string: hiddenObject.image)
//        print("url",url)
//        let data = try? Data(contentsOf: url!)
//        let image = UIImage(data: data!)
//
//        //create the object
//        let coordinate = CLLocationCoordinate2D(latitude: hiddenObject.latitude, longitude: hiddenObject.longitude)
//        let location = CLLocation(coordinate: coordinate, altitude: 620)
//
//        let annotationNode = LocationAnnotationNode(location: location, image: image!)
//        annotationNode.name = hiddenObject.ID
//        annotationNode.scaleRelativeToDistance = false
//        annotationNode.ignoreAltitude = false
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    //------------------------------------END AR--------------------------------------------
    
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
