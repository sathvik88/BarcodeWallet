//
//  WalletService.swift
//  BarcodeWallet
//
//  Created by Sathvik on 5/8/26.
//

import Foundation
import PassKit
import SwiftUI

// MARK: - Wallet Service
class WalletService: NSObject, ObservableObject {
    
    static let shared = WalletService()
    
    private let serverURL = "http://192.168.0.26:3000/sign-pass"
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    private func mapBarcodeFormat(_ format: String) -> String {
        switch format {
        // Supported formats
        case "VNBarcodeSymbologyQR":            return "qr"
        case "VNBarcodeSymbologyPDF417":        return "pdf417"
        case "VNBarcodeSymbologyAztec":         return "aztec"
        case "VNBarcodeSymbologyCode128":       return "code128"
        case "org.iso.Code128":                 return "code128"
        // Unsupported formats
        case "VNBarcodeSymbologyEAN13":         return "ean13"
        case "VNBarcodeSymbologyEAN8":          return "ean8"
        case "VNBarcodeSymbologyCode39":        return "code39"
        case "VNBarcodeSymbologyCode39Mod43":   return "code39Mod43"
        case "VNBarcodeSymbologyCode93":        return "code93"
        case "VNBarcodeSymbologyITF14":         return "itf14"
        case "VNBarcodeSymbologyI2of5":         return "interleaved2of5"
        case "VNBarcodeSymbologyUPCE":          return "upce"
        case "VNBarcodeSymbologyCodabar":       return "codabar"
        default:                                return "qr"
        }
    }
    var isWalletAvailable: Bool {
        PKAddPassesViewController.canAddPasses()
    }
    
    // MARK: - Fetch & Present Pass
    func addToWallet(
        barcodeValue: String,
        barcodeFormat: String,
        title: String,
        cardColor: Color,
        barcodeImage: UIImage? = nil,
        from viewController: UIViewController
    ) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let pass = try await fetchPass(
                barcodeValue: barcodeValue,
                barcodeFormat: barcodeFormat,
                title: title,
                cardColor: cardColor,
                barcodeImage: barcodeImage
            )
            
            await MainActor.run {
                isLoading = false
                presentPass(pass, from: viewController)
            }
            
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Fetch Pass from Server
    private func fetchPass(
        barcodeValue: String,
        barcodeFormat: String,
        title: String,
        cardColor: Color,
        barcodeImage: UIImage?
    ) async throws -> PKPass {
        
        guard let url = URL(string: serverURL) else {
            throw WalletError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: String] = [
            "barcodeValue": barcodeValue,
            "barcodeFormat": mapBarcodeFormat(barcodeFormat),
            "title": title,
            "backgroundColor": colorToRGB(cardColor),
            "foregroundColor": isDarkColor(cardColor) ? "rgb(255,255,255)" : "rgb(0,0,0)",
            "labelColor": isDarkColor(cardColor) ? "rgb(200,200,200)" : "rgb(100,100,100)"
        ]
        
        
        print(body)
        print(barcodeFormat)
        // Attach image for unsupported formats
        
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WalletError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw WalletError.serverError(httpResponse.statusCode)
        }
        
        return try PKPass(data: data)
    }
    
    // MARK: - Present Pass
    private func presentPass(_ pass: PKPass, from viewController: UIViewController) {
        guard isWalletAvailable else {
            errorMessage = "Apple Wallet is not available on this device"
            return
        }
        
        guard let passVC = PKAddPassesViewController(pass: pass) else {
            errorMessage = "Could not create Wallet view controller"
            return
        }
        
        viewController.present(passVC, animated: true)
    }
    private func colorToRGB(_ color: Color) -> String {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return "rgb(\(Int(r*255)),\(Int(g*255)),\(Int(b*255)))"
    }
    private func isDarkColor(_ color: Color) -> Bool {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance < 0.5
    }
}

// MARK: - Errors
enum WalletError: LocalizedError {
    case invalidURL
    case imageConversionFailed
    case invalidResponse
    case serverError(Int)
    case walletNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid server URL"
        case .imageConversionFailed:
            return "Failed to convert barcode image"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .walletNotAvailable:
            return "Apple Wallet is not available on this device"
        }
    }
    
}

