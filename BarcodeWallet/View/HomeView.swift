//
//  HomeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/24.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: []) private var barcodeItems: FetchedResults<BarcodeData>
    @EnvironmentObject var manager: DataManager
    var body: some View {
        NavigationStack{
            VStack{
                if barcodeItems.isEmpty{
                    VStack{
                        GroupBox{
                            Text("Click the '+' icon to add a new barcode")
                                .font(.system(.body, design: .monospaced))
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
                        
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
            
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(DataManager())
}
