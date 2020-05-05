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

class RewardViewController: UIViewController {

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
                           //Show alert informing#imageLiteral(resourceName: "SimplePDF.pdf") the user
                            return
                   }
                let composer = MFMailComposeViewController()
                   composer.mailComposeDelegate = self
                   composer.setToRecipients([email])
                   composer.setSubject("Reward from Sights!")
                   composer.setMessageBody("Coupon code: \(self.reward)", isHTML: false)
                   guard let filePath = Bundle.main.path(forResource: "Reward", ofType: "gif") else {
                       return }
        
                let url = URL(fileURLWithPath: filePath)
                  do {
                 let attachmentData = try Data(contentsOf: url)
                      composer.addAttachmentData(attachmentData, mimeType: "image/gif", fileName: "Reward")
                    composer.mailComposeDelegate = self
                  self.present(composer, animated: true, completion: nil)
                 } catch let error {
                      print("We have encountered error \(error.localizedDescription)")
                  }
               }
    
    @IBAction func closeTapped(_ sender: Any) {
        //direct to HOMEVC
        view.removeFromSuperview()
        contentView.removeFromSuperview()
        
        directToHome() //?
        
    }
    
    @objc func loadTabBar()
    {
        self.App_Delegate.AddTabBar()
    }
}



extension RewardViewController: MFMailComposeViewControllerDelegate {

 func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
         switch result {
               case .cancelled:
                   print("User cancelled")
                   break

               case .saved:
                   print("Mail is saved by user")
                   break

               case .sent:
                   print("Mail is sent successfully")
                   break

               case .failed:
                   print("Sending mail is failed")
                   break
               default:
                   break
               }

               controller.dismiss(animated: true)
               directToHome()

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
