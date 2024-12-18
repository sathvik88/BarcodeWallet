//
//  BarcodeCard.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/17/24.
//

import SwiftUI

struct BarcodeCard: View {
    var barcodeGenerator = BarcodeGenModel()
    let barcodeType: String
    let barcodeName: String
    let barcodeNum: String
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 10)
                VStack{
                    HStack{
                        Text(barcodeName)
                            .font(.system(.subheadline, design: .monospaced))
                            .bold()
                            .foregroundStyle(Color.blue)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                    if barcodeType == "org.iso.Code128"{
                        VStack{
                            barcodeGenerator.generateCode128Barcode(text: barcodeNum)
                                .resizable()
                                .frame(width: 200,height: 100)
                            Text(barcodeNum)
                                .foregroundStyle(Color.black)
                                .font(.footnote)
                                
                        }
                        .padding()
                        
                    }
                    else if barcodeType == "Codabar"{
                        CodabarView(text: .constant(barcodeNum))
                            .frame(height: 100)
                            .padding()
                            .padding(.bottom)
                    }
                }
            }
            .padding([.leading, .trailing], 5)
            .frame(minHeight: 250, maxHeight: 250)
        }
    }
}

#Preview {
    BarcodeCard(barcodeType: "org.iso.Code128" ,barcodeName: "Loyalty", barcodeNum: "11220000103692")
}
