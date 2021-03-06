//
//  POI.swift
//  Sights
//
//  Created by Shahad Nasser on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.

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
    var fullimg: String
    
    
    internal init(ID: String, name: String, rate: Double, long: Double, lat: Double, visited: Bool, notinterested: Bool, wanttovisit: Bool, description: String, openingHours: String, locationName: String, imgUrl: String, category: String, fullimg: String) {
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
        self.fullimg = fullimg
    }
    
    internal init(ID: String, name: String, rate: Double, long: Double, lat: Double, description: String, openingHours: String, locationName: String, imgUrl: String, category: String, fullimg: String) {
        self.ID = ID
        self.name = name
        self.rate = rate
        self.long = long
        self.lat = lat
        self.visited = false
        self.notinterested = false
        self.wanttovisit = false
        self.description = description
        self.openingHours = openingHours
        self.locationName = locationName
        self.imgUrl = imgUrl
        self.categorey = category
        self.fullimg = fullimg

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


class reward{
    
    var title: String
    var code: String
    
    internal init(title: String, code: String) {
        self.title = title
        self.code = code
    }
}//end reward
    
    


    
