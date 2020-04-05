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
import ARKit

class ChallengeViewController: UIViewController, CLLocationManagerDelegate {
    
    var sceneLocationView = SceneLocationView()
    
    var db: Firestore!
    static var chid: String!
    let regionInMeters: Double = 10000
    var userLoc = CLLocation()

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
            self.startChallenge()
            
            //handling when an AR object is tapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
            sceneLocationView.addGestureRecognizer(tap)
            
        }// end of else
       
       

    } //end viewDidLoad
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)

        
        
    }


    func startChallenge() {

        print("chid",ChallengeViewController.chid)
        var chid = ChallengeViewController.chid
        chid = chid!.trimmingCharacters(in: .whitespacesAndNewlines)
        print("***CHID",chid)
        
        db.collection("Challenges").whereField("ID", isEqualTo: chid!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                       let hoid = document.get("hiddenObjectId") as! String
                        print("hoid",hoid)

                        self.getHiddenObj(ID: hoid)


                    }
                }
        }
        // return hoid
    }
    
    func getHiddenObj(ID: String) {

        let hobj = HiddenObject()
        db.collection("HiddenObjects").whereField("ID", isEqualTo: ID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("idinside",ID)
                            print("inside CVC")
                            hobj.ID = document.get("ID") as! String
                            print(document.get("ID") as! String)
                            hobj.latitude = document.get("latitude") as! Double
                            hobj.longitude = document.get("longitude") as! Double
                            hobj.image = document.get("image") as! String
                           self.displayHiddenObjects(hiddenObject: hobj)
                            
                        }
                    }
            }
        
        }
        
    
    
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
    
    
    func displayHiddenObjects(hiddenObject: HiddenObject){

        //set up for the image
        let url = URL(string: hiddenObject.image)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)

        //create the object
        let coordinate = CLLocationCoordinate2D(latitude: hiddenObject.latitude, longitude: hiddenObject.longitude)
        let location = CLLocation(coordinate: coordinate, altitude: 620)

        let annotationNode = LocationAnnotationNode(location: location, image: image!)
        annotationNode.name = hiddenObject.ID
        annotationNode.scaleRelativeToDistance = false
        annotationNode.ignoreAltitude = false
        annotationNode.continuallyUpdatePositionAndScale = false
        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
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
