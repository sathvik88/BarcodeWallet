//
//  ManualBarcode.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI

struct ManualBarcodeView: View {
    @Binding var inputText: String
    let title: String
    var body: some View {
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
                    CodabarView(text: .constant("A25149005991464B"))
                        .frame(height: 100)
                        .padding()
                        .padding(.bottom)
                }
                
                
            }
            .padding([.leading, .trailing], 5)
            .frame(maxHeight: 250)
            
            
        }
        
        
    }
        
}

#Preview {
    ManualBarcodeView(inputText: .constant(""), title: "Sathvik's Library Card")
}
