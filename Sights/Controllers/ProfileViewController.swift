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
    @IBOutlet weak var nameLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    var rewardList = [reward]()
    var wantToVisit = [POI]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wantToVisit=[POI]()
        rewardList = [reward]()
        
        //var reward1 : reward = reward(title: "title1",code: "code1")
        //var reward2 : reward = reward(title: "title1",code: "code1")
        
        //rewardList.append(reward1)
        //rewardList.append(reward2)
        
        print("Inside ProfileView Controller")
        
        
        let monthName = DateFormatter().monthSymbols[Date().month - 1]
        
        dateLabel.text = "\(Date().day) \(monthName)"
        
        weatherManager.delegate = self
        weatherManager.fetchWeather(cityName: "Riyadh")
        
        setName()
        
    }
    
    func setName() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).getDocument { (docSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let name = docSnapshot?.get("name") as? String
                self.nameLabel.text = "Hello \(name.unsafelyUnwrapped)!"
            }
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
    
    // MARK: UICollectionViewDelegate
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        wantToVisit=[POI]()
        var db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        print("ProfileView Controller: USER ID "+userID)
        db.collection("users").document(userID).collection("markedList").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for userdocument in querySnapshot!.documents {
                    
                    for i in globalPOIList{
                        if(i.ID == userdocument.documentID && i.wanttovisit == true){
                            i.wanttovisit = userdocument.get("wantToVisit") as! Bool
                            i.visited = userdocument.get("visited") as! Bool
                            i.notinterested = userdocument.get("notInterested") as! Bool
                            
                            self.wantToVisit.append(i)
                            self.VisitListView?.reloadData()
                            print("ProfileView Controller: appended in wantToVisit List "+i.name)
                            
                        }
                        
                    }
                    
                    
                }//end for
                
            }//end else
            self.VisitListView?.reloadData()
        }
        
        
        rewardList = [reward]()
        db.collection("users").document(userID).collection("rewards").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for userdocument in querySnapshot!.documents {
                    
                    self.rewardList.append(reward(title: userdocument.get("reward") as! String, code: userdocument.get("reward") as! String))
                    self.RewardsView?.reloadData()
            
                    
                }//end for
                
            }//end else
            self.RewardsView?.reloadData()
        }
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        let alert = UIAlertController(title:"Are you sure you want to log out of Sights?",message:"", preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
            
        alert.addAction(UIAlertAction(title: "Log out", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction!) in
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
                      }))
        
       
        
    }
    
    
    
}

extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch collectionView{
        case RewardsView:
            return rewardList.count
        case VisitListView:
            return wantToVisit.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch collectionView
        {
        case VisitListView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VisitListCell", for: indexPath) as? NotificationCell
            cell?.backgroundImage?.image = UIImage.init(named: "color_\((indexPath.row%6)+1)")
            cell?.lable?.text = wantToVisit[indexPath.row].name
            cell?.desc?.text = wantToVisit[indexPath.row].locationName
            return cell!
        case RewardsView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardsCell", for: indexPath) as? RecommendationCell
            cell?.backgroundImage?.image = UIImage.init(named: "color_\((indexPath.row%6)+1)")
            cell?.lable?.text = rewardList[indexPath.row].code
            cell?.desc?.text = rewardList[indexPath.row].title
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
        
        switch collectionView {
        case RewardsView:
            let pinPopup = RewardDetailsViewController()
            pinPopup.setContent(Code: rewardList[indexPath.row].code, Place: rewardList[indexPath.row].title)
            presentPopup(pinPopup,
                         animated: true,
                         backgroundStyle: .blur(.light), // present the popup with a blur effect has background
                constraints: [.width(Screen.WIDTHFORPER(per: 90.0))], // fix leading edge and the width
                transitioning: .zoom, // the popup come and goes from the left side of the screen
                autoDismiss: false, // when touching outside the popup bound it is not dismissed
                completion: nil)
            
            
            return
        case VisitListView:
            let pinPopup = PopUpDetailViewController()
            pinPopup.setContent(id: wantToVisit[indexPath.row].ID,name: wantToVisit[indexPath.row].name, loc: wantToVisit[indexPath.row].locationName, stars: wantToVisit[indexPath.row].rate, hours: wantToVisit[indexPath.row].openingHours, desc: wantToVisit[indexPath.row].description, img: wantToVisit[indexPath.row].fullimg, want: wantToVisit[indexPath.row].wanttovisit, visit:  wantToVisit[indexPath.row].visited, not: wantToVisit[indexPath.row].notinterested)
            
            globalPOI = wantToVisit[indexPath.row]
            
            presentPopup(pinPopup,
                         animated: true,
                         backgroundStyle: .blur(.light), // present the popup with a blur effect has background
                constraints: [.width(Screen.WIDTHFORPER(per: 90.0))], // fix leading edge and the width
                transitioning: .zoom, // the popup come and goes from the left side of the screen
                autoDismiss: false, // when touching outside the popup bound it is not dismissed
                completion: nil)
            return
        default:
            return
        }
    }
}

extension ProfileViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherDegree.text = weather.temperatureString + "°"
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
