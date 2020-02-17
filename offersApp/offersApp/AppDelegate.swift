//
//  AppDelegate.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit

@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var dependencyContainer: ViewControllersProvider?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		
		dependencyContainer = DependencyContainer()
		window.rootViewController = dependencyContainer?.mainViewController
		
		
		self.window = window
		window.makeKeyAndVisible()
		
		let BarButtonItemAppearance = UIBarButtonItem.appearance()
		BarButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
		
		return true
	}
}

