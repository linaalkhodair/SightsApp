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

class ListViewController: UIViewController
{
    @IBOutlet var RecommendationView:UICollectionView?
    @IBOutlet var NotificationView:UICollectionView?
    
    var db: Firestore!

    
    var POI1: POI = POI(ID: "1", name:  "1name", rate:  1.0, long:  111, lat: 111, visited: true, notinterested: false, wanttovisit: false , description:  "1desc", openingHours: "1open",locationName:  "1locname", imgUrl:  "1url", category: "cat1")
    var POI2: POI = POI(ID: "2", name:  "2name", rate:  2.0, long:  222, lat: 222, visited: false, notinterested: false, wanttovisit: false , description:  "2desc", openingHours: "2open",locationName:  "2locname", imgUrl:  "2url", category: "cat2")
    var POI3: POI = POI(ID: "3", name:  "3name", rate:  3.0, long:  333, lat: 333, visited: false, notinterested: false, wanttovisit: true , description:  "3desc", openingHours: "3open",locationName:  "3locname", imgUrl:  "3url", category: "cat3")
     var POI4: POI = POI(ID: "4", name:  "4name", rate:  4.0, long:  444, lat: 444, visited: true, notinterested: true, wanttovisit: false , description:  "4desc", openingHours: "4open",locationName:  "4locname", imgUrl:  "4url", category: "cat4")
    var POI5: POI = POI(ID: "5", name:  "5name", rate:  5.0, long:  555, lat: 555, visited: false, notinterested: false, wanttovisit: false , description:  "5desc", openingHours: "5open",locationName:  "5locname", imgUrl:  "5url", category: "cat2")
    
    var poolList = [POI]()
    var visitedList = [POI]()
    var wanttovisitList = [POI]()
    var notInterestedList = [POI]()
    var notiList = [POI]()
    var rewardlist = [POI]()
    var recommendationlist = [category]()
    
//    var NotificationArray = [data(label: "This is Label1", desc: "this is a description1 very very very veryvery veryvery veryvery veryvery very looooong long long long  very very very veryvery veryvery veryvery veryvery very looooong long long long  very very very veryvery veryvery veryvery veryvery very looooong long long long  very very very veryvery veryvery veryvery veryvery very looooong long long long  very very very veryvery veryvery veryvery veryvery very looooong long long long  very very very veryvery veryvery veryvery veryvery very looooong long long long"), data(label: "This is Label2", desc: "this is a description2"), data(label: "This is Label3", desc: "this is a description3"), data(label: "This is Label4", desc: "this is a description4"), data(label: "This is Label5", desc: "this is a description5"), data(label: "This is Label6", desc: "this is a description6"), data(label: "This is Label7", desc: "this is a description7"), data(label: "This is Label8", desc: "this is a description8"), data(label: "This is Label9", desc: "this is a description9"), data(label: "This is Label10", desc: "this is a description10"), data(label: "This is Label11", desc: "this is a description11"), data(label: "This is Label12", desc: "this is a description12"), data(label: "This is Label13", desc: "this is a description13"), data(label: "This is Label14", desc: "this is a description14")]
   
//    var RecommendationArray = [data(label: "This is Label1", desc: "this is a description1"), data(label: "This is Label2", desc: "this is a description2"), data(label: "This is Label3", desc: "this is a description3"), data(label: "This is Label4", desc: "this is a description4")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //poolList.append(POI1)
        //poolList.append(POI2)
        //poolList.append(POI3)
        //poolList.append(POI4)
        print("entered lisst")
        notiList.append(POI5)
        notiList.append(POI4)
        recommendationlist.append(category(name: "cat1", count: 1))
        recommendationlist.append(category(name: "cat2", count: 0))
        recommendationlist.append(category(name: "cat3", count: 1))
        recommendationlist.append(category(name: "cat4", count: 0))
        
        db = Firestore.firestore()
        //let userID = Auth.auth().currentUser!.uid
        let userID = "5x141iiWqQT5Wk5GEjMTO6CXrDw2"
        print("@#@#@#@#@#@#@#@#@#@#@#@# I'm before db first call")
        db.collection("users").document(userID).collection("markedList").getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("@#@#@#@#@#@#@#@#@#@#@#@# I'm in error1")
                    print("Error getting documents: \(err)")
                } else {
                    print("@#@#@#@#@#@#@#@#@#@#@#@# yay no error1")

                    for userdocument in querySnapshot!.documents {
                        self.db.collection("POIs").document(userdocument.documentID+"").getDocument(){ (document, error) in
                            if let document = document, document.exists {
                                print("@#@#@#@#@#@#@#@#@#@#@#@# yay no error2")
                                print("@#@#@#@#@#@#@#@#@#@#@#@# " + document.documentID + "  " + userdocument.documentID)

                                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                                //print("Document data: \(dataDescription)")
                                let poi = POI(ID: document.documentID, name: document.get("name") as! String, rate: document.get("rating") as! Double, long: document.get("longitude") as! Double, lat:document.get("latitude") as! Double, visited: userdocument.get("visited") as! Bool, notinterested: userdocument.get("notInterested") as! Bool, wanttovisit: userdocument.get("wantToVisit") as! Bool, description: document.get("briefInfo") as! String, openingHours: document.get("openingHours") as! String, locationName: document.get("location") as! String, imgUrl: document.get("image") as! String, category: document.get("category") as! String)
                                
                                print("@#@#@#@#@#@#@#@#@#@#@#@# " + poi.ID + "  " + poi.name)

                             self.getUser().markedList.append(poi)
                                self.poolList.append(poi)
                                self.RecommendationView?.reloadData()
                             for p in self.getUser().markedList{
                                    print("&&&&&&&&&&&&&&&&&&&&& && && && : " + p.name)
                                }
                            } else {
                                print("@#@#@#@#@#@#@#@#@#@#@#@# error2")

                                print("Document does not exist")
                            }
                        }

                    }//end for
            }//end else
        }//
        
        //let markedList :AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        //let u = markedList?.getUser()
        //poolList = getUser().markedList
        //poolList.append(contentsOf: getUser().markedList )
//        var u = user(ID: "5x141iiWqQT5Wk5GEjMTO6CXrDw2", name: "helpme", email: "email", rewardList: rewardlist, markedList: poolList, recommendationcategories: recommendationlist, visitedList: visitedList, wanttovisitList: wanttovisitList, notInterestedList: notInterestedList, notiList: notiList)
//        //poolList.append(contentsOf: u.markedList)
//        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$I'm empty")
//        for p in u.markedList{
//                  print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$mark: " + p.name)
//              }
        
        for p in poolList{
            print("pool: " + p.name)
        }
        
        for p in getUser().markedList{
            print("app: " + p.name)
        }

    }

}


// MARK: UICollectionViewDelegate

extension ListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch collectionView{
        case NotificationView:
            return notiList.count
        case RecommendationView:
            return poolList.count
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
            cell?.lable?.text = poolList[indexPath.row].name
            cell?.desc?.text = poolList[indexPath.row].locationName
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
            pinPopup.setContent(name: notiList[indexPath.row].name, loc: notiList[indexPath.row].locationName, stars: notiList[indexPath.row].rate , hours: notiList[indexPath.row].openingHours, desc: notiList[indexPath.row].description, img: "https://static01.nyt.com/images/2019/12/03/world/03xp-lilbub/merlin_165345945_7a6f87a8-cdf3-4d00-b389-282ad7630953-articleLarge.jpg?quality=75&auto=webp&disable=upscale", want: notiList[indexPath.row].wanttovisit, visit:  notiList[indexPath.row].visited, not: notiList[indexPath.row].notinterested)
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
            pinPopup.setContent(name: poolList[indexPath.row].name, loc: poolList[indexPath.row].locationName, stars: poolList[indexPath.row].rate, hours: poolList[indexPath.row].openingHours, desc: poolList[indexPath.row].description, img: poolList[indexPath.row].imgUrl, want: poolList[indexPath.row].wanttovisit, visit:  poolList[indexPath.row].visited, not: poolList[indexPath.row].notinterested)
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
//        let pinPopup = PopUpDetailViewController()
//        pinPopup.setContent(name: "hello",loc: "String", stars: 2.3, hours: "String", desc: "String")
//        presentPopup(pinPopup,
//        animated: true,
//        backgroundStyle: .blur(.light), // present the popup with a blur effect has background
//        constraints: [.leading(20), .trailing(20)], // fix leading edge and the width
//        transitioning: .zoom, // the popup come and goes from the left side of the screen
//        autoDismiss: true, // when touching outside the popup bound it is not dismissed
//        completion: nil)
    }
    func getUser()->user{
        var u = user(ID: "5x141iiWqQT5Wk5GEjMTO6CXrDw2", name: "helpme", email: "email", rewardList: [POI](), markedList: [POI](), recommendationcategories: [category]())
        return u
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

//struct data {
//    var label : String
//    var desc : String
//
//}
