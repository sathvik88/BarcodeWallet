//
//  HomeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/24.
//

import SwiftUI
import UIKit
struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) private var barcodeItems: FetchedResults<BarcodeData>
    @State private var displayCamera = false
    @State private var displayCard = false
    @State private var scanResult = ""
    @State private var barcodeType = ""
    @State private var createCard = false
    @State private var barcodeName = ""
    @State private var deviceBrightness: CGFloat = 0.5
    @State private var isLoading = false
    @GestureState private var dragState = DragState.inactive
    @State var selectedCard: BarcodeModel?
    @State var isCardPressed = false
    private static let cardOffset: CGFloat = 50.0
    @State private var cards: [BarcodeModel] = []
    @State private var isCardPresented = false
    //    @State private var walletHeight = 250.0
    @State private var defaultHeight: CGFloat = 0.0
    @State private var cardCount = 0
    @State private var displayOption = false
    @State private var displayUploadCard = false
    @Namespace private var namespace
    private let peek: CGFloat = 80
    private let cardHeight: CGFloat = 220
    @State private var didCaptureBrightness = false
    init(){
        deviceBrightness = UIScreen.main.brightness
    }
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
                    
                }else{
                    ScrollView {
                            VStack(){
                                ZStack {
                                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                                        NavigationLink {
                                            CardDetailView(
                                                cardId: card.id,
                                                barcodeType: card.barcodeType,
                                                barcodeName: .constant(card.name),
                                                barcodeNumber: card.barcodeNumber,
                                                cardColor: .constant(card.cardColor),
                                                deviceBrightness: $deviceBrightness
                                            )
                                            .onDisappear(){
                                                    animateBrightness(to: deviceBrightness, duration: 0.5)
                                                }
                                            
                                            .navigationTransition(.zoom(sourceID: card.id, in: namespace))
                                        } label: {
                                            BarcodeCard(
                                                barcodeType: card.barcodeType,
                                                barcodeName: .constant(card.name),
                                                barcodeNum: card.barcodeNumber,
                                                cardColor: .constant(card.cardColor)
                                            )
                                            
                                        }
                                        .padding([.leading, .trailing], 10)
                                        .matchedTransitionSource(id: card.id, in: namespace)
                                        .stacked(at: index, in: cards.count, peek: 60)
                                        .shadow(radius: 5)
                                    }
                                }
                                .padding(.bottom, CGFloat(cards.count * 60))
                            }
                            .padding(.bottom)
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
                        scanResult = ""
                        barcodeType = ""
                        displayOption.toggle()
                    }label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    if isCardPressed{
                        Button{
                            for index in barcodeItems{
                                if index.name ?? "" == selectedCard?.name{
                                    moc.delete(index)
                                    
                                }
                                
                            }
                            try? moc.save()
                            isCardPressed.toggle()
                        }label: {
                            Image(systemName: "trash")
                        }
                    }
                    
                    
                    
                }
            }
            
            .onAppear(){
                isLoading.toggle()
                cards = []
                for i in barcodeItems{
                    let color = Color(UIColor(
                                red: CGFloat(i.red),
                                green: CGFloat(i.green),
                                blue: CGFloat(i.blue),
                                alpha: CGFloat(i.alpha)
                            ))
                    let finalColor = (i.red == 0 && i.green == 0 && i.blue == 0 && i.alpha == 0)
                                ? Color.white  // ← Your default color here
                                : color
                    cards.append(BarcodeModel(id: i.id ?? UUID(), name: i.name ?? "", barcodeNumber: i.barcodeNumber ?? "", barcodeType: i.barcodeType ?? "", cardColor: finalColor))
                    if i.id == nil{
                        moc.delete(i)
                        try? moc.save()
                    }
                    
                }
                isLoading.toggle()
                if !didCaptureBrightness {
                    deviceBrightness = UIScreen.main.brightness
                    didCaptureBrightness = true
                }
            }
            .onChange(of: barcodeItems.count, perform: { value in
                cards = []
                for i in barcodeItems{
                    let color = Color(UIColor(
                                red: CGFloat(i.red),
                                green: CGFloat(i.green),
                                blue: CGFloat(i.blue),
                                alpha: CGFloat(i.alpha)
                            ))
                    let finalColor = (i.red == 0 && i.green == 0 && i.blue == 0 && i.alpha == 0)
                                ? Color.white  // ← Your default color here
                                : color
                    cards.append(BarcodeModel(id: i.id ?? UUID(), name: i.name ?? "", barcodeNumber: i.barcodeNumber ?? "", barcodeType: i.barcodeType ?? "", cardColor: finalColor))
                }
                
            })
            .sheet(isPresented: $displayOption, content: {
                UploadSheetView(toggleUpload: $displayOption, scanResult: $scanResult, barcodeType: $barcodeType, displayCard: $displayUploadCard)
                    .presentationDetents([.height(200)])
            })
            .sheet(isPresented: $displayUploadCard, content: {
                CreateBarcodeView(barcodeType: $barcodeType, barcodeData: $scanResult, dismiss: $displayUploadCard, isLoading: $isLoading)
            })
            .sheet(isPresented: Binding(get: {
                displayCard
            }, set: {displayCard = $0}), content: {
                
                if #available(iOS 16.4, *) {
                    BarcodeCard(barcodeType: barcodeType, barcodeName: $barcodeName, barcodeNum: scanResult, cardColor: .constant(Color.white))
                        .presentationBackground(Color.clear)
                        .onAppear(){
                            deviceBrightness = UIScreen.main.brightness
                            withAnimation {
                                UIScreen.main.brightness = 1.0
                            }
                            
                        }
                        .onDisappear(){
                            withAnimation {
                                adjustBrightness(to: deviceBrightness, duration: 0.01)
                            }
                            
                            
                        }
                    
                } else {
                    // Fallback on earlier versions
                    BarcodeCard(barcodeType: barcodeType, barcodeName: $barcodeName, barcodeNum: scanResult, cardColor: .constant(Color.white))
                    
                }
            })
            
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
    
    func adjustBrightness(to targetBrightness: CGFloat, duration: TimeInterval = 1.0) {
        // Clamp the target brightness between 0.0 and 1.0
        let clampedBrightness = max(0.0, min(1.0, targetBrightness))
        
        // Capture the initial brightness
        let initialBrightness = UIScreen.main.brightness
        let brightnessChange = clampedBrightness - initialBrightness
        
        // Calculate total frames based on duration and frame rate
        let frameRate: TimeInterval = 1.0 / 60.0 // 60 FPS
        let totalFrames = Int(duration / frameRate)
        var currentFrame = 0
        
        // Create a Timer to update brightness gradually
        Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { timer in
            if currentFrame >= totalFrames {
                // Stop the timer and set the final brightness
                UIScreen.main.brightness = clampedBrightness
                timer.invalidate()
            } else {
                // Calculate the progress (0.0 to 1.0)
                let progress = CGFloat(currentFrame) / CGFloat(totalFrames)
                
                // Linear interpolation for smooth brightness change
                UIScreen.main.brightness = initialBrightness + brightnessChange * progress
                
                currentFrame += 1
            }
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { barcodeItems[$0] }.forEach(moc.delete)
            try? moc.save()
        }
    }
    
}
extension View{
    func stacked(at position: Int, in total: Int, peek: CGFloat = 60) -> some View {
//        let offset = CGFloat(total - position - 1) * peek
//        return self.offset(y: offset)
        let offset = CGFloat(position) * peek
        return self.offset(y: offset)
    }
}


#Preview {
    HomeView()
    
}
