
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
        
        let v1 = storyboard2.instantiateViewController(withIdentifier: "GuestListViewController") as! GuestListViewController
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
