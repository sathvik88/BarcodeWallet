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
    @Binding var barcodeName: String
    let barcodeNumber: String
    @Binding var cardColor: Color
    @Environment(\.dismiss) private var dismiss
    @State private var showCard = false
    @Binding var deviceBrightness: CGFloat
    @State private var updateCardSheet = false
    @State private var red: Float = 1
    @State private var green: Float = 1
    @State private var blue: Float = 1
    
    var body: some View {
        NavigationStack{
            VStack{
                BarcodeCard(barcodeType: barcodeType, barcodeName: $barcodeName, barcodeNum: barcodeNumber, cardColor: $cardColor)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showCard)
                    .id(cardColor)
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
                        red = Float(UIColor(cardColor).components.red)
                        green = Float(UIColor(cardColor).components.green)
                        blue = Float(UIColor(cardColor).components.blue)
                        print(red)
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
                UpdateCardView(cardId: cardId, red: $red, green: $green, blue: $blue, isPresented: $updateCardSheet)
                    .onDisappear(){
                        cardColor = Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue))
                        print(red)
                    }
                    
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
    CardDetailView(cardId: UUID(), barcodeType: "VNBarcodeSymbologyQR" ,barcodeName: .constant("Loyalty"), barcodeNumber: "11220000103djasjdkashdajsndjasnaksjdsdakhsjdkajshdkjsakjhsdk692", cardColor: .constant(Color.white), deviceBrightness: .constant(0.5))
}
