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
    @State private var cards = [BarcodeModel(name: "Emagine", barcodeNumber: "11220000103692", barcodeType: "org.iso.Code128")]
    @State private var isCardPresented = false
    @State private var walletHeight = 250.0
    @State private var defaultHeight = 0.0
    @State private var cardCount = 0
    @State private var displayOption = false
    @State private var displayUploadCard = false
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
                    ScrollView{
                        VStack{
                            ZStack{
                                ForEach(cards){ card in
                                    BarcodeCard(barcodeType: card.barcodeType, barcodeName: card.name, barcodeNum: card.barcodeNumber)
                                        
                                        .offset(offset(for: card))
                                        .zIndex(zIndex(for: card))
                                        .id(isCardPresented)
                                        .transition(AnyTransition.push(from: .bottom).combined(with: .opacity))
                                        .animation(self.transitionAnimation(for: card), value: isCardPresented)
                                        .gesture(
                                            TapGesture()
                                                
                                                .onEnded({ _ in
                                                    withAnimation(.bouncy(duration: 0.25).delay(0.05)) {
                                                        
                                                        isCardPressed.toggle()
                                                        selectedCard = isCardPressed ? card : nil
                                                        
                                                    }
                                                })
                                                .exclusively(before: LongPressGesture(minimumDuration: 0.05)
                                                    .sequenced(before: DragGesture())
                                                    .updating($dragState, body: { (value, state, transaction) in
                                                        switch value {
                                                        case .first(true):
                                                            state = .pressing(index: index(for: card))
                                                        case .second(true, let drag):
                                                            withAnimation{
                                                                state = .dragging(index: index(for: card), translation: drag?.translation ?? .zero)
                                                            }
                                                            
                                                        default:
                                                            break
                                                        }
                                                        
                                                    })
                                                        .onEnded({ (value) in
                                                            
                                                            guard case .second(true, let drag?) = value else {
                                                                return
                                                            }
                                                            
                                                            // Rearrange the cards
                                                            withAnimation {
                                                                self.rearrangeCards(with: card, dragOffset: drag.translation)
                                                            }
                                                        })
                                                             
                                                )
                                        )
                                }
                            }
                            .offset(y: CGFloat(isCardPressed ? defaultHeight : walletHeight))
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
                for i in 0...cards.count{
                    if i > 4{
                        walletHeight += 16.67
                    }
                }
                
                
                isLoading.toggle()
                
            }
            
            .onChange(of: barcodeItems.count, perform: { value in
                cards = []
                
                for i in barcodeItems{
                    cards.append(BarcodeModel(name: i.name ?? "", barcodeNumber: i.barcodeNumber ?? "", barcodeType: i.barcodeType ?? ""))
                }
                
               
                
            })
            .onChange(of: cards.count, perform: { newValue in
                if cardCount > 0 && newValue > cardCount{
                    walletHeight += 16.67
                }else if cardCount > 0 && newValue < cardCount{
                    walletHeight -= 16.67
                }
                cardCount = cards.count
                
            })
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
                    .presentationDetents([.height(150)])
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
    private func zIndex(for card: BarcodeModel) -> Double {
        guard let cardIndex = index(for: card) else {
            return 0.0
        }
        
        // The default z-index of a card is set to a negative value of the card's index,
        // so that the first card will have the largest z-index.
        let defaultZIndex = -Double(cardIndex)
        
        // If it's the dragging card
        if let draggingIndex = dragState.index,
            cardIndex == draggingIndex {
            // we compute the new z-index based on the translation's height
            return defaultZIndex + Double(dragState.translation.height/Self.cardOffset)
        }
        
        // Otherwise, we return the default z-index
        return defaultZIndex
    }

    private func index(for card: BarcodeModel) -> Int? {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else {
            return nil
        }
        
        return index
    }
    
    private func offset(for card: BarcodeModel) -> CGSize {

        guard let cardIndex = index(for: card) else {
            return CGSize()
        }
        
        if isCardPressed {
            guard let selectedCard = self.selectedCard,
                let selectedCardIndex = index(for: selectedCard) else {
                    return .zero
            }
            
            if cardIndex >= selectedCardIndex {
                return .zero
            }
            
            let offset = CGSize(width: 0, height: 1200)
            
            return offset
        }
        
        // Handle dragging
        
        var pressedOffset = CGSize.zero
        var dragOffsetY: CGFloat = 0.0
        
        if let draggingIndex = dragState.index,
            cardIndex == draggingIndex {
            pressedOffset.height = dragState.isPressing ? -20 : 0
            
            switch dragState.translation.width {
            case let width where width < -10:
                withAnimation{
                    pressedOffset.width = -20
                }
                
            case let width where width > 10:
                withAnimation{
                    pressedOffset.width = 20
                }
            default: break
            }

            dragOffsetY = dragState.translation.height
        }
        
        return CGSize(width: 0 + pressedOffset.width, height: -50 * CGFloat(cardIndex) + pressedOffset.height + dragOffsetY)
    }
    
    private func transitionAnimation(for card: BarcodeModel) -> Animation {
        var delay = 0.0
        
        if let index = index(for: card) {
            delay = Double(cards.count - index) * 0.1
        }
        
        return Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.02).delay(delay)
    }
    
    private func rearrangeCards(with card: BarcodeModel, dragOffset: CGSize) {
        guard let draggingCardIndex = index(for: card) else {
            return
        }
        
        var newIndex = draggingCardIndex + Int(-dragOffset.height / Self.cardOffset)
        newIndex = newIndex >= cards.count ? cards.count - 1 : newIndex
        newIndex = newIndex < 0 ? 0 : newIndex
        
        let removedCard = cards.remove(at: draggingCardIndex)
        cards.insert(removedCard, at: newIndex)
        
        
    }
}


#Preview {
    HomeView()
      
}
