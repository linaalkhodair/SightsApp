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


class LBNotification: NSObject, UNUserNotificationCenterDelegate {
    
    var lat: Double
    var lng: Double
    let client = FoursquareAPIClient(clientId: Constants.FoursquareClient.clientId, clientSecret: Constants.FoursquareClient.clientSecret)
 

    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        
    }

    
    func searchVenues() {
        let parameter: [String: String] = [
            "ll": "\(lat), \(lng)",
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
                var hours = json["response"]["venue"]["hours"]["status"].string //?
                if hours == nil {
                    hours = "8:00 AM - 10:00 PM"
                }
                
                let lat = json["response"]["venue"]["location"]["lat"].double
                let lng = json["response"]["venue"]["location"]["lng"].double

                if let rating:Double = json["response"]["venue"]["rating"].double {
                    print("rating from: ", rating)
                    
                    if (rating > 2)  {
                        self.foursquareNotification(name: name!)
                        let timestamp = NSDate.now //we must add it to notification when we store it in the DB
                        print("timestamp")
                        //timestamp.compare(Date) --> this is then used when loading notification list check if it has lasted two days then delete it
                       
                        // here we need to create a POI object with all info needed then add POI to user's notification list
                        // also later on check to not send notification that exists in the notification list
//                        let poi = POI(ID: id, name: name!, location: loc!, latitude: lat!, longitude: lng!, rating: rating, briefInfo: desc!, openingHours: hours!, image: "", markState: false)
                        //then add POIObject to notification list
                        print("here inside lol")
                        isSent = true
                        print("isSent hereee", isSent)
                        completionHandler(isSent)
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
    
    
    func foursquareNotification(name: String) {
        
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
