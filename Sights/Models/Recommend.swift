//
//  Recommend.swift
//  Sights
//
//  Created by Shahad Nasser on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import Foundation
import Firebase

class Recommend {
    
    var markedList: [POI]
    var recommendationCategories: [category]
    var visitedList: [POI]
    var wanttovisitList: [POI]
    var notInterestedList: [POI]
    var notiList: [POI]
    var recommendList: [POI]
    
    internal init(rewardList: [POI], markedList: [POI], recommendationCategories: [category], visitedList: [POI], wanttovisitList: [POI], notInterestedList: [POI], notiList: [POI], recommendList: [POI]) {
        self.markedList = markedList
        self.recommendationCategories = recommendationCategories
        self.visitedList = visitedList
        self.wanttovisitList = wanttovisitList
        self.notInterestedList = notInterestedList
        self.notiList = notiList
        self.recommendList = recommendList
    }
    
    
    //==============================================================================================//
    
    func getRecommendationList(list: [POI])->[POI]{
        
        print("im indide get recommendation list")
        sort(poiList: list)
        recommendationCategories.sort(by: { $0.count > $1.count })
        recommend(matchedList: match())
        
        return recommendList
    }
    
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
                categorize(poi: poi, mark: poi.visited)
            }
            if(poi.wanttovisit == true && !isExist(theList: wanttovisitList, poi: poi)){
                wanttovisitList.append(poi)
                categorize(poi: poi, mark: poi.wanttovisit)
                
            }
            if(poi.notinterested == true && !isExist(theList: notInterestedList, poi: poi)){
                notInterestedList.append(poi)
                notCategorize(poi: poi, mark: poi.notinterested)
                
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
    func match()->[POI]{
        var matchedList = [POI]()
        
        print("----XXX XX XXX XX XXX XX XXX XX ----")
        for i in recommendationCategories{
            print(i.name+"    "+String(i.count))
        }
        print("----XXX XX XXX XX XXX XX XXX XX ----")

        if(recommendationCategories.isEmpty){
            print("----XXX XX XXX XX XXX XX XXX XX ---- YES I'm empty match()")
            return matchedList
        }//end empty
        
        if(recommendationCategories.count>0 && recommendationCategories.count<4){//1-3
            
            if(recommendationCategories[0].count>0){
                
                for i in globalPOIList{
                    if(recommendationCategories[0].name == i.categorey && i.notinterested == false){
                        if(!isExist(theList: matchedList, poi: i)){
                            matchedList.append(i)
                        }//end exist
                    }//end same category
                }//end for
                
            }//end if category0
            
            return matchedList
        }//end if 1-3
        
        if(recommendationCategories.count>3){//>4
            
            if(recommendationCategories[0].count>0){
                 
                 for i in globalPOIList{
                     if(recommendationCategories[0].name == i.categorey && i.notinterested == false){
                         if(!isExist(theList: matchedList, poi: i)){
                             matchedList.append(i)
                         }//end exist
                     }//end same category
                 }//end for
                 
             }//end if category0
            
            if(recommendationCategories[1].count>0){
                 
                 for i in globalPOIList{
                     if(recommendationCategories[1].name == i.categorey && i.notinterested == false){
                         if(!isExist(theList: matchedList, poi: i)){
                             matchedList.append(i)
                         }//end exist
                     }//end same category
                 }//end for
                 
             }//end if category0
            
            return matchedList
        }//end if >4
        
        return matchedList
    }//end match
    
    func recommend(matchedList: [POI]){
        print("im inside recommend ")
        
        recommendList = [POI]()
        
        if(matchedList.isEmpty){
            print("----XXX XX XXX XX XXX XX XXX XX ---- YES I'm empty recommend()")
            for i in 0...3{
                var randomPOI = globalPOIList.randomElement()!
                while(isExist(theList: recommendList, poi: randomPOI) || randomPOI.notinterested == true){
                    randomPOI = globalPOIList.randomElement()!
                }
                recommendList.append(randomPOI)
            }//end for
            return
        }//end empty
        
        if(recommendationCategories.count>0 && recommendationCategories.count<4){//1-3

            if(matchedList.count>3){
                for i in 0...2{
                    var randomPOI = matchedList.randomElement()!
                    while(isExist(theList: recommendList, poi: randomPOI)){
                        randomPOI = matchedList.randomElement()!
                    }
                    recommendList.append(randomPOI)
                }//end for
            }//end if count>3
            else{
                for i in matchedList{
                    recommendList.append(i)
                }//end for
            }//end else
            
            return
        }//end 1-3
        
        if(recommendationCategories.count>3){//>4
            
            if(matchedList.count>5){
                for i in 0...2{
                    recommendList.append(matchedList[i])
                }//end for
                for i in matchedList.count-2...matchedList.count-1{
                    recommendList.append(matchedList[i])
                }//end for
            }//end if count>3
            else{
                for i in matchedList{
                    recommendList.append(i)
                }//end for
            }//end else
            
            return
        }//end >4
        
    }//end recommend
    
    
    //this method sould recommend to user
    func recommendOld(){
        print("im inside recommend ")
        var localCategories = [POI]()
        
        if(recommendationCategories.isEmpty){
            print("yes im, empty")
            //static list when user has no marks
            return
        }
        var size = recommendationCategories.count
        var TheCategory: category = recommendationCategories[0]
        if(size > 0 && size < 4){
            print("im 0 and 4")
            if(TheCategory.count>=1){
                
                var db = Firestore.firestore()
                print("inside dp hhhhhhhhhhhhhhhhhhhhhhh")
                db.collection("POIs").whereField("category", isEqualTo: TheCategory.name).getDocuments(){ (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print("inside dp hhhhhhhhhhhhhhhhhhhhhhh")
                         for document in querySnapshot!.documents {
                        let poi = POI(ID: document.documentID, name: document.get("name") as! String, rate: document.get("rating") as! Double, long: document.get("longitude") as! Double, lat:document.get("latitude") as! Double, description: document.get("briefInfo") as! String, openingHours: document.get("openingHours") as! String, locationName: document.get("location") as! String, imgUrl: document.get("image") as! String, category: document.get("category") as! String)
                        
                        localCategories.append(poi)
                            print("inside dp hhhhhhhhhhhhhhhhhhhhhhh"+poi.categorey)
                            print("inside db  hhhhhhhhhhhhhhhhhhhhhhh"+String(localCategories.count))
                        }
                        
                    }//end else
                }//end getDoc
                var numOfRec = 0
                print("hhhhhhhhhhhhhhhhhhhhhhh"+String(localCategories.count))
                if(localCategories.count < 5){
                    numOfRec = localCategories.count
                } else if (localCategories.count > 5){
                    numOfRec = 4
                }
                for i in 0...numOfRec{ //recommend 1st item 4 times
                    //match with databse and check if it not marked then recommend
                    print("hhhhhhhhhhhhhhhhhhhhhhh"+localCategories[i].name)
                    recommendList.append(localCategories[i])
                    
                }//end for
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
    
}//end recommend
