//
//  User.swift
//  Sights
//
//  Created by Shahad Nasser on 20/03/2020.
//  Copyright © 2020 HARSHIT. All rights reserved.
//

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
    
//    loadUserData()
}
    
//==============================================================================================//

    func loadUserData(){
        
        db = Firestore.firestore()
        //let userID = Auth.auth().currentUser!.uid
        let userID = "5x141iiWqQT5Wk5GEjMTO6CXrDw2"
        print("@#@#@#@#@#@#@#@#@#@#@#@# I'm before db first call")
        db.collection("users").document(userID).collection("markedList").getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("@#@#@#@#@#@#@#@#@#@#@#@# I'm in error1")
                    print("Error getting documents: \(err)")
                } else {
                    print("@#@#@#@#@#@#@#@#@#@#@#@# yay no error1")

                    for userdocument in querySnapshot!.documents {
                        self.db.collection("POIs").document(userdocument.documentID+"").getDocument(){ (document, error) in
                            if let document = document, document.exists {
                                print("@#@#@#@#@#@#@#@#@#@#@#@# yay no error2")
                                print("@#@#@#@#@#@#@#@#@#@#@#@# " + document.documentID + "  " + userdocument.documentID)

                                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                                //print("Document data: \(dataDescription)")
//                                let poi = POI(ID: document.documentID, name: document.get("name") as! String, rate: document.get("rating") as! Double, long: document.get("longitude") as! Double, lat:document.get("latitude") as! Double, visited: userdocument.get("visited") as! Bool, notinterested: userdocument.get("notInterested") as! Bool, wanttovisit: userdocument.get("wantToVisit") as! Bool, description: document.get("briefInfo") as! String, openingHours: document.get("openingHours") as! String, locationName: document.get("location") as! String, imgUrl: document.get("image") as! String, category: document.get("category") as! String)
                                
//                                print("@#@#@#@#@#@#@#@#@#@#@#@# " + poi.ID + "  " + poi.name)
//
//                                self.markedList.append(poi)
                                for p in self.markedList{
                                    print("&&&&&&&&&&&&&&&&&&&&& && && && : " + p.name)
                                }
                            } else {
                                print("@#@#@#@#@#@#@#@#@#@#@#@# error2")

                                print("Document does not exist")
                            }
                        }

                    }//end for
            }//end else
        }//
    }//end func
    
//==============================================================================================//
    
    //this method mark a POI as visited
    func markAsVisited(poi: POI){
        poi.visited.toggle()
        categorize(poi: poi, mark: poi.visited)
        if(poi.wanttovisit == true && poi.visited == true){
            poi.wanttovisit = false
            categorize(poi: poi, mark: poi.wanttovisit)
            for (index, p) in wanttovisitList.enumerated(){
                if(poi.ID == p.ID){
                    wanttovisitList.remove(at: index)
                }
            }//end for
        }//end if want && visited
        if(!poi.visited){
            for (index, p) in visitedList.enumerated(){
                if(poi.ID == p.ID){
                    visitedList.remove(at: index)
                }
            }//end for
        }//end if visited
        sortPOI(poi3: poi)
        recommendationCategories.sort(by: { $0.count > $1.count })
        
    }//end markAsVisited
    
//==============================================================================================//
    
    //this method mark a POI as want to visit
    func markAsWantToVisit(poi: POI){
        poi.wanttovisit.toggle()
        categorize(poi: poi, mark: poi.wanttovisit)
        if(poi.visited == true && poi.wanttovisit == true){
            poi.visited = false
            categorize(poi: poi, mark: poi.visited)
            for (index, p) in visitedList.enumerated(){
                if(poi.ID == p.ID){
                    visitedList.remove(at: index)
                }
            }//end for
        }//end if visited && want
        if(poi.notinterested == true && poi.wanttovisit == true){
            poi.notinterested = false
            notCategorize(poi: poi, mark: poi.notinterested)
            for (index, p) in notInterestedList.enumerated(){
                if(poi.ID == p.ID){
                    notInterestedList.remove(at: index)
                }
            }//end for
        }//end if not && want
        if(!poi.wanttovisit){
            for (index, p) in wanttovisitList.enumerated(){
                if(poi.ID == p.ID){
                    wanttovisitList.remove(at: index)
                }
            }//end for
        }//end if want
        sortPOI(poi3: poi)
        recommendationCategories.sort(by: { $0.count > $1.count })
        
    }//end markAsWantToVisit
    
//==============================================================================================//
    
    //this method mark a POI as not interested
    func markAsNotInterested(poi: POI){
        poi.notinterested.toggle()
        notCategorize(poi: poi, mark: poi.notinterested)
        if(poi.wanttovisit == true && poi.notinterested == true){
            poi.wanttovisit = false
            categorize(poi: poi, mark: poi.wanttovisit)
            for (index, p) in wanttovisitList.enumerated(){
                if(poi.ID == p.ID){
                    wanttovisitList.remove(at: index)
                }
            }//end for
        }//end if want && not
        if(!poi.notinterested){
            for (index, p) in notInterestedList.enumerated(){
                if(poi.ID == p.ID){
                    notInterestedList.remove(at: index)
                }
            }//end for
        }//end if not
        sortPOI(poi3: poi)
        recommendationCategories.sort(by: { $0.count > $1.count })
        
    }//end markAsNotInterested
    
    
//==============================================================================================//
    
    //this method sort single POI in the three lists
    func sortPOI(poi3: POI){
        
        if(poi3.visited == true && !isExist(theList: visitedList, poi: poi3)){
            visitedList.append(poi3)
        }
        if(poi3.wanttovisit == true && !isExist(theList: wanttovisitList, poi: poi3)){
            wanttovisitList.append(poi3)
        }
        if(poi3.notinterested == true && !isExist(theList: notInterestedList, poi: poi3)){
            notInterestedList.append(poi3)
        }
    }
        
//==============================================================================================//

    //this method sort POI array in the three lists
    //sort markedList
    func sort(poiList: [POI]){
        
        for poi in poiList {
            if(poi.visited == true && !isExist(theList: visitedList, poi: poi)){
                visitedList.append(poi)
            }
            if(poi.wanttovisit == true && !isExist(theList: wanttovisitList, poi: poi)){
                wanttovisitList.append(poi)
            }
            if(poi.notinterested == true && !isExist(theList: notInterestedList, poi: poi)){
                notInterestedList.append(poi)
            }
        }//end for
        
    }//end sort
    
//==============================================================================================//

    //this method check if the POI is inside a list
    func isExist(theList: [POI], poi: POI) -> Bool{
        for p in theList {
            if(p.ID == poi.ID){
                return true
            }
        }//end for
        return false
    }//end isExist
    
//==============================================================================================//

    //this method add points to visited and want to visit
    func categorize(poi: POI, mark: Bool){
        var theCategory = poi.categorey
        for p in recommendationCategories{
            if(p.name == theCategory){
                if(mark == true){
                    p.count += 1
                    return
                }
                else{
                    p.count -= 1
                    return
                }
            }//end if
        }//end for
        
        var categoryobj: category = category(name: theCategory, count: 0)
        recommendationCategories.append(categoryobj)
        if(mark == true){
            categoryobj.count += 1
        }
        else{
            categoryobj.count -= 1
        }
        
    }//end categorize
    
//==============================================================================================//
    
    //this method add points to not interested
    func notCategorize(poi: POI, mark: Bool){
        var theCategory = poi.categorey
        for p in recommendationCategories{
            if(p.name == theCategory){
                if(mark == true){
                    p.count -= 1
                    return
                }
                else{
                    p.count += 1
                    return
                }
            }//end if
        }//end for
        
        var categoryobj: category = category(name: theCategory, count: 0)
        recommendationCategories.append(categoryobj)
        if(mark == true){
            categoryobj.count -= 1
        }
        else{
            categoryobj.count += 1
        }
        
    }//end notCategorize
    
//==============================================================================================//
    
    //this method print all lists
    func printdisplay(){
        for p in notiList{
            print("notif: " + p.name)
        }
        for p in visitedList{
            print("visited: " + p.name)
        }
        for p in wanttovisitList{
            print("want: " + p.name)
        }
        for p in notInterestedList{
            print("not: " + p.name)
        }
        if(recommendationCategories.isEmpty){
            print("dead")
        }
        for p in recommendationCategories{
            print("cat: " + p.name + " count :" + String(p.count))
        }
        
    }//end print display
    
//==============================================================================================//

    func sortCategories(){
        recommendationCategories.sort(by: { $0.count > $1.count })
    }//end sort categories
    
//==============================================================================================//

    //this method sould recommend to user
    func recommend(){
        if(recommendationCategories.isEmpty){
            //static list when user has no marks
            return
        }
        var size = recommendationCategories.count
        var TheCategory: category = recommendationCategories[0]
        if(size > 0 && size < 4){
            if(TheCategory.count>1){
                for i in 0...3{ //recommend 1st item 4 times
                    //match with databse and check if it not marked then recommend
                }
            }else{
                for j in 0...3{
                    //static recmmendation list to show in case user has zero or negative marks
                }
            }
            
            return
        }
        
        if(size > 3 && size < 6){
            for c in 0...1{
                var TheCategory: category = recommendationCategories[c]
                if(TheCategory.count>1){
                    for i in 0...2-c{ //recommend 1st category 3 times and 2nd category 2 times
                        //
                    }
                }else{
                    for j in 0...2-c{
                        //reccomend the remaining items
                    }
                }
            }
            return
        }
        
        if(size >= 6){
            for c in 0...2{
                var TheCategory: category = recommendationCategories[c]
                if(TheCategory.count>1){
                    for i in 0...2-c{ //reccomne 1st category 3 times, 2nd category 2 timws and 3rd category 1 time
                        //
                        
                    }
                }else{
                    for j in 0...2-c{
                        //recommend missing
                    }
                }
            }
            return
        }
    }//end recommend method
    
//==============================================================================================//

}//end user
