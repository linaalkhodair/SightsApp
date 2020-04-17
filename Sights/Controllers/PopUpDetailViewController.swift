//
//  PopUpDetailViewController.swift
//  Sights
//
//  Created by HARSHIT on 23/02/20.
//  Copyright © 2020 HARSHIT. All rights reserved.
//

import UIKit
import Cosmos
import Firebase


class PopUpDetailViewController: UIViewController {
    
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
        
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Stars: CosmosView!
    @IBOutlet weak var StarsNumber: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Hours: UILabel!
    @IBOutlet weak var Desc: UITextView!
    @IBOutlet weak var ImagePOI: UIImageView!
    
    
    @IBOutlet weak var notInterested: UIButton!
    @IBOutlet weak var wantToVisit: UIButton!
    @IBOutlet weak var Visited: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 

    }
    
    override func viewWillAppear(_ animated: Bool) {
        Name.text = nameString
         Stars.rating = starsDouble
         StarsNumber.text = "(\(starsDouble))"
         Location.text = locString
         Hours.text = hoursString
         Desc.text = descString
         
         
         
         if(notinterested==true){
             notInterested.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
         }
         if(wanttovisit==true){
             wantToVisit.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
         }
         if(visited==true){
             Visited.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
         }
         if let url = URL(string: imagePOIString)
         {
             do
             {
                 let data = try Data(contentsOf: url)
                 let img = UIImage(data: data)
                 ImagePOI.image = img
             }
             catch
             {
                 print(error.localizedDescription)
             }
         }
    }
    
    func setContent(id: String ,name : String, loc: String, stars: Double, hours : String, desc: String, img: String, want: Bool, visit: Bool, not: Bool){
        ID = id
        nameString = name
        starsDouble = stars
        locString = loc
        hoursString = hours
        descString = desc
        imagePOIString = img
        wanttovisit = want
        visited = visit
        notinterested = not
    }
    
    @IBAction func clk_Close()
    {
        self.dismiss(animated: true, completion: nil)
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
        print("notintereste   "+String(notinterested))
        if(notinterested==true){
            if(wanttovisit == true && notinterested == true){
                wanttovisit = false
                wantToVisit.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }//end if want && not
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
        print("wanttovisit   "+String(wanttovisit))

        if(wanttovisit==true){
            if(visited == true && wanttovisit == true){
                visited = false
                Visited.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
            if(notinterested == true && wanttovisit == true){
                notinterested = false
                notInterested.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
            wantToVisit.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else{
            wantToVisit.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        //button.isSelected = !button.isSelected
    }
    
    @IBAction func clk_Visited(button:UIButton)
    {
        visited = !visited
        print("visited   "+String(visited))
        if(visited==true){
            if(wanttovisit == true && visited == true){
                wanttovisit = false
                wantToVisit.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            Visited.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else{
            Visited.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        //button.isSelected = !button.isSelected
    }
    
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
        
    }
    
    //this method mark a POI as not interested
    func markAsNotInterested(poi: POI){
        poi.notinterested.toggle()

    }//end markAsNotInterested
    
    
}
