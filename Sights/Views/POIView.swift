//
//  POIView.swift
//  Sights
//
//  Created by Lina Alkhodair on 14/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase

class POIView: UIView {
    
    var nameString : String = "name"
    var starsDouble : Double = 5.0
    var locString : String = "location"
    var hoursString : String = "hours"
    var descString : String = " desc"
    var imagePOIString : String = "url"
    var wanttovisit : Bool = false
    var visited : Bool = false
    var notinterested : Bool = false
    
    

    @IBOutlet weak var POIName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var openingHours: UILabel!
    @IBOutlet weak var describtion: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var notInterested: UIButton!
    @IBOutlet weak var Visited: UIButton!
    @IBOutlet weak var wantToVisit: UIButton!
    
    
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
        


        
    }
    
    func setContent(){
        
        POIName.text = nameString
        //Stars.rating = starsDouble
        //StarsNumber.text = "(\(starsDouble))"
        location.text = locString
        openingHours.text = hoursString
        describtion.text = descString
        
        if(notinterested==true){
            notInterested.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        if(wanttovisit==true){
            wantToVisit.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        if(visited==true){
            Visited.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
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
    
    
    @IBAction func clk_NotInterested(button:UIButton)
    {
        notinterested = !notinterested
        if(notinterested==true){
            notInterested.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            //db
        }else{
            notInterested.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        //button.isSelected = !button.isSelected
    }
    
    @IBAction func clk_WantToVisit(button:UIButton)
    {
        wanttovisit = !wanttovisit
        if(wanttovisit==true){
            wantToVisit.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else{
            wantToVisit.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        //button.isSelected = !button.isSelected
    }
    
    @IBAction func clk_Visited(button:UIButton)
    {
        visited = !visited
        if(visited==true){
            Visited.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else{
            Visited.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        //button.isSelected = !button.isSelected
    }
    
    //handle when a guest user tries to tap on of the marking options -> telling them to register for more features etc.
    //  guard let user = authResult?.user else { return }
    // let isAnonymous = user.isAnonymous  // true
    
    
    //*********ADD MARK STATES TO USER OFFICIALLY********
    
}
