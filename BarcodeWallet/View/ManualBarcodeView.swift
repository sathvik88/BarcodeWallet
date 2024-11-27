//
//  ManualBarcode.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI

struct ManualBarcodeView: View {
    @Binding var inputText: String
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 250)
                    .foregroundStyle(Color.white)
                CodabarView(text: .constant("A25149005991464B"))
                    .frame(height: 100)
                    .padding()
            }
            
        }
        
    }
}

#Preview {
    ManualBarcodeView(inputText: .constant(""))
}
