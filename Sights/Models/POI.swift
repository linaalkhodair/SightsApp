//
//  POI.swift
//  Sights
//
//  Created by Shahad Nasser on 04/03/2020.
//  Copyright © 2020 HARSHIT. All rights reserved.
//

import Foundation

class POI {
    
//    var label : String
//    var desc : String
    
    var ID: String
    var name: String
    var rate: Double
    var long: Double
    var lat: Double
    var visited: Bool
    var notinterested: Bool
    var wanttovisit: Bool
    var description: String
    var openingHours: String
    var locationName: String
    var imgUrl: String
    var categorey: String
    //add hasChallenge
    
    
    internal init(ID: String, name: String, rate: Double, long: Double, lat: Double, visited: Bool, notinterested: Bool, wanttovisit: Bool, description: String, openingHours: String, locationName: String, imgUrl: String, category: String) {
        self.ID = ID
        self.name = name
        self.rate = rate
        self.long = long
        self.lat = lat
        self.visited = visited
        self.notinterested = notinterested
        self.wanttovisit = wanttovisit
        self.description = description
        self.openingHours = openingHours
        self.locationName = locationName
        self.imgUrl = imgUrl
        self.categorey = category
    }
}//end POI

class category{
    
    var name: String
    var count: Int
    
    internal init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}// end category


    


    
