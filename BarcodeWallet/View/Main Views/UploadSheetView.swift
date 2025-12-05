//
//  UploadSheetView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 1/1/25.
//

import SwiftUI

struct UploadSheetView: View {
    @Binding var toggleUpload: Bool
    @State private var toggleCamera = false
    @State private var toggleGallery = false
    @Binding var scanResult: String
    @Binding var barcodeType: String
    @Binding var displayCard: Bool
    @State private var toggleLoader = false
    var body: some View {
        NavigationStack{
            VStack{
                
                Button{
                    DispatchQueue.main.async{
                        toggleLoader = true
                        toggleCamera = true
                    }
                    
                }label: {
                    Text("Open Camera")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding([.bottom])
                
                Button{
                    DispatchQueue.main.async{
                        toggleLoader = true
                        toggleGallery = true
                    }
                }label: {
                    Text("Upload From Gallery")
                        .frame(maxWidth: .infinity)
                        
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                
                
            }
            .padding([.leading, .trailing])
            .sheet(isPresented: $toggleCamera, content: {
                CameraView(toggleCamera: $toggleCamera, scanResult: $scanResult, barcodeType: $barcodeType)
                    .onAppear(){
                        toggleLoader = false
                    }
                    .onDisappear(){
                        toggleUpload = false
                    }
            })
            .sheet(isPresented: $toggleGallery, content: {
                BarcodeScannerView(detectedSymbology: $barcodeType, detectedPayload: $scanResult, displayImageSheet: $toggleGallery)
                    .onAppear(){
                        toggleLoader = false
                    }
                    .onDisappear(){
                        toggleUpload =  false
                        if !scanResult.isEmpty{
                            displayCard = true
                        }
                        
                    }
                    
            })
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "xmark")
                        .padding(.bottom)
                        .bold()
                        .onTapGesture {
                            toggleUpload = false
                        }
                }
            }
            .overlay{
                if toggleLoader{
                    ProgressView()
                }
            }
        }
        
        
    }
}

#Preview {
    UploadSheetView(toggleUpload: .constant(false), scanResult: .constant(""), barcodeType: .constant(""), displayCard: .constant(false))
}
