//
//  GuestListViewController.swift
//  Sights
//
//  Created by Shahad Nasser on 27/04/2020.
//  Copyright © 2020 Lina Alkhodair. All rights reserved.
//

import UIKit

class GuestListViewController: UIViewController {
       
    @IBOutlet weak var NotificationView: UICollectionView!
    
    
        var poolList = [POI]()
        var notiList = [POI]()
        var recommendationList = [POI]()
        
        var recommend = Recommend(rewardList: [POI](), markedList: [POI](), recommendationCategories: [category](), visitedList: [POI](), wanttovisitList: [POI](), notInterestedList: [POI](), notiList: [POI](), recommendList: [POI]())
        
        var POI1: POI = POI(ID: "aaaa", name: "sssss", rate: 2, long: 222, lat: 222, description: "String", openingHours: "String", locationName: "String", imgUrl: "String", category: "String", fullimg: "String")
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
            UIApplication.shared.applicationIconBadgeNumber = 0 //remove notification badge..

            //notiList.append(POI1)
            //notiList.append(POI2)

            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            recommend = Recommend(rewardList: [POI](), markedList: [POI](), recommendationCategories: [category](), visitedList: [POI](), wanttovisitList: [POI](), notInterestedList: [POI](), notiList: [POI](), recommendList: [POI]())
            poolList=[POI]()
            recommendationList=[POI]()
            
            //notiList.append(POI1)
            
          
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
extension GuestListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch collectionView{
        case NotificationView:
            return notiList.count
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
