//
//  HomeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) private var barcodeItems: FetchedResults<BarcodeData>
    @State private var displayCamera = false
    @State private var displayCard = false
    @State private var scanResult = ""
    @State private var barcodeType = ""
    @State private var createCard = false
    @State private var barcodeName = ""
    var body: some View {
        NavigationStack{
            VStack{
                if barcodeItems.isEmpty{
                    VStack{
                        GroupBox{
                            Text("Click the '+' icon to add a new barcode")
                                .font(.system(.body, design: .monospaced))
                                .onTapGesture {
                                    
                                }
                        }
                    }
                    
                }else{
                    ScrollView{
                        ForEach(barcodeItems){ card in
                            ZStack{
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(Color.white)
                                    .shadow(radius: 10)
                                Text(card.name ?? "Card")
                                    .font(.system(.headline, design: .monospaced))
                                    .bold()
                                    .foregroundStyle(Color.blue)
                            }
                            .frame(minHeight: 50, maxHeight: 50)
                            .onTapGesture {
                                scanResult = card.barcodeNumber ?? ""
                                barcodeType = card.barcodeType ?? ""
                                barcodeName = card.name ?? "Default"
                                displayCard.toggle()
                            }
//                            BarcodeCard(barcodeType: card.barcodeType ?? "org.iso.Code128", barcodeName: card.name ?? "Loyalty", barcodeNum: card.barcodeNumber ?? "11220000103692")
                        }
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Barcode Wallet")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        scanResult = ""
                        barcodeType = ""
                        displayCamera.toggle()
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $displayCamera, content: {
                CameraView(toggleCamera: $displayCamera, scanResult: $scanResult, barcodeType: $barcodeType)
                    
            })
            
            .sheet(isPresented: Binding(get: {
                displayCard
            }, set: {displayCard = $0}), content: {
                
                    if #available(iOS 16.4, *) {
                        BarcodeCard(barcodeType: barcodeType, barcodeName: barcodeName, barcodeNum: scanResult)
                            .presentationBackground(Color.clear)
                    } else {
                        // Fallback on earlier versions
                        BarcodeCard(barcodeType: barcodeType, barcodeName: barcodeName, barcodeNum: scanResult)
                    }
            })
            
            
            
        }
    }
}


#Preview {
    HomeView()
      
}
