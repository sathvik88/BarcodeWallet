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
    @State private var isPro = false
    //ATLASCODE LLC Pro
    init(){
        MobileAds.shared.start{ start in}
        Purchases.configure(withAPIKey: "test_wuFXHfNjCbejLeMLLysiWFCQxSE")
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
