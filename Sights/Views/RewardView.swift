//
//  RewardView.swift
//  Sights
//
//  Created by Lina Alkhodair on 05/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import Foundation
import UIKit

class RewardView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var couponCode: UILabel!
    
    
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
        Bundle.main.loadNibNamed("RewardView", owner: self, options: nil)
        addSubview(contentView)
        let r = CGRect(x: 37, y: 342, width: 300, height: 300)
        contentView.frame = r
        contentView.layer.cornerRadius = contentView.frame.height/2
        //contentView.layer.cornerRadius = 100.0
        contentView.clipsToBounds = true
    
    }

    @IBAction func closeTapped(_ sender: Any) {
        contentView.removeFromSuperview()
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        
        
    }
    

    
}
