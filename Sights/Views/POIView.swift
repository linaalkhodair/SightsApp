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
    
    var ID : String = "id"
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
        
        //Guest user cannot mark POI
        let user = Auth.auth().currentUser
        let isAnon = user?.isAnonymous
        
        if isAnon ?? true {
            notInterested.alpha = 0
            Visited.alpha = 0
            wantToVisit.alpha = 0
        }

        
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
        
        updateMark(mark: "notInterested", value: notinterested, poiId: ID)
        updateMark(mark: "visited", value: visited, poiId: ID)
        updateMark(mark: "wantToVisit", value: wanttovisit, poiId: ID)
        
        globalPOI.notinterested = notinterested
        globalPOI.visited = visited
        globalPOI.wanttovisit = wanttovisit
        
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
    
        
    //*********ADD MARK STATES TO USER OFFICIALLY********
    
    func updateMark(mark: String, value: Bool, poiId: String){
        let userID = Auth.auth().currentUser!.uid
        var db = Firestore.firestore()
        //db.collection("users").document(userID).collection("markedList").document(ID).updateData([mark : value])
        let userRef = db.collection("users").document(userID).collection("markedList").document(ID)
        
        // Set the "capital" field of the city 'DC'
        userRef.updateData([
            mark+"" : value
        ]) { err in
            if let err = err {
                if(!(self.notinterested==false && self.visited==false && self.wanttovisit==false)){
                db.collection("users").document(userID).collection("markedList").document(self.ID).setData([
                        "wantToVisit": self.wanttovisit,
                        "visited": self.visited,
                        "notInterested": self.notinterested
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
                print("!!!!!!!!!!!!Error updating document: \(err.localizedDescription)")
            } else {
                print("!!!!!!!!!!!!Document successfully updated")
            }
        }
        
    } //end func updateMark

    
}
