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
    let cardColor: Color
    @Environment(\.dismiss) private var dismiss
    @State private var showCard = false
    @Binding var deviceBrightness: CGFloat
    @State private var updateCardSheet = false
    
    var body: some View {
        NavigationStack{
            VStack{
                BarcodeCard(barcodeType: barcodeType, barcodeName: barcodeName, barcodeNum: barcodeNumber, cardColor: cardColor)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showCard)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        
                        animateBrightness(to: deviceBrightness, duration: 0.5)
                        dismiss()
                    }label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button{
                        updateCardSheet.toggle()
                    }label: {
                        Image(systemName: "pencil.circle")
                    }
                    
                })
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
                print(cardId)
                withAnimation {
                    showCard = true
                    UIScreen.main.brightness = 1.0
                    
                    
                }
            }
            .sheet(isPresented: $updateCardSheet) {
                UpdateCardView(isPresented: $updateCardSheet)
            }
        }
    }
    func animateBrightness(to target: CGFloat, duration: TimeInterval = 0.5) {
        let start = UIScreen.main.brightness
        let steps = 60            // frames in the animation
        let stepTime = duration / Double(steps)

        for step in 0...steps {
            let progress = Double(step) / Double(steps)
            let value = start + (target - start) * CGFloat(progress)

            DispatchQueue.main.asyncAfter(deadline: .now() + stepTime * Double(step)) {
                UIScreen.main.brightness = value
            }
        }
    }
}

#Preview {
    CardDetailView(cardId: UUID(), barcodeType: "VNBarcodeSymbologyQR" ,barcodeName: "Loyalty", barcodeNumber: "11220000103djasjdkashdajsndjasnaksjdsdakhsjdkajshdkjsakjhsdk692", cardColor: Color.white, deviceBrightness: .constant(0.5))
}
