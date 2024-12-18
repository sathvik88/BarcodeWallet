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
    var body: some View {
        NavigationStack{
            ZStack{
                if isLoading{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundStyle(Color.red)
                        .scaleEffect(CGSize(width: 2.0, height: 2.0))
                }
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
                        List{
                            ForEach(barcodeItems){ card in
                                ZStack{
                                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(Color.white)
                                        .shadow(radius: 10)
                                    Text(card.name ?? "Card")
                                        .font(.system(.headline, design: .monospaced))
                                        .bold()
                                        .foregroundStyle(Color.blue)
                                }
                                .frame(minHeight: 50, maxHeight: 50)
                                .onTapGesture {
                                    isLoading = true
                                    print(isLoading)
                                    DispatchQueue.global(qos: .userInitiated).async{
                                        let result = card.barcodeNumber ?? ""
                                        let type = card.barcodeType ?? ""
                                        let name = card.name ?? "Default"
                                        DispatchQueue.main.async{
                                            scanResult = result
                                            barcodeType = type
                                            barcodeName = name
                                            isLoading = false
                                            displayCard = true
                                            
                                        }
                                        
                                    }
                                    print(displayCard)
                                    
                                    
                                }

                            }
                            
                            .onDelete(perform: { indexSet in
                                deleteItems(offsets: indexSet)
                            })
                            
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
                        displayCamera.toggle()
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $displayCamera, content: {
                CameraView(toggleCamera: $displayCamera, scanResult: $scanResult, barcodeType: $barcodeType)
                    
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


#Preview {
    HomeView()
      
}
