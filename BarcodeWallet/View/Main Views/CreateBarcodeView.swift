//
//  CreateBarcodeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/17/24.
//

import SwiftUI
import RSBarcodes_Swift
import AVFoundation
struct CreateBarcodeView: View {
    @Binding var barcodeType: String
    @Binding var barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    @Binding var dismiss: Bool
    @State private var title = ""
    @FocusState private var showKeyboard
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var expenses: FetchedResults<BarcodeData>
    @Binding var isLoading: Bool
    @State private var selectedColor = Color(.sRGB, red: 1, green: 1, blue: 1)
    @State private var isCoupon = false
    @State private var expirationDate = Date()
    @Environment(\.self) var environmentValues
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(selectedColor)
                            .shadow(radius: 5)
                        VStack{
                            HStack{
                                Text(title)
                                    .font(.system(.subheadline, design: .monospaced))
                                    .bold()
                                    .foregroundStyle(Color.blue)
                                Spacer()
                            }
                            .padding()
                            
                            Spacer()
                            switch barcodeType{
                            case "org.iso.Code128":
                                Code128(barcodeData: barcodeData)
                                
                            case "VNBarcodeSymbologyCode128":
                                Code128(barcodeData: barcodeData)
                                
                            case "Codabar":
                                CodabarView(text: .constant(barcodeData))
                                    .frame(height: 100)
                                    .padding()
                                    .padding(.bottom)
                            case "VNBarcodeSymbologyCodabar":
                                CodabarView(text: .constant(barcodeData))
                                    .frame(height: 100)
                                    .padding()
                                    .padding(.bottom)
                            case "org.iso.Code39":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue){
                                    Code39(barcodeData: barcodeData, image: image)
                                    
                                }
                            case "VNBarcodeSymbologyCode39":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue){
                                    Code39(barcodeData: barcodeData, image: image)
                                    
                                }
                            case "com.intermec.Code93":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue){
                                    Code39(barcodeData: barcodeData, image: image)
                                   
                                    
                                }
                            case "VNBarcodeSymbologyCode93":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue){
                                    Code39(barcodeData: barcodeData, image: image)
                                    
                                    
                                }
                            case "VNBarcodeSymbologyEAN8":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue){
                                    En8(barcodeData: barcodeData, image: image)
                                    
                                }
                            case "org.gs1.EAN-8":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue){
                                    En8(barcodeData: barcodeData, image: image)
                                    
                                   
                                    
                                }
                            case "VNBarcodeSymbologyEAN13":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue){
                                    En13(barcodeData: barcodeData, image: image)
                                    
                                }
                            case "org.gs1.EAN-13":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue){
                                    En13(barcodeData: barcodeData, image: image)
                                    
                                    
                                }
                            case "org.iso.PDF417":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue){
                                    Pdf417(barcodeData: barcodeData, image: image)
                                    
                                    
                                }
                                
                            case "VNBarcodeSymbologyPDF417":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue){
                                    Pdf417(barcodeData: barcodeData, image: image)
                                    
                                   
                                    
                                }
                            case "org.ansi.Interleaved2of5":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.interleaved2of5.rawValue){
                                    Interleaved2of5(barcodeData: barcodeData, image: image)
                                    
                                    
                                }
                            case "VNBarcodeSymbologyITF14":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue){
                                    ITF14(barcodeData: barcodeData, image: image)
                                    
                                }
                            case "org.gs1.ITF14":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue){
                                    ITF14(barcodeData: barcodeData, image: image)
                                   
                                    
                                }
                            case "org.iso.Aztec":
                                
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue){
                                    Aztec(image: image)
                                    
                                    
                                }
                            case "VNBarcodeSymbologyAztec":
                                
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue){
                                    Aztec(image: image)
                                    
                                    
                                }
                            case "org.iso.QRCode":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue){
                                    QRcode(image: image)
                                    
                                }
                            case "VNBarcodeSymbologyQR":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue){
                                    QRcode(image: image)
                                    
                                    
                                }
                            case "org.gs1.UPC-E":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue){
                                    Upce(barcodeData: barcodeData, image: image)
                                    
                                    
                                }
                            case "VNBarcodeSymbologyUPCE":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue){
                                    Upce(barcodeData: barcodeData, image: image)
                                    
                                    
                                }
                            default:
                                Text("Barcode is unsupported")
                            }
                            
                        }
                        
                        
                    }
                    .padding([.leading, .trailing], 5)
                    .frame(maxHeight: 250)
                }
                .padding([.top, .bottom])
                .padding([.leading, .trailing], 5)
                Spacer()
                GroupBox{
                    HStack{
                        Text("Name")
                            .bold()
                            .padding(.trailing)
                        TextField("Card Name", text: $title)
                            .padding()
                            .focused($showKeyboard)
                    }
                }
                GroupBox{
                    ColorPicker("Choose a Color", selection: $selectedColor)
                        .padding()
                }
                GroupBox{
                    HStack{
                        Toggle("Is this a coupon?", isOn: $isCoupon)
                    }
                }
                if isCoupon{
                    GroupBox{
                        DatePicker(
                            "Expiration Date", // Label for the DatePicker
                            selection: $expirationDate, // Binding to the state variable
                            displayedComponents: [.date] // Components to display (date and time)
                        )
                        
                        .datePickerStyle(.compact)
                    }
                    
                }
                
                Spacer()
                
            }
            Button{
                
                let barcodeDataController = BarcodeData(context: moc)
                let pickedColor = UIColor(selectedColor)
                barcodeDataController.id = UUID()
                barcodeDataController.name = title
                barcodeDataController.barcodeNumber = barcodeData
                barcodeDataController.barcodeType = barcodeType
                barcodeDataController.red = Float(pickedColor.components.red)
                barcodeDataController.green = Float(pickedColor.components.green)
                barcodeDataController.blue = Float(pickedColor.components.blue)
                barcodeDataController.alpha = Float(pickedColor.components.alpha)
                if isCoupon{
                    barcodeDataController.expirationDate = expirationDate
                }
                
                try? moc.save()
                dismiss.toggle()
            }label: {
                Text("Save")
                    .bold()
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .padding(.bottom)
        }
        .padding([.leading, .trailing, .top])
        .onAppear(){
            isLoading = false
        }
        .navigationBarBackButtonHidden()
    }
}
extension Color {
        var rgba: (red: Double, green: Double, blue: Double, alpha: Double)? {
            guard let components = UIColor(self).cgColor.components else { return nil }
            return (red: Double(components[0]), green: Double(components[1]), blue: Double(components[2]), alpha: Double(components[3]))
        }
    }

#Preview {
    CreateBarcodeView(barcodeType: .constant("org.gs1.EAN-13"), barcodeData: .constant("0009800125104"), dismiss: .constant(false), isLoading: .constant(false))
}
