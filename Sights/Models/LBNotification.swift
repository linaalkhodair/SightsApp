//
//  LBNotification.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/03/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import Foundation
import UserNotifications

class LBNotification {
    
    var ID: String
    var title: String
    var place: String
    var body: String
    
    init(ID: String, title: String, body: String, place: String) {
        self.ID = ID
        self.title = title
        self.body = body
        self.place = place
    }
    
    func sendNotification(name: String){
        
    }
    
    func addToNotificationList(uid: String) {
        
    }
    
}
