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
    
    static var isGuest: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    @IBAction func guestTapped(_ sender: Any) {
       
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error != nil {
                //direct to home..
                ViewController.isGuest = true
                let storyboard = UIStoryboard(name: "Guest", bundle: nil)
                let guestVC = storyboard.instantiateViewController(identifier: "GuestViewController") as! GuestViewController
                
                self.perform(#selector(self.loadTabBar))
                self.view.window?.rootViewController = guestVC
                self.view.window?.makeKeyAndVisible()
                
            }
            else {
                //handling error
                print("error")
            }

        }
        self.perform(#selector(loadTabBar))
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

    @objc func loadTabBar()
    {
        print("inside navbar")
        self.App_Delegate.AddGuestTabBar()
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let registerViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.registerViewController) as? RegisterViewController
                            
                            
        self.view.window?.rootViewController = registerViewController
        self.view.window?.makeKeyAndVisible()
        
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

