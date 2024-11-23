//
//  TabsView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        TabView{
            LinearBarcodeView()
                .tabItem {
                    Image(systemName: "barcode")
                    Text("Barcode")
                }
            QRCodeView()
                .tabItem {
                    Image(systemName: "qrcode")
                    Text("QR Code")
                }
            
        }
    }
}

#Preview {
    TabsView()
}
