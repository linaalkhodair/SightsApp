//
//  CoreMotionManager.swift
//  Sights
//
//  Created by Lina Alkhodair on 14/03/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import CoreMotion

class CoreMotionManager {
    
    var motionActivityManager: CMMotionActivityManager
    
    init() {
        self.motionActivityManager = CMMotionActivityManager()
    }
    
    func startUpdates(completionHandler: @escaping (String)->Void)
    {
        var activityType: String = ""
        motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (activity) in
               if (activity?.automotive)! {
                   print("User using car")
                    completionHandler("driving")
                
               }

            if (activity!.walking || activity!.running) {
                   print("User is walking")
                    completionHandler("walking")
               }
            
            if (activity?.stationary)! {
                print("User is standing still")
                completionHandler("stationary")
            }

           }
        //return activityType
    }
    
}
