//
//  BarcodeDetailView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/24.
//

import SwiftUI

struct BarcodeDetailView: View {
    @State private var barcodeName = ""
    @State private var barcodeDescription = ""
    @Binding var showDetails: Bool
    let barcodeString: String
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                
                ZStack{
                    TextField("Barcode Name", text: $barcodeName)
                        .padding()
                    Color.gray
                        .opacity(0.2)
                        .frame(width: .infinity, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                }
                .padding(.bottom)
                ZStack{
                    TextField("Barcode Description (optional)", text: $barcodeName)
                        .padding()
                    Color.gray
                        .opacity(0.2)
                        .frame(width: .infinity, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                }
                .padding(.bottom)
                Spacer()
                Button{
                    showDetails.toggle()
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
            .padding([.leading, .trailing])
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        showDetails.toggle()
                    }label: {
                        Text("Done")
                            .bold()
                    }
                }
            }
        }
        
    }
}

#Preview {
    BarcodeDetailView(showDetails: .constant(false), barcodeString: "A25149005991464B")
}
