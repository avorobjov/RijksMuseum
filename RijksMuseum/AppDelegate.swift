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

        guard let database = openDatabase() else {
            return false
        }

        let assembly = AppAssemblyImpl(database: database)
        appCoordinator = AppCoordinator(assembly: assembly)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = .label
        appCoordinator.start(in: window)
        self.window = window
        window.makeKeyAndVisible()

        return true
    }

    private func openDatabase() -> Database? {
        do {
            let databaseURL = try DatabaseImpl.defaultDatabaseURL()
            if let database = try? DatabaseImpl(databaseURL: databaseURL) {
                return database
            }

            print("Database: deleted")
            // Failed to open caches database, try to recoved by deleting it
            try FileManager.default.removeItem(at: databaseURL)

            // Make another attempt
            return try DatabaseImpl(databaseURL: databaseURL)
        }
        catch {
            print("Database: open error \(error)")
        }

        return nil
    }
}
