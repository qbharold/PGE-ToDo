//
//  AppDelegate.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/1/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("\n=== didFinishLaunchingWithOptions ===\n")
        //ORIGINAL print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .u serDomainMask, true).last! as String)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
        print("\n=== Application will terminate ===\n")
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        
        let container = NSPersistentContainer(name: "PGE_ToDo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("\n=== Unresolved error \(error), \(error.userInfo) ===\n")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                print("\n=== Trying to save ===\n")
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\n === Unresolved error \(nserror), \(nserror.userInfo) === \n")
            }
        }
    }

}

