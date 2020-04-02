//
//  Challenge.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Challenge {
    
    var ID: String
    var instructions: String
    var hiddenObjectId: String
    var numOfHidden: Int
    var reward: String
    
    var db: Firestore!
    
    init(ID: String, instructions: String, hiddenObject: String, numOfHidden: Int, reward: String) {
        
        self.ID = ID
        self.instructions = instructions
        self.hiddenObjectId = hiddenObject
        self.numOfHidden = numOfHidden
        self.reward = reward
        db = Firestore.firestore()
        
    }
    init() {
        ID = ""
        instructions = ""
        hiddenObjectId = ""
        numOfHidden = 0
        reward = ""
        db = Firestore.firestore()
    }
    
    func getHiddenId(ID: String, completionHandler: @escaping (String)->Void) {
        var id = ""
                self.db.collection("Challenges").whereField("ID", isEqualTo: ID)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
        
                                id = document.get("hiddenObjectId") as! String
                                completionHandler(id)
                                print("hiddenobjdd",id)
                            }
                        }
                }
    }
    
    func getChallenge(ID: String) {
        var id = ""
        var hiddenObj = HiddenObject()
        getHiddenId(ID: ID) { (hiddenId) in
            id = hiddenId
            
            print("id after",hiddenId)
            
            hiddenObj = hiddenObj.getHiddenObj(ID: id)
            print("image url ----",hiddenObj.image)
            
        }
        
        //return hiddenObj
    
    }
}
