//
//  AppDelegate.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/7/25.
//
import UIKit
import Foundation
class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIScreen.main.brightness = AppBrightness.shared.restoreBrightness
    }

    func applicationWillResignActive(_ application: UIApplication) {
        UIScreen.main.brightness = AppBrightness.shared.dimBrightness
    }
}

class AppBrightness {
    static let shared = AppBrightness()

    private init() { }

    /// Store the user's original brightness
    var originalBrightness: CGFloat = UIScreen.main.brightness

    /// The brightness level when the app dims the screen
    var dimBrightness: CGFloat = 0.2

    /// The brightness to restore to when app becomes active
    var restoreBrightness: CGFloat {
        return originalBrightness
    }

    /// Call this when you want to force brightness to full for a screen
    func setMaxBrightness() {
        originalBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
    }

    /// Restore saved brightness
    func restore() {
        UIScreen.main.brightness = originalBrightness
    }
}
