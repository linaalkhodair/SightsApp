//
//  ListViewController.swift
//  Sights
//
//  Created by Shahad Nasser on 02/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.

import UIKit
import PopItUp
import Firebase

var globalPOI = POI(ID: "1", name:  "1name", rate:  1.0, long:  111, lat: 111, visited: true, notinterested: false, wanttovisit: false , description:  "1desc", openingHours: "1open",locationName:  "1locname", imgUrl:  "1url", category: "cat1", fullimg: "")

class ListViewController: UIViewController
{
    @IBOutlet var RecommendationView:UICollectionView?
    @IBOutlet var NotificationView:UICollectionView?
    
    
    var poolList = [POI]()
    var notiList = [POI]()
    var recommendationList = [POI]()
    
    var recommend = Recommend(rewardList: [POI](), markedList: [POI](), recommendationCategories: [category](), visitedList: [POI](), wanttovisitList: [POI](), notInterestedList: [POI](), notiList: [POI](), recommendList: [POI]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recommend = Recommend(rewardList: [POI](), markedList: [POI](), recommendationCategories: [category](), visitedList: [POI](), wanttovisitList: [POI](), notInterestedList: [POI](), notiList: [POI](), recommendList: [POI]())
        poolList=[POI]()
        recommendationList=[POI]()
        
        var db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        print("ListView Controller: USER ID "+userID)
        db.collection("users").document(userID).collection("markedList").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for userdocument in querySnapshot!.documents {

                    for i in globalPOIList{
                        if(i.ID == userdocument.documentID){
                            i.wanttovisit = userdocument.get("wantToVisit") as! Bool
                            i.visited = userdocument.get("visited") as! Bool
                            i.notinterested = userdocument.get("notInterested") as! Bool
                            if(!self.isExist(theList: self.poolList, poi: i)){
                                self.poolList.append(i)
                            }
                            for j in self.poolList {
                                print("ListView Controller: in marked loop appended into poolList: " + j.name)
                            }

                            self.RecommendationView?.reloadData()
                            if(!self.isExist(theList: self.recommend.markedList, poi: i)){
                                self.recommend.markedList.append(i)
                            }
                            self.recommendationList = self.recommend.getRecommendationList(list: self.poolList)
                            print("ListView Controller: in marked loop appended into poolList: " + i.name)

                        }//end if
                       
                    }//end for i
               
                    
                }//end for

            }//end else
            self.recommendationList = self.recommend.getRecommendationList(list: self.poolList)
            self.RecommendationView?.reloadData()
            self.NotificationView?.reloadData()
        }
        
        notiList=[POI]()
       
        db.collection("users").document(userID).collection("notificationsList").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for userdocument in querySnapshot!.documents {

                    for i in globalPOIList{
                        if(i.ID == userdocument.documentID){
                            if(!self.isExist(theList: self.notiList, poi: i)){
                                self.notiList.append(i)
                            }
                            if(!self.isExist(theList: self.notiList, poi: i)){
                                self.poolList.append(i)
                            }
                            self.NotificationView?.reloadData()
                            self.recommend.markedList.append(i)
                            print("ListView Controller: in marked loop appended into notiList: " + i.name)

                        }//end if
                       
                    }//end for i
                    
               
                }//end for
                

            }//end else
            for i in self.recommendationList {
                print("Listview controller: in recommendationList:" + i.name)
            }
            self.NotificationView?.reloadData()
        }

        
        self.NotificationView?.reloadData()
        self.RecommendationView?.reloadData()
        
        print("printing globalPOIList")
        print("--------------------------------------")
        for i in globalPOIList{
            print("---------------" + i.name)
        }
        print("--------------------------------------")
    }//end viewWillAppear
    
    //this method check if the POI is inside a list
    func isExist(theList: [POI], poi: POI) -> Bool{
        for p in theList {
            if(p.ID == poi.ID){
                return true
            }
        }//end for
        return false
    }//end isExist
    
}//end class


// MARK: UICollectionViewDelegate
extension ListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch collectionView{
        case NotificationView:
            return notiList.count
        case RecommendationView:
            return recommendationList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch collectionView
        {
        case NotificationView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCell", for: indexPath) as? NotificationCell
            cell?.backgroundImage?.image = UIImage.init(named: "color_\((indexPath.row%6)+1)")
            cell?.lable?.text = notiList[indexPath.row].name
            cell?.desc?.text = notiList[indexPath.row].locationName
            return cell!
        case RecommendationView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as? RecommendationCell
            cell?.backgroundImage?.image = UIImage.init(named: "color_\((indexPath.row%6)+1)")
            cell?.lable?.text = recommendationList[indexPath.row].name
            cell?.desc?.text = recommendationList[indexPath.row].locationName
            return cell!
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        switch collectionView
        {
        case NotificationView:
            return CGSize.init(width: UIScreen.main.bounds.size.width-40, height: 90)
        case RecommendationView:
            return CGSize.init(width: 150, height: 110)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        switch collectionView {
        case NotificationView:
            let pinPopup = PopUpDetailViewController()
            pinPopup.setContent(id: notiList[indexPath.row].ID,name: notiList[indexPath.row].name, loc: notiList[indexPath.row].locationName, stars: notiList[indexPath.row].rate , hours: notiList[indexPath.row].openingHours, desc: notiList[indexPath.row].description, img: notiList[indexPath.row].fullimg, want: notiList[indexPath.row].wanttovisit, visit:  notiList[indexPath.row].visited, not: notiList[indexPath.row].notinterested)
            
            globalPOI = notiList[indexPath.row]
            
            presentPopup(pinPopup,
                         animated: true,
                         backgroundStyle: .blur(.light), // present the popup with a blur effect has background
                constraints: [.width(Screen.WIDTHFORPER(per: 90.0))], // fix leading edge and the width
                transitioning: .zoom, // the popup come and goes from the left side of the screen
                autoDismiss: false, // when touching outside the popup bound it is not dismissed
                completion: nil)
            return
        case RecommendationView:
            let pinPopup = PopUpDetailViewController()
            pinPopup.setContent(id: recommendationList[indexPath.row].ID,name: recommendationList[indexPath.row].name, loc: recommendationList[indexPath.row].locationName, stars: recommendationList[indexPath.row].rate, hours: recommendationList[indexPath.row].openingHours, desc: recommendationList[indexPath.row].description, img: recommendationList[indexPath.row].fullimg, want: recommendationList[indexPath.row].wanttovisit, visit:  recommendationList[indexPath.row].visited, not: recommendationList[indexPath.row].notinterested)
            
            globalPOI = recommendationList[indexPath.row]
            
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
