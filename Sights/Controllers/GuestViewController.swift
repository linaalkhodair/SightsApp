//
//  GuestViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 01/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit

class GuestViewController: UIViewController {

    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUp.layer.cornerRadius = 25.0 //make the button rounded
        signUp.clipsToBounds = true
        
        login.layer.cornerRadius = 25.0 //make the button rounded
        login.clipsToBounds = true
    }
    

//    @IBAction func signUpTapped(_ sender: Any) {
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let registerVC = storyboard.instantiateViewController(identifier: "registerVC") as! RegisterViewController
//
//
//        //UserDefaults.standard.set(true, forKey: "isGuestClicked")
//
//        self.view.window?.rootViewController = registerVC
//        self.view.window?.makeKeyAndVisible()
//
//    }


}
