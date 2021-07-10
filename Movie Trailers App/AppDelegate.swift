//
//  AppDelegate.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import UIKit
import SDWebImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupImageCachingExpiration()
        return true
    }
    
    private func setupImageCachingExpiration() {
        //Set image cache expiration limit to 1 day
        SDImageCache.shared.config.maxDiskAge = 60 * 60 * 24
    }
}

