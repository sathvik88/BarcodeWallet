//
//  BarcodeGenModel.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import Foundation
import CoreImage.CIFilterBuiltins
import UIKit
import SwiftUI

struct BarcodeGenModel{
    let context = CIContext()
    let generator = CIFilter.code128BarcodeGenerator()
    
    func generateBarcode(text: String) -> Image{
        let generator = CIFilter.code128BarcodeGenerator()
        generator.message = Data(text.utf8)
        
        if let outputImage = generator.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
            
            let uiImage = UIImage(cgImage: cgImage)
            
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "barcode")
    }
}
