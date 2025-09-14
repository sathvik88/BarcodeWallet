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
    @State private var deviceBrightness = 0.5
    @State private var isLoading = false
    @GestureState private var dragState = DragState.inactive
    @State var selectedCard: BarcodeModel?
    @State var isCardPressed = false
    private static let cardOffset: CGFloat = 50.0
    @State private var cards: [BarcodeModel] = []
    @State private var isCardPresented = false
    //    @State private var walletHeight = 250.0
    @State private var defaultHeight = 0.0
    @State private var cardCount = 0
    @State private var displayOption = false
    @State private var displayUploadCard = false
    @Namespace private var namespace
    var body: some View {
        NavigationStack{
            VStack{
                if barcodeItems.isEmpty{
                    VStack{
                        GroupBox{
                            Text("Click the '+' icon to add a new barcode")
                                .font(.system(.body, design: .monospaced))
                                .onTapGesture {
                                    
                                }
                        }
                    }
                    
                }else{
                

                    ScrollView {
                        VStack{
                            ZStack {
                                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                                    NavigationLink {
                                        CardDetailView(
                                            cardId: card.id,
                                            barcodeType: card.barcodeType,
                                            barcodeName: card.name,
                                            barcodeNumber: card.barcodeNumber
                                        )
                                        .navigationTransition(.zoom(sourceID: card.id, in: namespace))
                                    } label: {
                                        BarcodeCard(
                                            barcodeType: card.barcodeType,
                                            barcodeName: card.name,
                                            barcodeNum: card.barcodeNumber
                                        )
    //                                    .frame(height: 200) // Adjust height as needed
                                        .offset(y: CGFloat(index) * 30) // Controls stacking depth
                                    }
                                    
                                    .buttonStyle(.plain)
                                    .matchedTransitionSource(id: card.id, in: namespace)
                                }
                            }
                            
                        }

                        
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
                    cards.append(BarcodeModel(name: i.name ?? "", barcodeNumber: i.barcodeNumber ?? "", barcodeType: i.barcodeType ?? ""))
                    
                }
                
                isLoading.toggle()
                withAnimation {
                    adjustBrightness(to: deviceBrightness, duration: 0.01)
                }
                
            }
            
            .onChange(of: barcodeItems.count, perform: { value in
                cards = []
                
                for i in barcodeItems{
                    cards.append(BarcodeModel(name: i.name ?? "", barcodeNumber: i.barcodeNumber ?? "", barcodeType: i.barcodeType ?? ""))
                }
                
                
                
            })
            //            .onChange(of: cards.count, perform: { newValue in
            //                if cardCount > 0 && newValue > cardCount{
            //                    walletHeight += 16.67
            //                }else if cardCount > 0 && newValue < cardCount{
            //                    walletHeight -= 16.67
            //                }
            //                cardCount = cards.count
            //
            //            })
            .onChange(of: isCardPressed, perform: { value in
                if value{
                    deviceBrightness = UIScreen.main.brightness
                    withAnimation {
                        UIScreen.main.brightness = 1.0
                    }
                }else{
                    withAnimation {
                        adjustBrightness(to: deviceBrightness, duration: 0.01)
                    }
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
                    BarcodeCard(barcodeType: barcodeType, barcodeName: barcodeName, barcodeNum: scanResult)
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
                    BarcodeCard(barcodeType: barcodeType, barcodeName: barcodeName, barcodeNum: scanResult)
                    
                }
            })
            
            
            
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
    func stacked(at position: Int, in total: Int) -> some View {
            let offset = Double(total - position)
            return self.offset(y: offset * 10)
        }
}


#Preview {
    HomeView()
    
}
