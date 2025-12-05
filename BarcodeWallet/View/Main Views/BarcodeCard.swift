//
//  BarcodeCard.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/17/24.
//

import SwiftUI
import AVFoundation
import RSBarcodes_Swift
struct BarcodeCard: View {
    var barcodeGenerator = BarcodeGenModel()
    let barcodeType: String
    @Binding var barcodeName: String
    let barcodeNum: String
    @Binding var cardColor: Color
//    let expirationDate: Date?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                        .foregroundStyle(cardColor)
                    VStack{
                        HStack{
                            Text(barcodeName)
                                .font(.system(.subheadline, design: .monospaced))
                                .bold()
                                .foregroundColor(cardColor.autoContrastTextColor)
                            Spacer()
                            
                        }
                        .padding()
                        Spacer()
                        switch barcodeType{
                        case "org.iso.Code128":
                            Code128(barcodeData: barcodeNum)
                        case "VNBarcodeSymbologyCode128":
                            Code128(barcodeData: barcodeNum)
                            
                        case "Codabar":
                            CodabarView(text: .constant(barcodeNum))
                                .frame(height: 100)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.white)
                                        .padding([.leading, .trailing], 5)
                                        .frame(height: 110)
                                }
                            
                        case "VNBarcodeSymbologyCodabar":
                            CodabarView(text: .constant(barcodeNum))
                                .frame(height: 100)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.white)
                                        .padding([.leading, .trailing], 5)
                                        .frame(height: 110)
                                }
                            
                        case "org.iso.Code39":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue){
                                Code39(barcodeData: barcodeNum, image: image)
                                
                                
                            }
                            
                        case "VNBarcodeSymbologyCode39":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue){
                                Code39(barcodeData: barcodeNum, image: image)
                                
                                
                            }
                        case "com.intermec.Code93":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue){
                                Code39(barcodeData: barcodeNum, image: image)
                                
                            }
                        case "VNBarcodeSymbologyCode93":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue){
                                Code39(barcodeData: barcodeNum, image: image)
                                
                            }
                            
                        case "org.gs1.EAN-8":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue){
                                En8(barcodeData: barcodeNum, image: image)
                                
                            }
                        case "VNBarcodeSymbologyEAN8":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue){
                                En8(barcodeData: barcodeNum, image: image)
                                
                            }
                            
                        case "org.gs1.EAN-13":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue){
                                En13(barcodeData: barcodeNum, image: image)
                                
                            }
                        case "VNBarcodeSymbologyEAN13":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue){
                                En13(barcodeData: barcodeNum, image: image)
                                
                            }
                            
                        case "org.iso.PDF417":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue){
                                Pdf417(image: image)
                               
                                
                            }
                        case "VNBarcodeSymbologyPDF417":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue){
                                Pdf417(image: image)
                               
                                
                            }
                            
                        case "org.ansi.Interleaved2of5":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.interleaved2of5.rawValue){
                                Interleaved2of5(barcodeData: barcodeNum, image: image)
                                
                            }
                            
                        case "VNBarcodeSymbologyITF14":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue){
                                ITF14(barcodeData: barcodeNum, image: image)
                                
                            }
                        case "org.gs1.ITF14":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue){
                                ITF14(barcodeData: barcodeNum, image: image)
                                
                            }
                        
                        case "org.iso.Aztec" :
                            
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue){
                                Aztec(image: image)
                                
                            }
                        case "VNBarcodeSymbologyAztec":
                            
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue){
                                Aztec(image: image)
                                
                            }
                            
                        case "org.iso.QRCode":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue){
                                QRcode(image: image)
                                
                            }
                        case "VNBarcodeSymbologyQR":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue){
                                QRcode(image: image)
                                
                                
                            }
                            
                        case "org.gs1.UPC-E":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue){
                                Upce(barcodeData: barcodeNum, image: image)
                                
                            }
                        case "VNBarcodeSymbologyUPCE":
                            if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue){
                                Upce(barcodeData: barcodeNum, image: image)
                                
                            }
                            
                        default:
                            Text("Barcode is unsupported")
                        }
                            

                    }
                }
                
            }
            .padding([.leading, .trailing], 5)
            .frame(minHeight: 250, maxHeight: 250)
            
        }
        
    }
}

#Preview {
    BarcodeCard(barcodeType: "Codabar" ,barcodeName: .constant("Loyalty"), barcodeNum: "A123456789B", cardColor: .constant(Color.red))
}
