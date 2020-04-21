//
//  ListViewController.swift
//  Sights
//
//  Created by HARSHIT on 23/02/20.
//  Copyright © 2020 HARSHIT. All rights reserved.
//
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
    

//
//    var POI1: POI = POI(ID: "1", name:  "1name", rate:  1.0, long:  111, lat: 111, visited: true, notinterested: false, wanttovisit: false , description:  "1desc", openingHours: "1open",locationName:  "1locname", imgUrl:  "1url", category: "cat1")
//    var POI2: POI = POI(ID: "2", name:  "2name", rate:  2.0, long:  222, lat: 222, visited: false, notinterested: false, wanttovisit: false , description:  "2desc", openingHours: "2open",locationName:  "2locname", imgUrl:  "2url", category: "cat2")
//    var POI3: POI = POI(ID: "3", name:  "3name", rate:  3.0, long:  333, lat: 333, visited: false, notinterested: false, wanttovisit: true , description:  "3desc", openingHours: "3open",locationName:  "3locname", imgUrl:  "3url", category: "cat3")
//    var POI4: POI = POI(ID: "4", name:  "4name", rate:  4.0, long:  444, lat: 444, visited: true, notinterested: true, wanttovisit: false , description:  "4desc", openingHours: "4open",locationName:  "4locname", imgUrl:  "4url", category: "cat4")
//    var POI5: POI = POI(ID: "5", name:  "5name", rate:  5.0, long:  555, lat: 555, visited: false, notinterested: false, wanttovisit: false , description:  "5desc", openingHours: "5open",locationName:  "5locname", imgUrl:  "5url", category: "cat2")
    
    
    //    var visitedList = [POI]()
    //    var wanttovisitList = [POI]()
    //    var notInterestedList = [POI]()
    
    //    var rewardlist = [POI]()
    //    var recommendationlist = [category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //notiList.append(POI1)
        //notiList.append(POI2)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recommend = Recommend(rewardList: [POI](), markedList: [POI](), recommendationCategories: [category](), visitedList: [POI](), wanttovisitList: [POI](), notInterestedList: [POI](), notiList: [POI](), recommendList: [POI]())
        poolList=[POI]()
        recommendationList=[POI]()
        
        var db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        //let userID = UserDefaults.standard.string(forKey: "uid")!
        print("this is user ID !$%^%$#$%^$#@%^$#@!#$#%^&&$#@#%$^&*%&$#@  "+userID)
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
                                print(">>>>>>>>>>>>>>> &&&& &&& && & this is in pool (marked loop) " + j.name)
                            }

                            self.RecommendationView?.reloadData()
                            if(!self.isExist(theList: self.recommend.markedList, poi: i)){
                                self.recommend.markedList.append(i)
                            }
                            self.recommendationList = self.recommend.getRecommendationList(list: self.poolList)
                            print("appended in list pool "+i.name)
                            
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
                            //i.wanttovisit = false
                            //i.visited = false
                            //i.notinterested = false
                            if(!self.isExist(theList: self.notiList, poi: i)){
                                self.notiList.append(i)
                            }
                            if(!self.isExist(theList: self.notiList, poi: i)){
                                self.poolList.append(i)
                            }
                            self.NotificationView?.reloadData()
                            self.recommend.markedList.append(i)
                            print("appended in list noti "+i.name)
                            
                        }//end if
                       
                    }//end for i
                    
               
                }//end for
                

            }//end else
            //self.recommendationList = self.recommend.getRecommendationList(list: self.poolList)
            for i in self.recommendationList {
                print("this is in List" + i.name)
            }
            self.NotificationView?.reloadData()
        }

        
        self.NotificationView?.reloadData()
        self.RecommendationView?.reloadData()
        
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
            //            let userID = Auth.auth().currentUser!.uid
            //            var db = Firestore.firestore()
            //            db.collection("users").document(userID).collection("markedList").document(poolList[indexPath.row].ID).addSnapshotListener { documentSnapshot, error in
            //                guard let document = documentSnapshot else {
            //                    print("Error fetching document: \(error!)")
            //                    return
            //                }
            //                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
            //                print("\(source) data: \(document.data() ?? [:])")
            // }
            
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
