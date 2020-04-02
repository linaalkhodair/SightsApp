//
//  ProfileViewController.swift
//  Sights
//
//  Created by Lina Alkhodair on 17/02/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet var RewardsView:UICollectionView?
    @IBOutlet var VisitListView:UICollectionView?

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDegree: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HERE PROFILEEEE")
        
        let monthName = DateFormatter().monthSymbols[Date().month - 1]

        dateLabel.text = "\(Date().day) \(monthName)"
        
        weatherManager.delegate = self
        weatherManager.fetchWeather(cityName: "Riyadh")

    }
    
    // MARK: UICollectionViewDelegate

    
    @IBAction func logoutTapped(_ sender: Any) {
        
            let firebaseAuth = Auth.auth()
            UserDefaults.standard.removeObject(forKey: "uid")
            do {
                try firebaseAuth.signOut()
                print("signed out")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            //Direct to sign up and login page...
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(identifier: "MainVC") as! ViewController
            
            self.view.window?.rootViewController = mainVC
            self.view.window?.makeKeyAndVisible()
        
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

extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch collectionView
        {
        case VisitListView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VisitListCell", for: indexPath) as? NotificationCell
            cell?.backgroundImage?.image = UIImage.init(named: "color_\((indexPath.row%6)+1)")
            return cell!
        case RewardsView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardsCell", for: indexPath) as? RecommendationCell
            cell?.backgroundImage?.image = UIImage.init(named: "color_\((indexPath.row%6)+1)")
            return cell!
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        switch collectionView
        {
        case VisitListView:
            return CGSize.init(width: UIScreen.main.bounds.size.width-40, height: 90)
        case RewardsView:
            return CGSize.init(width: 150, height: 110)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let pinPopup = PopUpDetailViewController()
        presentPopup(pinPopup,
                     animated: true,
                     backgroundStyle: .blur(.light), // present the popup with a blur effect has background
            constraints: [.leading(20), .trailing(20)], // fix leading edge and the width
            transitioning: .zoom, // the popup come and goes from the left side of the screen
            autoDismiss: true, // when touching outside the popup bound it is not dismissed
            completion: nil)
    }
}

extension ProfileViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherDegree.text = weather.temperatureString
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension Date{
    var day:Int {return Calendar.current.component(.day, from:self)}
    var month:Int {return Calendar.current.component(.month, from:self)}
    var year:Int {return Calendar.current.component(.year, from:self)}
}

