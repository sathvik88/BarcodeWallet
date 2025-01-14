//
//  BarcodeScannerView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 1/6/25.
//

import Foundation
import SwiftUI
struct BarcodeScannerView: UIViewControllerRepresentable {
    @Binding var detectedSymbology: String
    @Binding var detectedPayload: String
    
    func makeUIViewController(context: Context) -> UploadViewController {
        let viewController = UploadViewController()
        viewController.onBarcodeDetected = { symbology, payload in
            DispatchQueue.main.async {
                detectedSymbology = symbology
                detectedPayload = payload
            }
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UploadViewController, context: Context) {
        // No updates needed
    }
}
