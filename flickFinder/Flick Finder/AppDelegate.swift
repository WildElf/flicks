//
//  AppDelegate.swift
//  Flick Finder
//
//  Created by Eric Zim on 1/5/16.
//  Copyright © 2016 Eric Zim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		
		let storyboad = UIStoryboard(name: "Main", bundle: nil)
		
		let nowPlayingNavigationController = storyboad.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
		let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
		nowPlayingViewController.endPoint = "now_playing"
		nowPlayingViewController.title = "Now Playing"
		nowPlayingViewController.tabBarItem.image = UIImage(named: "clapboard")
		
		
		let topRatedNavigationController = storyboad.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
		let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
		topRatedViewController.endPoint = "top_rated"
		topRatedViewController.title = "Top Rated"
		topRatedViewController.tabBarItem.image = UIImage(named: "star")
		
		let upcomingNavigationController = storyboad.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
		let upcomingViewController = upcomingNavigationController.topViewController as! MoviesViewController
		upcomingViewController.endPoint = "upcoming"
		upcomingViewController.title = "Upcoming"
		upcomingViewController.tabBarItem.image = UIImage(named: "projector")


		let popularNavigationController = storyboad.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
		let popularViewController = popularNavigationController.topViewController as! MoviesViewController
		popularViewController.endPoint = "popular"
		popularViewController.title = "Popular"
		popularViewController.tabBarItem.image = UIImage(named: "heart")

		let tabBarController = UITabBarController()

		tabBarController.viewControllers = [
			nowPlayingNavigationController,
			topRatedNavigationController,
			upcomingNavigationController,
			popularNavigationController ]
		
		window?.rootViewController = tabBarController
		window?.makeKeyAndVisible()
		
		// Override point for customization after application launch.
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

