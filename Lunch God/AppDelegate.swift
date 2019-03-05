//
//  AppDelegate.swift
//  Flash Chat
//
//  The App Delegate listens for events from the system. 
//  It recieves application level messages like did the app finish launching or did it terminate etc. 
//

import UIKit
import Firebase
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let locationService = LocationServices()
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessProvider>()
    let jsonDecoder = JSONDecoder()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        //Initialise and Configure your Firebase here:
        FirebaseApp.configure()
        
        switch locationService.status {
        case .notDetermined, .denied, .restricted:
            let locationViewController = storyBoard.instantiateViewController(withIdentifier: "AccessViewController") as? AccessViewController
            window.rootViewController = locationViewController
            locationViewController?.locationService = locationService
            window.rootViewController = locationViewController
        default:
            let nav = storyBoard.instantiateViewController(withIdentifier: "navBar1") as? UINavigationController
            window.rootViewController = nav
            loadBusiness()
        }
        window.makeKeyAndVisible()
        
        return true
    }

    private func loadBusiness() {
        service.request(.search(lat: 29.973330, long: -95.687332)) { (result) in
            switch result {
            case .success(let response):
                let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                print("ROOT: \(root)")
                let viewModel = root?.businesses.compactMap(RestaurantListViewModel.init)
                if let nav = self.window.rootViewController as? UINavigationController,
                    let myListTableViewController = nav.topViewController as? MyListTableViewController {
                        myListTableViewController.viewModels = viewModel ?? []
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    

}

