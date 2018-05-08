//
//  AppDelegate.swift
//  TestingPresentableComponents
//
//  Copyright © 2018 Juno. All rights reserved.
//

import UIKit

import ReactiveSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let welcomeViewController = WelcomeViewController.create()
        window.rootViewController = welcomeViewController
        window.makeKeyAndVisible()
        self.window = window

        let welcomeScreen = WelcomeScreen()
        self.disposable = welcomeViewController.presenter.present(welcomeScreen)
        self.root = welcomeScreen
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.disposable?.dispose()
    }

    private var disposable: Disposable?
    private var root: WelcomeScreen?
}

