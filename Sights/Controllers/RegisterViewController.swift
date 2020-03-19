//
//  RegisterViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase

//to dismiss keyboard when tapping anywhere
extension UIViewController{
func HideKeyboard (){
    let Tap:UITapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(DismissKeyboard))
    view.addGestureRecognizer(Tap)
                    }
@objc func DismissKeyboard () {
    view.endEditing(true)
                              }
                        }

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.layer.cornerRadius = 15.0 //make the fields rounded
        name.clipsToBounds = true
        
        email.layer.cornerRadius = 15.0 //make the fields rounded
        email.clipsToBounds = true
        
        db = Firestore.firestore()
        self.HideKeyboard()
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate fields
        let isValid = validateFields()
        let passowrd = "123456"
        //Create User (Auth)
        if (isValid == nil ) {
            
            Auth.auth().createUser(withEmail: email.text ?? "", password: passowrd) { authResult, error in
                
                if error != nil {
                    if error?.localizedDescription == "The email address is already in use by another account." {
                        
                        //  display alert
                        //  Handling already existing email
                        let alert = UIAlertController(title: "Something went wrong!", message: "The email address is already in use by another account, please try again." , preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if !CheckInternet.Connection(){
                        Alert.showBasicAlert(on: self, with: "WiFi is Turned Off", message: "Please turn on cellular data or use Wi-Fi to access data.")
                    }
                    
                    print(error)
                }
                else {
                    let uid = authResult!.user.uid
                    
                    //Store in DB
                    self.db.collection("users").document(uid).setData([
                        "email": self.email.text,
                        "name": self.name.text
                    ])
                    
                    self.sendVerificationMail()
                    print("success")
                    
                    let alert = UIAlertController(title: "Account created successfully!", message: "Please verify your email, then login to your account." , preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: {
                        (action: UIAlertAction!) in
                        
                        // Transition to Login Screen
                        let loginViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
                        
                        self.view.window?.rootViewController = loginViewController
                        self.view.window?.makeKeyAndVisible()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
            
            
        } //end if
        else {
            print(isValid)
            //display alert
            let uialert = UIAlertController(title: "Something went wrong!", message: isValid , preferredStyle: UIAlertController.Style.alert)
            uialert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(uialert, animated: true, completion: nil)
        }
        
        
        
    } //end func signUpTapped
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        
        // Check that all fields are filled in
        if name.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            
            return "There's a missing field, please fill in all fields and try again."
        }
        
        //validate email format
        if !isValidEmail(email.text!){
            
            return "Invalid email format, please use a valid email and try again."
        }
        
        return nil
        
    }
    
    
    //Regular experession to check the format of the email
    func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    public func sendVerificationMail() {
        
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
                
                let uialert = UIAlertController(title: "Something went wrong!", message: "Verification email coudldn't be sent, please try again." , preferredStyle: UIAlertController.Style.alert)
                uialert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(uialert, animated: true, completion: nil)
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
        }
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
