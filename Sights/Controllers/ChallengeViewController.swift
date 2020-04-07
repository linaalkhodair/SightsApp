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
import SAConfettiView
import AVFoundation

class ChallengeViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
//    var audioPlayer2 = AVAudioPlayer()

    var sceneLocationView = SceneLocationView()
    
    var db: Firestore!
    static var chid: String!
    let regionInMeters: Double = 10000
    var userLoc = CLLocation()
    var counter: Int = 0
    var numOfHidden: Int = 0
    let rewardView = RewardView()
    var reward: String = ""
    
    @IBOutlet weak var counterView: UIImageView!
    @IBOutlet weak var chLabel: UILabel!
    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var colorBackground: UIImageView!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var numHiddenLabel: UILabel!
    @IBOutlet weak var slash: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
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
            view.addSubview(closeBtn)
            
            counterLabel.text = "\(counter)"
            
            counterView.layer.cornerRadius = 40.0
            counterView.clipsToBounds = true
        
            colorBackground.layer.cornerRadius = 23.0
            colorBackground.clipsToBounds = true
            
            view.addSubview(rewardView.contentView)
            rewardView.contentView.alpha = 0
                        
            setNumOfHidden()
           
            //handling when an AR object is tapped
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
            sceneLocationView.addGestureRecognizer(tap)
            
//            randomLocation(lat: 24.711359, lng: 46.769160)
            
        }// end of else
       
       //sound file
        let sound = Bundle.main.path(forResource: "sound", ofType: "mp3")
//        let sound2 = Bundle.main.path(forResource: "clapping", ofType: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
//          audioPlayer2 =  try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound2!))
        }
        catch{
            print(error)
        }

    } //end viewDidLoad
    
    @IBAction func exit(_ sender: Any) {
        
        print("entered...")
        let alert = UIAlertController(title: "Are you sure you want to quit the challenge ?", message: "If you quit all collected objects will be gone, and you won't recieve a reward." , preferredStyle: UIAlertController.Style.alert)
        
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            
            // Transition to Home Screen
            let storyboard = UIStoryboard(name: "SecondMain", bundle: nil)
            let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            print("inside direct")
                    
            self.view.window?.rootViewController = homeVC
            self.view.window?.makeKeyAndVisible()
            
            self.perform(#selector(self.loadTabBar))
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        
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
                       self.reward = document.get("reward") as! String
                        self.rewardView.couponCode.text = self.reward
                        
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
                            
                            let latitude = document.get("latitude") as! Double
                            let longitude = document.get("longitude") as! Double
                            let loc = self.randomLocation(lat: latitude, lng: longitude)
                            
                            hobj.latitude = loc.latitude
                            hobj.longitude = loc.longitude
                            
                            hobj.image = document.get("image") as! String
                           self.displayHiddenObjects(hiddenObject: hobj)
                            
                        }
                    }
            }
        
    }
        
    func randomCoordinates(coordinate: Double) -> Double {
        
        let start = coordinate
        let limit = coordinate + 0.000111
        let randomDouble = Double.random(in: start...limit)
        print("random ",randomDouble)
        return randomDouble
        
    } //Another randomizing func
    
    func randomLocation(lat: Double, lng: Double) -> CLLocationCoordinate2D {
        
        let radiusInDeg: Double = 200 / 111320 // 100 is the radius we can change it
        let u = Double.random(in: 0...1)
        let v = Double.random(in: 0...1)
        let w = radiusInDeg * sqrt(u)
        let t = 2 * Double.pi * v
        
        let x = w * cos(t)
        let y = w * sin(t)
        
        let new_x = x / cos(lat.degreesToRadians)
        
        let finalLat = lat + y
        let finalLng = lng + new_x
        
       // print("NEW LAT",finalLat)
       // print("NEW LNG",finalLng)
        
        let coordinates = CLLocationCoordinate2D(latitude: finalLat, longitude: finalLng)
        
        return coordinates
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
                audioPlayer.play() //play sound effect 
                counter = counter + 1
                counterLabel.text = "\(counter)"
                if (self.counter == self.numOfHidden) {
                    
                    print("WINNINGGGGGGGG!!!")
                   // rewardView.contentView.alpha = 0.95
                    let confettiView = SAConfettiView(frame: self.view.bounds)
                    self.view.addSubview(confettiView)
                    confettiView.type = .Confetti
                    confettiView.startConfetti()
//                    audioPlayer2.play() 
                    addRewardToUser()
                    
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RewardViewController") as! RewardViewController

                    self.addChild(popOverVC)

                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParent: self)
                }
                //its adding them on top of each other
                print("ID:", locationNode!.name!)
                let ID = locationNode?.name
                
              //  let poiView = setPOIView(ID: ID!)
                
            }
        }
    }
    
    
    //---------------------------------------------------------------------------------------------------------------
    
    func addRewardToUser(){
        
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("users/\(uid!)/rewards").addDocument(data:[
            "reward" : reward
        ])
        
        db.collection("users").document(uid!).updateData([
            "playedChallenge" : true
        ])
        
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

    @objc func loadTabBar()
    {
        print("inside navbar")
        self.App_Delegate.AddTabBar()
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
