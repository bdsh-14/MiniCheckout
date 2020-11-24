import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow()
        window?.rootViewController = createNavigationController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func createNavigationController() -> UINavigationController {
        let vc = BeginCheckoutViewController()
        return UINavigationController(rootViewController: vc)
    }

}

