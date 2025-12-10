//
//  Coordinator.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import Foundation
import AVFoundation
import SwiftUI

class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate{
    @Binding var scanResult: String
    @Binding var barcodeType: String
    weak var controller: BarcodeScannerController?
    init(_ scanResult: Binding<String>, barcodeType: Binding<String>) {
        self._scanResult = scanResult
        self._barcodeType = barcodeType
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let viewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.rootViewController else { return }
        if let scannerVC = findScannerController(in: viewController) {
            if metadataObjects.isEmpty {
                // No barcode detected - hide overlay
                scannerVC.updateOverlay(with: nil)
                return
            }
            
            // Get the metadata object
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            // Update the overlay with the barcode position
            scannerVC.updateOverlay(with: metadataObj)
            
            if let result = metadataObj.stringValue {
                scanResult = result
                barcodeType = "\(metadataObj.type.rawValue)"
            }
        }
        
    }
    private func findScannerController(in viewController: UIViewController) -> BarcodeScannerController? {
        if let scanner = viewController as? BarcodeScannerController {
            return scanner
        }
        
        for child in viewController.children {
            if let scanner = findScannerController(in: child) {
                return scanner
            }
        }
        
        if let presented = viewController.presentedViewController {
            return findScannerController(in: presented)
        }
        
        return nil
    }
    
    
}


