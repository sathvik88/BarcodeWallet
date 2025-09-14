//
//  BarcodeModel.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/24.
//

import Foundation

struct BarcodeModel: Identifiable, Hashable{
    let id = UUID()
    let name: String
    let barcodeNumber: String
    let barcodeType: String
    
    
}
