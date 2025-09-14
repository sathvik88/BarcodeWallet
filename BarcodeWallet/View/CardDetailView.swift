//
//  CardDetailView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 9/14/25.
//

import SwiftUI

struct CardDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) private var barcodeItems: FetchedResults<BarcodeData>
    let cardId: UUID
    let barcodeType: String
    let barcodeName: String
    let barcodeNumber: String
    @Environment(\.dismiss) private var dismiss
    @State private var showCard = false
    var body: some View {
        NavigationStack{
            VStack{
                BarcodeCard(barcodeType: barcodeType, barcodeName: barcodeName, barcodeNum: barcodeNumber)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showCard)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "trash")
                        .foregroundStyle(Color.red)
                        .onTapGesture {
                            print("Current cardId: \(cardId)")
                            for i in barcodeItems{
                                if i.name == barcodeName{
                                    moc.delete(i)
                                    try? moc.save()
                                }
                            }
                            dismiss()
                        }
                    
                }
                
            }
            .onAppear(){
                withAnimation {
                    showCard = true
                    UIScreen.main.brightness = 1.0
                    
                }
            }
        }
    }
}

#Preview {
    CardDetailView(cardId: UUID(), barcodeType: "VNBarcodeSymbologyQR" ,barcodeName: "Loyalty", barcodeNumber: "11220000103djasjdkashdajsndjasnaksjdsdakhsjdkajshdkjsakjhsdk692")
}
