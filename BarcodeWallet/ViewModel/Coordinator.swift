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
    init(_ scanResult: Binding<String>, barcodeType: Binding<String>) {
        self._scanResult = scanResult
        self._barcodeType = barcodeType
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            scanResult = "No QR code detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        
        if let result = metadataObj.stringValue {
            scanResult = result
            barcodeType = "\(metadataObj.type.rawValue)"
            
            
            
            
        }
    }
    
}


