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
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.white)
                            .shadow(radius: 10)
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
                                VStack{
                                    barcodeGenerator.generateCode128Barcode(text: barcodeData)
                                        .resizable()
                                        .frame(width: 200,height: 100)
                                    Text(barcodeData)
                                        .foregroundStyle(Color.black)
                                        .font(.footnote)
                                        
                                }
                                .padding()
                            case "VNBarcodeSymbologyCode128":
                                VStack{
                                    barcodeGenerator.generateCode128Barcode(text: barcodeData)
                                        .resizable()
                                        .frame(width: 200,height: 100)
                                    Text(barcodeData)
                                        .foregroundStyle(Color.black)
                                        .font(.footnote)
                                    
                                }
                                .padding()
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
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "VNBarcodeSymbologyCode39":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "com.intermec.Code93":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "VNBarcodeSymbologyCode93":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "VNBarcodeSymbologyEAN8":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "org.gs1.EAN-8":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "VNBarcodeSymbologyEAN13":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "org.gs1.EAN-13":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "org.iso.PDF417":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        
                                    }
                                    .padding()
                                    .padding(.bottom)
                                    
                                }
                                
                            case "VNBarcodeSymbologyPDF417":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        
                                    }
                                    .padding()
                                    .padding(.bottom)
                                   
                                    
                                }
                            case "org.ansi.Interleaved2of5":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.interleaved2of5.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "VNBarcodeSymbologyITF14":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "org.gs1.ITF14":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "org.iso.Aztec":
                                
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue){
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
                                
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue){
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
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue){
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
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue){
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
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                    
                                }
                            case "VNBarcodeSymbologyUPCE":
                                if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue){
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200,height: 80)
                                        Text(barcodeData)
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
                    .frame(maxHeight: 250)
                }
                
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
                
                Spacer()
                Button{
                    let barcodeDataController = BarcodeData(context: moc)
                    barcodeDataController.id = UUID()
                    barcodeDataController.name = title
                    barcodeDataController.barcodeNumber = barcodeData
                    barcodeDataController.barcodeType = barcodeType
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
        }
        .padding([.leading, .trailing, .top])
        .onAppear(){
            isLoading = false
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CreateBarcodeView(barcodeType: .constant("org.gs1.UPC-E"), barcodeData: .constant("01234565"), dismiss: .constant(false), isLoading: .constant(false))
}
