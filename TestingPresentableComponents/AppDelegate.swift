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
        let rootViewController = RootStoryViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window

        let rootStory = RootStory()
        self.disposable = rootViewController.presenter.present(rootStory)
        self.root = rootStory
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.disposable?.dispose()
    }

    private var disposable: Disposable?
    private var root: RootStory?
}

