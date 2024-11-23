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
        .sheet(isPresented: $toggleCamera, content: {
            CameraView(toggleCamera: $toggleCamera, barcodes: $barcodes)
        })
        
    }
}

struct CameraView: View{
    @Binding var toggleCamera: Bool
    @State private var scanResult = "No Barcode detected"
    @Binding var barcodes: [String]
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    var body: some View{
        ZStack(alignment: .bottom){
            BarcodeScanner(result: $scanResult)
            Text(scanResult)
                .padding()
                .background(.black)
                .foregroundStyle(.white)
                .padding(.bottom)
        }
        .onChange(of: scanResult, perform: { value in
            barcodes.append(scanResult)
            impactMed.impactOccurred()
            toggleCamera = false
        })
        
    }
}

#Preview {
    ScanBarcodeView()
}
