//
//  ChallengePopUpViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit

class ChallengePopUpVC: UIViewController {

     @IBOutlet var contentView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        print("inside popup")

    }
    
    @IBAction func closeTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func startTapped(_ sender: Any) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let challengeVC = storyboard.instantiateViewController(identifier: "ChallengeVC") as! ChallengeViewController
        print("inside direct")
        self.view.window?.rootViewController = challengeVC
        self.view.window?.makeKeyAndVisible()
    }
    
}
