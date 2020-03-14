//
//  GifViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 06/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit


class GifViewController: UIViewController {
    
    @IBOutlet weak var gifView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifView.loadGif(name: "sightsGif")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { //timer
            print("finish")
            let next = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainViewController) as! ViewController
             self.view.window?.rootViewController = next
             self.view.window?.makeKeyAndVisible()

               }

    }
 
    //  LOCK ORIENTATION TO PORTRAIT
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}
