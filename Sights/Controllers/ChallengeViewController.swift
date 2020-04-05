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
    var counter: Int = 0
    var numOfHidden: Int = 0
    @IBOutlet weak var counterView: UIImageView!
    @IBOutlet weak var chLabel: UILabel!
    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var colorBackground: UIImageView!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var numHiddenLabel: UILabel!
    @IBOutlet weak var slash: UILabel!
    
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
            view.addSubview(counterView)
            view.addSubview(chLabel)
            view.addSubview(onLabel)
            view.addSubview(colorBackground)
            view.addSubview(counterLabel)
            view.addSubview(slash)
            view.addSubview(numHiddenLabel)
            
            counterLabel.text = "\(counter)"
            
            counterView.layer.cornerRadius = 30.0
            counterView.clipsToBounds = true
            
            colorBackground.layer.cornerRadius = 25.0
            colorBackground.clipsToBounds = true
//            let double = 24.7114063
//            let doubleDigits = double.digits   // // [1, 2, 3, 4]
//
//            let randomDouble = Double.random(in: 24.7114063...24.7114999)
//            print("RANDOM LATITUDE",randomDouble)
//            print(doubleDigits)
            
            
            setNumOfHidden()
           // findHidden()
            
            //handling when an AR object is tapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
            sceneLocationView.addGestureRecognizer(tap)
            
        }// end of else
       
       

    } //end viewDidLoad
    
    @IBAction func exit(_ sender: Any) {
        
        
    }
    
    
    func findHidden() {
        var chid = ChallengeViewController.chid
        chid = chid!.trimmingCharacters(in: .whitespacesAndNewlines)
        print("***CHID",chid)
        
        db.collection("Challenges/\(chid!)/hiddenObjects").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let hoid = document.get("ID") as! String

                    print("HERE HERE HERE")
                    self.getHiddenObj(ID: hoid)
                }
                
            }
        }
    }
    

    func setNumOfHidden() {

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

                       self.numOfHidden = document.get("numOfHidden") as! Int
                        let total = document.get("numOfHidden") as! Int
                        print("TOTAL!",total)
                        self.numHiddenLabel.text = "\(total)"
                        
                        self.findHidden()

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
                sceneLocationView.removeLocationNode(locationNode: locationNode!)
                counter = counter + 1
                counterLabel.text = "\(counter)"
                if (self.counter == self.numOfHidden) {
                    print("WINNINGGGGGGGG!!!")
                    //sceneLocationView.removeAllNodes()
                    //direct to home..
                }
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

extension StringProtocol  {
    var digits: [Int] { compactMap{ $0.wholeNumberValue } }
}
extension LosslessStringConvertible {
    var string: String { .init(self) }
}
extension Numeric where Self: LosslessStringConvertible {
    var digits: [Int] { string.digits }
}
