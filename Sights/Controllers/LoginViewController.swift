//
//  LoginViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase

//to dismiss keyboard when tapping anywhere
extension UIViewController{
func hideKeyboard (){
    let Tap:UITapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(Tap)
                    }
@objc func dismissKeyboard () {
    view.endEditing(true)
                              }
                        }
class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        email.layer.cornerRadius = 15.0 //make the fields rounded
        email.clipsToBounds = true
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func signInTapped(_ sender: Any) {
        
        let password = "123456"
        var isValid = validateFields()
        if ( isValid == nil ) {
            Auth.auth().signIn(withEmail: email.text ?? "", password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if error != nil {
                    print(error)
                    
                    if error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        
                        Alert.showBasicAlert(on: self!, with: "Something went wrong!", message: "There is no user record coressponding to this email. Please use a registered email and try again.")
                    }
                    
                    if !CheckInternet.Connection(){
                        Alert.showBasicAlert(on: self!, with: "WiFi is Turned Off", message: "Please turn on cellular data or use Wi-Fi to access data.")
                    }
                }
                else {
                    if Auth.auth().currentUser!.isEmailVerified {
                        //direct to home..
                        let homeViewController = self?.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                        
                        self?.view.window?.rootViewController = homeViewController
                        self?.view.window?.makeKeyAndVisible()
                        
                        //performSegue(withIdentifier: "HomeVC", sender: self)
                        
                        print("success")
                    }
                    else{
                        //please verify and don't direct to home
                        print("please verify")
                        let uialert = UIAlertController(title: "Email is not verified!", message: "Email address entered is not verified, please verify your email and try again." , preferredStyle: UIAlertController.Style.alert)
                        uialert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self?.present(uialert, animated: true, completion: nil)
                    }
                }
            }
            
            
            
        } else {
            
            let uialert = UIAlertController(title: "Something went wrong!", message: isValid , preferredStyle: UIAlertController.Style.alert)
            uialert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(uialert, animated: true, completion: nil)
        }
        
        
    }// end of func
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            return "There's a missing field, please fill in all fields and try again."
        }
        //validate email
        if !isValidEmail(email.text!){
            return "Invalid email format, please use a valid email and try again."
        }
        
        //if all is validated
        return nil
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
