//
//  UploadView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 1/6/25.
//

import SwiftUI

struct UploadView: View {
    @Binding var toggleSheet: Bool
    @State private var detectedSymbology: String = "None"
    @State private var detectedPayload: String = "None"
    
    var body: some View {
        VStack {
            Text("Barcode Scanner")
                .font(.largeTitle)
                .padding()
            
            Text("Symbology: \(detectedSymbology)")
            Text("Payload: \(detectedPayload)")
                .padding()
            
            BarcodeScannerView(detectedSymbology: $detectedSymbology, detectedPayload: $detectedPayload)
                .frame(height: 600) // Adjust the frame size as needed
        }
    }
}

#Preview {
    UploadView(toggleSheet: .constant(false))
}
