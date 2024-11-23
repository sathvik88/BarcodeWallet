//
//  CodabarBarcodeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/22/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
struct CodabarBarcodeView: View {
    let codabarString: String
    private let context = CIContext()
    private let filter = CIFilter.code128BarcodeGenerator() // No need to use "key-value coding"
        
        var body: some View {
            if let barcodeImage = generateBarcode(from: codabarString) {
                Image(uiImage: barcodeImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 300, height: 100)
            } else {
                Text("Invalid Codabar String")
            }
        }
    private func generateBarcode(from string: String) -> UIImage? {
            // Ensure the string is valid
            guard isValidCodabar(string: string) else { return nil }
            
            // Encode the Codabar string
            let encodedString = encodeCodabar(string: string)
            
            // Generate the barcode
            let data = Data(encodedString.utf8)
            filter.message = data
            
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
            
            return nil
        }
    private func isValidCodabar(string: String) -> Bool {
            // Add validation logic for Codabar string
            let allowedCharacters = CharacterSet(charactersIn: "0123456789-$:/.+ABCD")
            return string.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }
        }
    private func encodeCodabar(string: String) -> String {
            // Add encoding logic for Codabar here
            // Note: Add start and stop characters if not included
            var encoded = string
            if !encoded.hasPrefix("A") && !encoded.hasSuffix("A") {
                encoded = "A" + encoded + "A"
            }
            return encoded
        }
}

#Preview {
    CodabarBarcodeView(codabarString: "A1234567890B")
}
