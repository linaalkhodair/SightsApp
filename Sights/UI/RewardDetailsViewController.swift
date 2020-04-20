//
//  RewardDetailsViewController.swift
//  Sights
//
//  Created by Shahad Nasser on 19/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class RewardDetailsViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet var rewardView: UIView!
    
    
    var code = "code"
    var place = "use it at place"
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        emailButton.layer.cornerRadius = 20
        emailButton.clipsToBounds = true
        rewardView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        codeLabel.text = code
        placeLabel.text = place
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setContent(Code : String,Place :String){
        code = Code
        place = Place
    }
    
    
    @IBAction func EmailReward(_ sender: Any) {
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
        composer.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
                   composer.setToRecipients([email])
                   composer.setSubject("Reward from Sights!")
                   composer.setMessageBody("", isHTML: false)
                   guard let filePath = Bundle.main.path(forResource: "Rewards", ofType: "pdf") else {
                       return }
        
                let url = URL(fileURLWithPath: filePath)
                  do {
                 let attachmentData = try Data(contentsOf: url)
                    composer.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: "Rewards")
                    composer.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
                  self.present(composer, animated: true, completion: nil)
                 } catch let error {
                      print("We have encountered error \(error.localizedDescription)")
                  }
               }

}

extension RewardDetailsViewController: MFMailComposeViewControllerDelegate {

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

   }

}
