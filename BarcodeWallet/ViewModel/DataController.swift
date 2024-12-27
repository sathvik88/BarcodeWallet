//
//  DataController.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/13/24.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let persistentCloudKitContainer = NSPersistentCloudKitContainer(name: "DataModel")
    
    init(){
        guard let description = persistentCloudKitContainer.persistentStoreDescriptions.first else{
            fatalError("Failed to initialize persistent container")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        persistentCloudKitContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentCloudKitContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentCloudKitContainer.loadPersistentStores { description, error in
            if let error = error{
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
