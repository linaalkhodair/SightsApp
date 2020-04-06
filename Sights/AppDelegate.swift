
import UIKit
import ESTabBarController_swift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    var db: Firestore!
    let storyboard = UIStoryboard(name: "SecondMain", bundle: nil)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //self.loadUserData()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))

        application.beginBackgroundTask(withName: "showNotification", expirationHandler: nil)
        
        UIApplication.backgroundFetchIntervalMinimum
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        let firebaseAuth = Auth.auth()
        UserDefaults.standard.removeObject(forKey: "uid")
        do {
            try firebaseAuth.signOut()
            print("signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func loadUserData(){
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
       }//end func
    
    func getUser()->user{
        var u = user(ID: "5x141iiWqQT5Wk5GEjMTO6CXrDw2", name: "helpme", email: "email", rewardList: [POI](), markedList: [POI](), recommendationcategories: [category]())
        return u
    }
    
    func AddTabBar()
    {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = self
      //  tabBarController.tabBar.backgroundImage = UIImage(named: "Transparent")
        
        tabBarController.shouldHijackHandler = { tabbarController, viewController, index in
            if index == 3 {
                return true
            }
            return false
        }
        
        let v1 = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        let v2 = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let v3 = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        v1.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(),title: "", image: UIImage(named: "ic_list"), selectedImage: UIImage(named: "ic_list"))
        v2.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(),title: "", image: UIImage(named: "ic_round"), selectedImage: UIImage(named: "ic_round"))
        v3.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(),title: "", image: UIImage(named: "ic_user"), selectedImage: UIImage(named: "ic_user"))
        tabBarController.viewControllers = [v1, v2, v3]
        tabBarController.selectedViewController = v2 //launch with camera view


        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    
    func AddGuestTabBar()
    {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = self
        //tabBarController.tabBar.backgroundImage = UIImage(named: "Transparent")
        
        tabBarController.shouldHijackHandler = { tabbarController, viewController, index in
            if index == 3 {
                return true
            }
            return false
        }
        let storyboard2 = UIStoryboard(name: "Guest", bundle: nil)
        
        let v1 = storyboard2.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        let v2 = storyboard2.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let v3 = storyboard2.instantiateViewController(withIdentifier: "GuestViewController") as! GuestViewController
        
        v1.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(),title: "", image: UIImage(named: "ic_list"), selectedImage: UIImage(named: "ic_list"))
        v2.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(),title: "", image: UIImage(named: "ic_round"), selectedImage: UIImage(named: "ic_round"))
        v3.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(),title: "", image: UIImage(named: "ic_user"), selectedImage: UIImage(named: "ic_user"))
       tabBarController.viewControllers = [v1, v2, v3]
       tabBarController.selectedViewController = v2

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
}

extension AppDelegate:UITabBarControllerDelegate
{
    
}
