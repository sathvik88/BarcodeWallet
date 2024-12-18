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
                        if barcodeType == "org.iso.Code128"{
                            VStack{
                                barcodeGenerator.generateCode128Barcode(text: barcodeData)
                                    .frame(height: 50)
                                Text(barcodeData)
                                    
                            }
                            .padding()
                            
                        }
                        else if barcodeType == "Codabar"{
                            CodabarView(text: .constant(barcodeData))
                                .frame(height: 100)
                                .padding()
                                .padding(.bottom)
                        }
                        else if barcodeType == "org.iso.Code39"{
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
                            
                        }
                        else{
                            Text("Unsupported Barcode")
                        }
                        
                    }
                    
                    
                }
                .padding([.leading, .trailing], 5)
                .frame(maxHeight: 250)
            }
            
            Spacer()
            TextField("Barcode Name", text: $title)
                .padding()
                .focused($showKeyboard)
            
            Spacer()
            Button{
                let barcodeDataController = BarcodeData(context: moc)
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
        .padding([.leading, .trailing, .top])
        .onAppear(){
            isLoading = false
        }
    }
}

#Preview {
    CreateBarcodeView(barcodeType: .constant("org.iso.Code39"), barcodeData: .constant("16786287"), dismiss: .constant(false), isLoading: .constant(false))
}
