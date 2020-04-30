//
//  User.swift
//  Sights
//
//  Created by Shahad Nasser on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.

import Foundation
import Firebase
import Firebase

class user {

    var db: Firestore!
    
    
var ID: String
var name: String
var email: String
var rewardList: [POI]
var markedList: [POI] //retreive
var recommendationCategories: [category]

// not in db
var visitedList: [POI]
var wanttovisitList: [POI]
var notInterestedList: [POI]
var notiList: [POI]
    
internal init(ID: String, name: String, email: String, rewardList: [POI], markedList: [POI], recommendationcategories: [category]) {
    self.ID = ID
    self.name = name
    self.email = email
    self.rewardList = rewardList
    self.markedList = markedList
    self.recommendationCategories = recommendationcategories
    self.visitedList = [POI]()
    self.wanttovisitList = [POI]()
    self.notInterestedList = [POI]()
    self.notiList = [POI]()
    
}
    
//==============================================================================================//

}//end user
