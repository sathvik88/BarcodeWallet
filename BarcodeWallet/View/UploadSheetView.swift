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
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "xmark")
                    .padding(.bottom)
                    .bold()
                Spacer()
            }
            Button{
                toggleCamera = true
            }label: {
                Text("Open Camera")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .padding([.bottom])
            
            Button{
                toggleGallery = true
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
                .onDisappear(){
                    toggleUpload = false
                }
        })
        .sheet(isPresented: $toggleGallery, content: {
            UploadView(toggleSheet: $toggleGallery)
                .onDisappear(){
                    toggleUpload = false
                }
        })
    }
}

#Preview {
    UploadSheetView(toggleUpload: .constant(false), scanResult: .constant(""), barcodeType: .constant(""))
}
