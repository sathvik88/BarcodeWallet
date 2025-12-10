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
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
           return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            videoInput = try AVCaptureDeviceInput.init(device: captureDevice)
                
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
        guard let videoPreview = videoPreviewLayer else {return}
        view.layer.addSublayer(videoPreview)
        
        qrCodeFrameView = UIView()
        
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.systemGreen.cgColor
            qrCodeFrameView.layer.borderWidth = 3
            qrCodeFrameView.layer.cornerRadius = 8
            qrCodeFrameView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        
        
        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
            
        }
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            videoPreviewLayer?.frame = view.layer.bounds
        }
    // Method to update the overlay frame
    func updateOverlay(with barCodeObject: AVMetadataMachineReadableCodeObject?) {
        guard let qrCodeFrameView = qrCodeFrameView else { return }
        
        
        
        if let barCodeObject = barCodeObject,
           let videoPreviewLayer = videoPreviewLayer {
            // Transform the metadata object coordinates to view coordinates
            let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: barCodeObject)
            
            // Animate the frame to the barcode position
            UIView.animate(withDuration: 0.2) {
                qrCodeFrameView.frame = barCodeObject?.bounds ?? .zero
                qrCodeFrameView.alpha = 1.0
            }
            
        }
        
    }
}

struct BarcodeScanner: UIViewControllerRepresentable{
    @Binding var isLoading: Bool
    @Binding var result: String
    @Binding var barcodeType: String
    func makeUIViewController(context: Context) -> BarcodeScannerController {
        let controller = BarcodeScannerController()
        
        controller.delegate = context.coordinator
        context.coordinator.controller = controller
        return controller
    }
    func updateUIViewController(_ uiViewController: BarcodeScannerController, context: Context) {
       
        if !barcodeType.isEmpty{
            
            isLoading = true

            DispatchQueue.main.asyncAfter(deadline: .now()){
                uiViewController.captureSession.stopRunning()
                isLoading = false
            }
            
        }
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator($result, barcodeType: $barcodeType)
    }
}
extension BarcodeScannerController {
    
    // Optional: Add a stylized overlay with corners instead of full border
    func setupCornerOverlay() {
        qrCodeFrameView?.layer.borderWidth = 0
        qrCodeFrameView?.backgroundColor = .clear
        
        // You can add corner markers using CAShapeLayer
        addCornerMarkers(to: qrCodeFrameView!)
    }
    
    private func addCornerMarkers(to view: UIView) {
        let cornerLength: CGFloat = 20
        let cornerWidth: CGFloat = 3
        let color = UIColor.systemGreen.cgColor
        
        // Top-left corner
        let topLeft = CAShapeLayer()
        let topLeftPath = UIBezierPath()
        topLeftPath.move(to: CGPoint(x: cornerLength, y: 0))
        topLeftPath.addLine(to: CGPoint(x: 0, y: 0))
        topLeftPath.addLine(to: CGPoint(x: 0, y: cornerLength))
        topLeft.path = topLeftPath.cgPath
        topLeft.strokeColor = color
        topLeft.lineWidth = cornerWidth
        topLeft.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(topLeft)
        
        
    }
}

