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
    
    func startActivityUpdates() -> String
    {
        var activityType: String = ""
        motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (activity) in
               if (activity?.automotive)! {
                   print("User using car")
                    activityType = "driving"
               }

               if (activity?.walking)! {
                   print("User is walking")
                    activityType = "walking"
               }

           }
        return activityType
    }
    
}
