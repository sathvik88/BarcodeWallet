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
    @State private var scanResult = "No Result"
    @State private var barcodeType = ""
    @State private var createCard = false
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
                            BarcodeCard(barcodeType: card.barcodeType ?? "org.iso.Code128", barcodeName: card.name ?? "Loyalty", barcodeNum: card.barcodeNumber ?? "11220000103692")
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
                        displayCamera.toggle()
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $displayCamera, content: {
                CameraView(toggleCamera: $displayCamera, scanResult: $scanResult, barcodeType: $barcodeType)
                    
            })
            
            
            
        }
    }
}


#Preview {
    HomeView()
      
}
