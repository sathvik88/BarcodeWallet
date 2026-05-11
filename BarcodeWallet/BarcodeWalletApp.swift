//
//  BarcodeWalletApp.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI
import GoogleMobileAds
import RevenueCat
@main
struct BarcodeWalletApp: App {
    @StateObject private var dataController =  DataController()
    @Environment(\.scenePhase) private var scenePhase
    init(){
        MobileAds.shared.start{ start in}
        Purchases.configure(withAPIKey: "appl_RHXwalTzjyJnJIUAvyoemEUSsoP")
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.persistentCloudKitContainer.viewContext)
                .onChange(of: scenePhase) { _, newValue in
                    if newValue == .active {
                        ATTAuthorization.requestIfNeeded()
                    }
                }
                
        }
    }
}
