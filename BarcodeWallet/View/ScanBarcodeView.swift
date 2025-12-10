//
//  ScanBarcodeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI
struct CornerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY+20))
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX+20, y: rect.minY))
        //        path.addLine(to: CGPoint(x: rect.midX-20, y: rect.minY+8))
        //        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY-15))
        //        path.addLine(to: CGPoint(x: rect.midX+20, y: rect.minY+8))
        //        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
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
                Image(systemName: "viewfinder")
                    .resizable()
                    .frame(width: 300, height: 300)
                if isLoading{
                    ProgressView()
                }else{
                    
//                    VStack{
//                        HStack{
//                            ZStack{
//                                
//                                CornerShape()
//                                    .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                                
//                                CornerShape()
//                                    .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                                    .rotationEffect(.degrees(90), anchor: .center)
//                                
//                                
//                                CornerShape()
//                                    .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                                    .rotationEffect(.degrees(-90), anchor: .center)
//                                
//                                CornerShape()
//                                    .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                                    .rotationEffect(.degrees(180), anchor: .center)
//                                
//                                
//                            }
//                            .frame(width: 300, height: 200)
//                            
//                        }
//                        
//                    }
                    
                    
                }
            }
            
            .onChange(of: scanResult, perform: { value in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    impactMed.impactOccurred()
                    displayCard = true
                }
            })
            .navigationDestination(isPresented: $displayCard, destination: { CreateBarcodeView(barcodeType: $barcodeType, barcodeData: $scanResult, dismiss: $toggleCamera, isLoading: $isLoading)})
        }
 
    }
    
}



#Preview {
    CameraView(toggleCamera: .constant(false), scanResult: .constant(""), barcodeType: .constant(""))
}
