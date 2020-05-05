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
        
        print("Inside getRecommendationList")
        sort(poiList: list)
        recommendationCategories.sort(by: { $0.count > $1.count })
        
        print("Inside getRecommendationList now will return the list")
        return recommend(matchedList: match())
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
        print("============ Printing Lists ===========")
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
            print("recommendation categories is empty")
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
        
        //printing recommendation categories
        print("----XXX XX XXX XX XXX XX XXX XX ----")
        for i in recommendationCategories{
            print("inside match: "+i.name+"    "+String(i.count))
        }
        print("----XXX XX XXX XX XXX XX XXX XX ----")

        if(recommendationCategories.isEmpty){
            print("inside match: "+"recommendationCategories is empty ")
            return matchedList
        }//end empty
        
        if(recommendationCategories.count>0 && recommendationCategories.count<4){//1-3
            
            if(recommendationCategories[0].count>0){
                
                for i in globalPOIList{
                    if(recommendationCategories[0].name == i.categorey && i.notinterested == false && i.visited == false){
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
                    if(recommendationCategories[0].name == i.categorey && i.notinterested == false && i.visited == false){
                         if(!isExist(theList: matchedList, poi: i)){
                             matchedList.append(i)
                         }//end exist
                     }//end same category
                 }//end for
                 
             }//end if category0
            
            if(recommendationCategories[1].count>0){
                 
                 for i in globalPOIList{
                     if(recommendationCategories[1].name == i.categorey && i.notinterested == false && i.visited == false){
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
    
    func recommend(matchedList: [POI]) -> [POI]{
        print("insdie recommed")
        
        recommendList = [POI]()
        
        if(matchedList.isEmpty){
            print("inside recommend: "+"matchedList is empty ")
            for i in 0...3{
                var randomPOI = globalPOIList.randomElement()!
                while(isExist(theList: recommendList, poi: randomPOI) || randomPOI.notinterested == true || randomPOI.visited == true){
                    randomPOI = globalPOIList.randomElement()!
                }
                recommendList.append(randomPOI)
                print("insdie recommend: appended" + randomPOI.name)
            }//end for
            return recommendList
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
            
            return recommendList
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
            
            return recommendList
        }//end >4
        return recommendList

    }//end recommend
    
    
}//end recommend
