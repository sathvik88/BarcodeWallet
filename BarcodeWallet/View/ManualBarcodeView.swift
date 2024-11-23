//
//  ManualBarcode.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI

struct ManualBarcodeView: View {
    @Binding var inputText: String
    var barcodeGen = BarcodeGenModel()
    var body: some View {
        VStack{
//            Text("Please key in your barcode data in the text field")
//                    .font(.headline)
//                    .padding(.bottom, 20)
//            TextField("", text: $inputText)
//                    .padding()
//                    .font(.title)
//                    .background(Color(.systemGray6))
//                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
//            Spacer()
//
//                VStack(spacing: 0) {
//                    barcodeGen.generateBarcode(text: inputText)
//                        .resizable()
//                        .scaledToFit()
//
//                    Text(inputText.isEmpty ? "Unknown data" : inputText)
//                }
            CodabarBarcodeView(codabarString: "A25149005991464B")
        }
        .padding()
    }
}

#Preview {
    ManualBarcodeView(inputText: .constant(""))
}
