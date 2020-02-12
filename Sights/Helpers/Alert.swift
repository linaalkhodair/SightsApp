//
//  Alert.swift
//  Sights
//
//  Created by Lina Alkhodair on 07/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
     static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
