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
    let barcodeName: String
    let barcodeNum: String
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 10)
                VStack{
                    HStack{
                        Text(barcodeName)
                            .font(.system(.subheadline, design: .monospaced))
                            .bold()
                            .foregroundStyle(Color.blue)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                    switch barcodeType{
                    case "org.iso.Code128":
                        VStack{
                            barcodeGenerator.generateCode128Barcode(text: barcodeNum)
                                .resizable()
                                .frame(width: 200,height: 100)
                            Text(barcodeNum)
                                .foregroundStyle(Color.black)
                                .font(.footnote)
                            
                        }
                        .padding()
                    case "VNBarcodeSymbologyCode128":
                        VStack{
                            barcodeGenerator.generateCode128Barcode(text: barcodeNum)
                                .resizable()
                                .frame(width: 200,height: 100)
                            Text(barcodeNum)
                                .foregroundStyle(Color.black)
                                .font(.footnote)
                            
                        }
                        .padding()
                        
                    case "Codabar":
                        CodabarView(text: .constant(barcodeNum))
                            .frame(height: 100)
                            .padding()
                            .padding(.bottom)
                        
                    case "VNBarcodeSymbologyCodabar":
                        CodabarView(text: .constant(barcodeNum))
                            .frame(height: 100)
                            .padding()
                            .padding(.bottom)
                    case "org.iso.Code39":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                        
                    case "VNBarcodeSymbologyCode39":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                    case "com.intermec.Code93":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                    case "VNBarcodeSymbologyCode93":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                        
                    case "org.gs1.EAN-8":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                    case "VNBarcodeSymbologyEAN8":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                        
                    case "org.gs1.EAN-13":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                    case "VNBarcodeSymbologyEAN13":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                        
                    case "org.iso.PDF417":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                
                            }
                            .padding()
                            .padding(.bottom)
                           
                            
                        }
                    case "VNBarcodeSymbologyPDF417":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                
                            }
                            .padding()
                            .padding(.bottom)
                           
                            
                        }
                        
                    case "org.ansi.Interleaved2of5":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.interleaved2of5.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                        
                    case "VNBarcodeSymbologyITF14":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                    case "org.gs1.ITF14":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                    
                    case "org.iso.Aztec" :
                        
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue){
                            VStack{
                                if let scaledImg = RSAbstractCodeGenerator.resizeImage(image, scale: CGFloat(20)){
                                    Image(uiImage: scaledImg)
                                }
                            }
                            .frame(width: 100,height: 100)
                            .padding()
                            .padding(.bottom)
                            
                        }
                    case "VNBarcodeSymbologyAztec":
                        
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue){
                            VStack{
                                if let scaledImg = RSAbstractCodeGenerator.resizeImage(image, scale: CGFloat(20)){
                                    Image(uiImage: scaledImg)
                                }
                            }
                            .frame(width: 100,height: 100)
                            .padding()
                            .padding(.bottom)
                            
                        }
                        
                    case "org.iso.QRCode":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue){
                            VStack{
                                if let scaledImg = RSAbstractCodeGenerator.resizeImage(image, scale: CGFloat(12)){
                                    Image(uiImage: scaledImg)
                                }
                            }
                            .frame(width: 100,height: 100)
                            .padding()
                            .padding(.bottom)
                            
                        }
                    case "VNBarcodeSymbologyQR":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue){
                            VStack{
                                if let scaledImg = RSAbstractCodeGenerator.resizeImage(image, scale: CGFloat(12)){
                                    Image(uiImage: scaledImg)
                                }
                            }
                            .frame(width: 100,height: 100)
                            .padding()
                            .padding(.bottom)
                            
                        }
                        
                    case "org.gs1.UPC-E":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                    case "VNBarcodeSymbologyUPCE":
                        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeNum, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue){
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200,height: 80)
                                Text(barcodeNum)
                                    .font(.footnote)
                                    .foregroundStyle(Color.black)
                            }
                            .padding()
                            
                        }
                        
                    default:
                        Text("Barcode is unsupported")
                    }

                }
            }
            .padding([.leading, .trailing], 5)
            .frame(minHeight: 250, maxHeight: 250)
        }
    }
}

#Preview {
    BarcodeCard(barcodeType: "org.iso.Code128" ,barcodeName: "Loyalty", barcodeNum: "11220000103692")
}
