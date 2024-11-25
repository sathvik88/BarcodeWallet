//
//  BarcodeModel.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/24.
//

import Foundation

struct BarcodeModel: Identifiable{
    let id = UUID()
    let title: String
    let description: String
    let image: Data
}
