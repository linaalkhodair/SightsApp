//
//  POI.swift
//  Sights
//
//  Created by Lina Alkhodair on 14/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

class POI {
    
    var ID: String
    var name: String
    var location: String
    var latitude: Double
    var longitude: Double
    var rating: Double
    var briefInfo: String
    var openingHours: String
    var image: String
    var markState: Bool
    
    init(ID: String, name: String, location: String, latitude: Double, longitude: Double, rating: Double, briefInfo: String, openingHours: String, image: String, markState: Bool) {
       
        self.ID = ID
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.briefInfo = briefInfo
        self.openingHours = openingHours
        self.image = image
        self.markState = markState
    }
    
    
    
}
