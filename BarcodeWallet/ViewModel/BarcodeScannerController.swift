//
//  BarcodeScannerController.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import Foundation
import SwiftUI
import AVFoundation

class BarcodeScannerController: UIViewController{
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        var qrCodeFrameView: UIView?
    var delegate: AVCaptureMetadataOutputObjectsDelegate?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else{
            print("Failed to get the camera device")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                videoInput = try AVCaptureDeviceInput(device: captureDevice)
                
                // Configure focus
                try captureDevice.lockForConfiguration()
                
                if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
                    captureDevice.focusMode = .continuousAutoFocus
                }
                
                if captureDevice.isFocusPointOfInterestSupported {
                    captureDevice.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
                }
                
                captureDevice.unlockForConfiguration()
                
            } catch {
                print("Error configuring camera: \(error)")
                return
            }
        
        // Set the input device on the capture session.
        captureSession.addInput(videoInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.aztec,
                                                     .code39,
                                                     .code39Mod43,
                                                     .code93,
                                                     .code39Mod43,
                                                     .code128,
                                                     .dataMatrix,
                                                     .ean8,
                                                     .ean13,
                                                     .interleaved2of5,
                                                     .itf14,
                                                     .pdf417,
                                                     .qr,
                                                     .upce,
                                                     .codabar]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        
        
        
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
}

struct BarcodeScanner: UIViewControllerRepresentable{
    @Binding var result: String
    func makeUIViewController(context: Context) -> BarcodeScannerController {
        let controller = BarcodeScannerController()
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: BarcodeScannerController, context: Context) {
    }
    func makeCoordinator() -> Coordinator {
        Coordinator($result)
    }
}
