//
//  DataManager.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/24.
//

import Foundation
import CoreData

class DataManager: NSObject, ObservableObject{
    @Published var barcodeItems: [BarcodeModel] = [BarcodeModel]()
    let container: NSPersistentContainer = NSPersistentContainer(name: "BarcodeData")
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
    }
}
