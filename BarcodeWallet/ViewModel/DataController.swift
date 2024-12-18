//
//  DataController.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/13/24.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "DataModel")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error{
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
