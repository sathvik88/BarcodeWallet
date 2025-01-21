//
//  UploadViewController.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 1/6/25.
//

import Foundation
import UIKit
import Vision

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var onBarcodeDetected: ((String, String) -> Void)? // Callback for detected barcode data

        func selectImageFromGallery() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                detectBarcodes(from: image)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func detectBarcodes(from image: UIImage) {
            guard let cgImage = image.cgImage else { return }

            let request = VNDetectBarcodesRequest { [weak self] (request, error) in
                if let error = error {
                    print("Error detecting barcode: \(error)")
                    return
                }

                guard let results = request.results as? [VNBarcodeObservation] else { return }

                for barcode in results {
                    let symbology = barcode.symbology.rawValue
                    let payload = barcode.payloadStringValue ?? "No Value"
                    
                    // Trigger the callback with detected data
                    self?.onBarcodeDetected?(symbology, payload)
                }
            }

            request.symbologies = [
                .aztec, .code39, .code93, .code128, .ean8, .ean13,
                 .itf14, .pdf417, .qr, .upce, .codabar
            ]

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Error performing barcode detection: \(error)")
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            selectImageFromGallery()
        }
}
