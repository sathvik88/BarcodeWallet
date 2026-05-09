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
    @Binding var displayImageSheet: Bool
    @Binding var displayError: Bool
    @Binding var barcodeError: String
    
    func makeUIViewController(context: Context) -> UploadViewController {
        let viewController = UploadViewController()
        viewController.onCancel = {
            displayImageSheet = false
        }
        viewController.onBarcodeDetected = { symbology, payload in
            DispatchQueue.main.async {
                detectedSymbology = symbology
                detectedPayload = payload
                
                displayImageSheet = false
            }
        }
        viewController.onBarcodeError = { error in
            DispatchQueue.main.async {
                barcodeError = error.localizedDescription
                displayImageSheet = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    displayError = true
                }
            }
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UploadViewController, context: Context) {
        // No updates needed
    }
}
