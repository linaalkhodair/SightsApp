//
//  POIView.swift
//  Sights
//
//  Created by Lina Alkhodair on 14/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit

class POIView: UIView {

    @IBOutlet weak var POIName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var openingHours: UILabel!
    @IBOutlet weak var describtion: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet var contentView: UIView!
    var poiID = ""
    
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
        Bundle.main.loadNibNamed("POIView", owner: self, options: nil)
        addSubview(contentView)
        let r = CGRect(x: 37, y: 342, width: 300, height: 264)
        contentView.frame = r
        contentView.layer.cornerRadius = 23.0
        contentView.clipsToBounds = true
       
      //  contentView.frame = self.bounds
     //   contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

    func setPoiId(ID: String) {
        poiID = ID
    }

    @IBAction func closeBtnTapped(_ sender: Any) {
        contentView.removeFromSuperview()
        
        //self.removeFromSuperview()
//        contentView.alpha = 0
        print("Inside custom view")
        
    }
    
    
}
