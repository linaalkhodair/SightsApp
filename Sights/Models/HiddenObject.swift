//
//  HiddenObjects.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import Foundation
import Firebase

class HiddenObject {
    
    var ID: String
    var image: String
    var latitude: Double
    var longitude: Double
    
    var db: Firestore!
    
    init(ID: String, image: String, latitude: Double, longitude: Double) {
        
        self.ID = ID
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        db = Firestore.firestore()
    }
    
    init(){
        self.ID = ""
        self.image = ""
        self.latitude = 0
        self.longitude = 0
        db = Firestore.firestore()

    }
    func getHiddenObj(ID: String) -> HiddenObject {
        print("ID insideHIDOBJ",ID)
        db.collection("HiddenObjects").whereField("ID", isEqualTo: ID)
             .getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in querySnapshot!.documents {
                         
                         self.ID = document.get("ID") as! String
                         self.image = document.get("image") as! String
                         self.latitude = document.get("latitude") as! Double
                         self.longitude = document.get("longitude") as! Double
                        
                     }
                 }
         }
        
        let hiddenObject = HiddenObject(ID: self.ID, image: self.image, latitude: self.latitude, longitude: self.longitude)
        return hiddenObject
    
    }
    
}
