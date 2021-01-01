//
//  AppDelegate.swift
//  RijksMuseum
//
//  Created by Alexander Vorobjov on 12/31/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // swiftlint:disable:next implicitly_unwrapped_optional
    private var appCoordinator: AppCoordinator!

    // swiftlint:disable:next discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        assert(window == nil, "remove storyboard from Info.plist")

        let assembly = AppAssemblyImpl()
        appCoordinator = AppCoordinator(assembly: assembly)

        let window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator.start(in: window)
        self.window = window
        window.makeKeyAndVisible()

        return true
    }
}
