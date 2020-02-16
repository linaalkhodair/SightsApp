//
//  ViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    
    @IBAction func guestTapped(_ sender: Any) {
       
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error != nil {
                //direct to home..
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                                    
                // let homeViewController = self?.storyboard?.instantiateViewController(withIdentifier:  "HomeVC")
                                    
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()            }
            else {
                //handling error
                print("error")
            }
            
        }
      //  guard let user = authResult?.user else { return }
       // let isAnonymous = user.isAnonymous  // true
    }
    
    override func viewDidAppear(_ animated: Bool) {

          if CheckInternet.Connection(){


          }

          else{
            Alert.showBasicAlert(on: self, with: "WiFi is Turned Off", message: "Please turn on cellular data or use Wi-Fi to access data.")

          }

      }
//
    @IBAction func signUpTapped(_ sender: Any) {
        
        let registerViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.registerViewController) as? RegisterViewController
                            
                            
        self.view.window?.rootViewController = registerViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
}

