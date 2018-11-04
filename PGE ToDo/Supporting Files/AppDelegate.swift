//
//  AppDelegate.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/1/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//        print(Realm.Configuration.defaultConfiguration.fileURL)

        do {
            let realm = try Realm()
            print(realm)
        } catch {
            print("Error initializing new Realm, \(error)")
        }

    return true
    }

}

