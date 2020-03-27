//
//  DrivingPopUp.swift
//  Sights
//
//  Created by Lina Alkhodair on 27/03/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit

class DrivingPopUp: UIView {
    @IBOutlet var contentView: UIView!
    
        override init(frame: CGRect) {
            super.init(frame: frame)
    //        self.frame = UIScreen.main.bounds
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DrivingPopUp", owner: self, options: nil)
        addSubview(contentView)
        let r = CGRect(x: 37, y: 342, width: 316, height: 202)
        contentView.frame = r
        contentView.layer.cornerRadius = 23.0
        contentView.clipsToBounds = true

        
    }
    @IBAction func closeTapped(_ sender: Any) {
        contentView.removeFromSuperview()
    }
    
}
