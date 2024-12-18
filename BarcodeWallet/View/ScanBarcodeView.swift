//
//  ScanBarcodeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI

struct ScanBarcodeView: View {
    @State private var toggleCamera = false
    @State private var toggleGallery = false
    @State private var scanResult = "No Barcode detected"
    @State private var barcodes = [""]
    var body: some View {
        NavigationStack{
            VStack{
                HStack(spacing: 70){
                    VStack{
                        Button{
                            
                        }label: {
                            
                            Image(systemName: "photo.artframe")
                                .font(.system(size: 50))
                        }
                        .padding(10)
                        Text("Open Gallery")
                            .bold()
                    }
                    VStack{
                        Button{
                            toggleCamera.toggle()
                        }label: {
                            
                            Image(systemName: "barcode.viewfinder")
                                .font(.system(size: 50))
                        }
                        .padding(10)
                        Text("Open Camera")
                            .bold()
                    }
                    
                }
                if !barcodes.isEmpty{
                    HStack{
                        ForEach(barcodes, id: \.self){ code in
                            Text(code)
                                .padding()
                        }
                    }
                    
                }
            }
        }
//        .sheet(isPresented: $toggleCamera, content: {
//            CameraView(toggleCamera: $toggleCamera, barcodes: $barcodes)
//        })
        
    }
}

struct CameraView: View{
    @Binding var toggleCamera: Bool
    @Binding var scanResult: String
    @Binding var barcodeType: String
    @State private var displayCard = false
    @State private var isLoading = false
    let impactMed = UIImpactFeedbackGenerator(style: .rigid)
    var body: some View{
        NavigationStack{
            
            ZStack(alignment: .center){
                BarcodeScanner(isLoading: $isLoading, result: $scanResult, barcodeType: $barcodeType)
                if isLoading{
                    ProgressView()
                }else{
                    Image(systemName: "camera.metering.center.weighted.average")
                        .resizable()
                        .frame(width: 350, height: 300)
                        .foregroundStyle(.white)
                }
                
//                Text(scanResult)
//                    .padding()
//                    .background(.black)
//                    .foregroundStyle(.white)
//                    .padding(.bottom)
            }
            
            .onChange(of: scanResult, perform: { value in
                
                impactMed.impactOccurred()
                
//                toggleCamera = false
                displayCard = true
            })
            .navigationDestination(isPresented: $displayCard, destination: { CreateBarcodeView(barcodeType: $barcodeType, barcodeData: $scanResult, dismiss: $toggleCamera, isLoading: $isLoading)})
        }
        
        
        
    }
}

#Preview {
    ScanBarcodeView()
}
