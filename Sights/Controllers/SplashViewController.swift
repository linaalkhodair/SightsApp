//
//  SplashViewController.swift
//  Sights
//
//  Created by Shahad Nasser on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.

import UIKit

class SplashViewController: UIViewController {

    var imgListArray :NSMutableArray = []
    @IBOutlet var imageView:UIImageView?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        for countValue in 1...4
        {
            imgListArray .add(UIImage(named:"splash\(countValue)")!)
        }
        self.imageView?.animationImages = (imgListArray as! [UIImage]);
        self.imageView?.animationDuration = 1.5
        self.imageView?.startAnimating()
        self.perform(#selector(loadTabBar), with: nil, afterDelay: 1.4)
    }
    
    @objc func loadTabBar()
    {
        self.App_Delegate.AddTabBar()
    }
}
