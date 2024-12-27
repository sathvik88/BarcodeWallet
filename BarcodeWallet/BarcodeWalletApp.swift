//
//  BarcodeWalletApp.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI

@main
struct BarcodeWalletApp: App {
    @StateObject private var dataController =  DataController()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.persistentCloudKitContainer.viewContext)
        }
    }
}
