//
//  ScanBarcodeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI
struct CameraView: View{
    @Binding var toggleCamera: Bool
    @Binding var scanResult: String
    @Binding var barcodeType: String
    @State private var displayCard = false
    @State private var isLoading = false
    let impactMed = UIImpactFeedbackGenerator(style: .rigid)
    var body: some View{
        NavigationStack{
            ZStack(alignment: .center) {
                BarcodeScanner(isLoading: $isLoading, result: $scanResult, barcodeType: $barcodeType)

                // Custom viewfinder
                ZStack {
                    // Dimmed overlay outside the scan window
                    Color.black.opacity(0.45)
                        .mask(
                            Rectangle()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 260, height: 260)
                                        .blendMode(.destinationOut)
                                )
                                .compositingGroup()
                        )

                    // Corner brackets
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.clear, lineWidth: 0)
                        .frame(width: 260, height: 260)
                        .overlay(
                            CornerBrackets()
                                .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 260, height: 260)
                        )
                }

                if isLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .frame(width: 60, height: 60)
                        ProgressView()
                            .tint(.white)
                    }
                }
            }
            .ignoresSafeArea()
            
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

struct CornerBrackets: Shape {
    var cornerLength: CGFloat = 24
    var cornerRadius: CGFloat = 20

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = cornerRadius
        let l = cornerLength

        // Top-left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + r + l))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        path.addArc(center: CGPoint(x: rect.minX + r, y: rect.minY + r),
                    radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + r + l, y: rect.minY))

        // Top-right
        path.move(to: CGPoint(x: rect.maxX - r - l, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - r, y: rect.minY + r),
                    radius: r, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + r + l))

        // Bottom-right
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - r - l))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))
        path.addArc(center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
                    radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - r - l, y: rect.maxY))

        // Bottom-left
        path.move(to: CGPoint(x: rect.minX + r + l, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
                    radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - r - l))

        return path
    }
}



#Preview {
    CameraView(toggleCamera: .constant(false), scanResult: .constant(""), barcodeType: .constant(""))
}
