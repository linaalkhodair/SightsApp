////
////  ChallengeView.swift
////  Sights
////
////  Created by Lina Alkhodair on 02/04/2020.
////  Copyright © 2020 Lina Alkhodair. All rights reserved.
////
//
//
//import UIKit
//import Firebase
//
//class ChallengeView: UIView {
//
//
//    @IBOutlet var contentView: UIView!
//    static var start: Bool  = false
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        self.frame = UIScreen.main.bounds
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        Bundle.main.loadNibNamed("ChallengeView", owner: self, options: nil)
//        addSubview(contentView)
//        let r = CGRect(x: 37, y: 342, width: 375, height: 367)
//        contentView.frame = r
//        contentView.layer.cornerRadius = 30.0
//        contentView.clipsToBounds = true
//        //print("uid:",Auth.auth().currentUser?.uid)
//      //  contentView.frame = self.bounds
//     //   contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
//
//    }
//
//
//
//    @IBAction func closeBtnTapped(_ sender: Any) {
//        contentView.removeFromSuperview()
//
//        //self.removeFromSuperview()
////        contentView.alpha = 0
//        print("Inside custom view")
//
//    }
//
//    @IBAction func startTapped(_ sender: Any){
//        print("start inside challenge view")
//        ChallengeView.start = true
//
//       contentView.removeFromSuperview()
//       let home = HomeViewController()
//       home.directToChallenge()
//
//    }
//
//}
