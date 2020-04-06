//
//  ChallengePopUpViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase

class ChallengePopUpVC: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var reward: UILabel!
    var db: Firestore!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        

        contentView.layer.cornerRadius = 30.0
        contentView.clipsToBounds = true
        
        db = Firestore.firestore()
        
       setInstructions()

        print("inside popup")

    }
    
    func setInstructions(){
        
        var chid = ChallengeViewController.chid
        chid = chid?.trimmingCharacters(in: .whitespacesAndNewlines)
        db.collection("Challenges").document(chid!).getDocument { (documentSnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let inst = documentSnapshot?.get("instructions") as! String
                self.instructions.text = inst
            }
        }
        
    }
    
    
    
    @IBAction func closeTapped(_ sender: Any) {
        
        view.removeFromSuperview()
        contentView.removeFromSuperview()

    }
    
    
    @IBAction func startTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let challengeVC = storyboard.instantiateViewController(identifier: "ChallengeVC") as! ChallengeViewController
        print("inside direct")
                
        self.view.window?.rootViewController = challengeVC
        self.view.window?.makeKeyAndVisible()
        
        self.view.removeFromSuperview()
        self.contentView.removeFromSuperview()
        
    }
    
}
