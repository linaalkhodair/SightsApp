//
//  RewardViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 06/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class RewardViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var rewardLabel: UILabel!
    
    var db: Firestore!
    var reward: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setReward()
        
        contentView.layer.cornerRadius = contentView.frame.height/2
        contentView.clipsToBounds = true
        
    }
    
    func setReward() {
        
        var chid = ChallengeViewController.chid
         chid = chid?.trimmingCharacters(in: .whitespacesAndNewlines)
         db.collection("Challenges").document(chid!).getDocument { (documentSnapshot, err) in
             
             if let err = err {
                 print("Error getting documents: \(err)")
             } else {
                self.reward = documentSnapshot?.get("reward") as! String
                self.rewardLabel.text = self.reward
             }
         }
    }

    @IBAction func sendEmail(_ sender: Any) {
        
        //send email then direct to home.
        getUserEmail()
        
        
    }
    
    func getUserEmail() {
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("users").document(uid!).getDocument { (documentSnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
               let email = documentSnapshot?.get("email") as! String
                self.showMailComposer(email: email)
            }
        }
    }
    
    func showMailComposer(email: String) {
            
        guard MFMailComposeViewController.canSendMail() else {
                //Show alert informing the user
                return
        }
            
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([email])
        composer.setSubject("Reward from Sights!")
        composer.setMessageBody("Thank you for using Sights, your reward \(reward)", isHTML: false)
            
        present(composer, animated: true)
       
    }
    

    
    @IBAction func closeTapped(_ sender: Any) {
        //direct to HOMEVC
        view.removeFromSuperview()
        contentView.removeFromSuperview()
        
    }
    
    @objc func loadTabBar()
    {
        self.App_Delegate.AddTabBar()
    }
}



extension ViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, didFinishWith error: Error?) {
    
    if let _ = error {
        //Show error alert
        controller.dismiss(animated: true)
        return
    }
    
    switch result {
    case .cancelled:
        print("Cancelled")
        directToHome()
    case .failed:
        print("Failed to send")
    case .saved:
        print("Saved")
        directToHome()
    case .sent:
        print("Email Sent")
        directToHome()
    @unknown default:
        break
    }
    
    controller.dismiss(animated: true)
    }
    
    func directToHome(){
        
        let storyboard = UIStoryboard(name: "SecondMain", bundle: nil)
        let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        print("inside direct")
    
        self.view.window?.rootViewController = homeVC
        self.view.window?.makeKeyAndVisible()
        
        self.perform(#selector(self.loadTabBar))
    }
}
