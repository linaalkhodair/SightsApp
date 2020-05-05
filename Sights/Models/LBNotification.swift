//
//  LBNotification.swift
//  Sights
//
//  Created by Lina Alkhodair on 02/03/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UserNotifications
import FoursquareAPIClient
import SwiftyJSON
import Firebase


class LBNotification: NSObject, UNUserNotificationCenterDelegate {
    
    var lat: Double
    var lng: Double
    let client = FoursquareAPIClient(clientId: Constants.FoursquareClient.clientId, clientSecret: Constants.FoursquareClient.clientSecret)
    var db: Firestore!
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        
    }
    
    
    func searchVenues() {
        let parameter: [String: String] = [
            "ll": "24.680544, 46.736963",
            "radius": "600",
            "limit": "10",
            "intent": "browse",
            "categoryId": "4bf58dd8d48988d1e4931735,4bf58dd8d48988d1f1931735,4deefb944765f83613cdba6e,4bf58dd8d48988d17f941735,52e81612bcbc57f1066b79eb,4bf58dd8d48988d181941735,4bf58dd8d48988d1f4931735,4bf58dd8d48988d189941735,4bf58dd8d48988d182941735,4bf58dd8d48988d17b941735,4bf58dd8d48988d163941735,4bf58dd8d48988d164941735,4bf58dd8d48988d165941735,56aa371be4b08b9a8d57356a,4bf58dd8d48988d12f941735"
        ];
        
        client.request(path: "venues/search", parameter: parameter) { result in
            switch result {
            case let .success(data):
                
                let jsonResponse = try! JSONSerialization.jsonObject(with: data, options: [])
                let json = JSON(jsonResponse)
                
                let name = json["response"]["venues"][0]["name"].string //first venue
                print("NAME FROM JSON: ", name)
                
                let id = json["response"]["venues"][0]["id"].string
                print("id of foursquare", id)
                
                self.start(json: json, key: 0)
                
            case let .failure(error):
                // Error handling
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .responseParseError(responseParseError):
                    print(responseParseError)   // e.g. JSON text did not start with array or object and option to allow fragments not set.
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                }
            }
        }
        
        
    } // end searchVenues
    
    // recursive func to iterate through all venues and find a venue with a high rating to notify user
    func start(json: JSON, key: Int) {
        var isSent2 = false
        let placeId = json["response"]["venues"][key]["id"].string
        let name = json["response"]["venues"][key]["name"].string
        print("name:",name)
        print("placeId:",placeId)
        
        if placeId != nil {
            self.getVenueDetails(id: placeId!) { (isSent) in
                isSent2 = isSent
                if isSent2 == false {
                    print("works",isSent)
                    self.start(json: json, key: key+1)
                }
            }
        }
    } // end start
    
    func getVenueDetails(id: String, completionHandler: @escaping (Bool)->Void)  {
        
        var isSent: Bool = false
        
        let parameter: [String: String] = [
            "VENUE_ID": "\(id)",
            
        ];
        
        client.request(path: "venues/\(id)", parameter: parameter) { result in
            
            switch result {
            case let .success(data):
                
                let jsonResponse = try! JSONSerialization.jsonObject(with: data, options: [])
                
                let json = JSON(jsonResponse)
                let name = json["response"]["venue"]["name"].string
                
                var loc = json["response"]["venue"]["location"]["address"].string
                if loc == nil {
                    loc = "Riyadh, Saudi Arabia."
                }
                var desc = json["response"]["venue"]["location"]["description"].string
                if desc == nil {
                    desc = "" //? idk
                }
                var days = json["response"]["venue"]["hours"]["timeframes"][0]["days"].stringValue //?
                var hours = json["response"]["venue"]["hours"]["timeframes"][0]["open"][0]["renderedTime"].stringValue //?
                if hours == "" {
                    hours = "8:00 AM - 10:00 PM"
                }
                if days == "" {
                    days = "Sun-Thurs"
                }
                let time = days + ", " + hours //???????
                //PHOTO -> BEST PHOTO
                
                let photo = json["response"]["venue"]["bestPhoto"]["prefix"].string
                print("Photo",photo)
                
                let category = json["response"]["venue"]["categories"][0]["name"].stringValue
                
                let lat = json["response"]["venue"]["location"]["lat"].double
                let lng = json["response"]["venue"]["location"]["lng"].double
                
                if let rating:Double = json["response"]["venue"]["rating"].double {
                    print("rating from: ", rating)
                    
                    if (rating > 2)  {
                        
                        
                        self.notiExists(id: id) { (exists) in
                            print("ex",exists)
                            
                            if !exists {
                                self.foursquareNotification(name: name!)
                                
                                let poi = POI(ID: id, name: name!, rate: rating, long: lng!, lat: lat!, visited: false, notinterested: false, wanttovisit: false, description: desc!, openingHours: time, locationName: loc!, imgUrl: photo!, category: category, fullimg: "")
                                
                                self.addNotificationList(poi: poi)
                                //then add POIObject to notification list
                                print("here inside lol")
                                isSent = true
                                print("isSent hereee", isSent)
                                completionHandler(isSent)
                            } //end if exists
                        }
                        
                    }
                    
                } //end if rating
                    
                else {
                    isSent = false
                    completionHandler(isSent)
                }
                
            case let .failure(error):
                // Error handling
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .responseParseError(responseParseError):
                    print(responseParseError)   // e.g. JSON text did not start with array or object and option to allow fragments not set.
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                }
            }
        }
        
    }//end getVenueDetails
    
    func addNotificationList(poi: POI) {
        
        db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let timestamp = NSDate.now
        
        db.collection("users/\(uid!)/notificationsList").document(poi.ID).setData([
            "ID" : poi.ID,
            "timestamp" : timestamp,
        ])
        
        db.collection("NotificationsPOIs").document(poi.ID).setData([
            "ID" : poi.ID,
            "briefInfo" : poi.description,
            "category" : poi.categorey,
            "latitude" : poi.lat,
            "longitude" : poi.long,
            "name" : poi.name,
            "rating" : poi.rate,
            "openingHours" : poi.openingHours,
            "location" : poi.locationName,
            "image" : poi.imgUrl
        ])
        
        
        if(!self.isExist(theList: globalPOIList, thepoi: poi)){
            globalPOIList.append(poi)
        }
        
    }
    
    func isExist(theList: [POI], thepoi: POI) -> Bool{
        for p in theList {
            if(p.ID == thepoi.ID){
                return true
            }
        }//end for
        return false
    }//end isExist
    
    func notiExists(id: String, completionHandler: @escaping (Bool)->Void) {
        db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        var exists: Bool = false
        
        db.collection("users/\(uid!)/notificationsList").document(id).getDocument { (docSnapshot, err) in
            if let err = err {
                print("Document doesn't exist, \(err)")
                
            } else {
                exists = docSnapshot!.exists
                completionHandler(exists)
                
            }
        }
        
    }
    
    func foursquareNotification(name: String) -> Bool {
        
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Hey there, Riyadh is waiting for you 🌏"
        //content.subtitle = "\(place.name.unsafelyUnwrapped) is near you!"
        content.body = "You've just passed \(name), come check it out and explore Riyadh."
        content.badge = 1
        content.sound = .default
        
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "LBNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        return true
        
    }
    
    //---------------------------------------------SETTINGS------------------------------------------------------------------
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    //update notification badge when entered
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //UI updates are done in the main thread
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber -= 1
        }
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: {requests in
            //Update only the notifications that have userInfo["timeInterval"] set
            let newRequests: [UNNotificationRequest] =
                requests
                    .filter{ rq in
                        return rq.content.userInfo["timeInterval"] is Double?
                }
                .map { request in
                    let newContent: UNMutableNotificationContent = request.content.mutableCopy() as! UNMutableNotificationContent
                    newContent.badge = (Int(truncating: request.content.badge ?? 0) - 1) as NSNumber
                    let newRequest: UNNotificationRequest =
                        UNNotificationRequest(identifier: request.identifier,
                                              content: newContent,
                                              trigger: request.trigger)
                    return newRequest
            }
            newRequests.forEach { center.add($0, withCompletionHandler: { (error) in
                // Handle error
            })
            }
        })
        completionHandler()
    }
    
    
}
