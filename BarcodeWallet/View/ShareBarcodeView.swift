//
//  ShareBarcodeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/4/25.
//

import SwiftUI

struct ShareBarcodeView<barcodeCard: View>: View{
    @ViewBuilder let cardView: barcodeCard
    init(
        barcodeCard: barcodeCard
    ) {
        self.cardView = barcodeCard
    }
    var body: some View {
//        HStack{
//            if let iconFileName = Bundle.main.iconFileName,
//               let uiImage = UIImage(named: iconFileName) {
//                Image(uiImage: uiImage)
////                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .cornerRadius(10)
//            } else {
//                // Fallback or placeholder if the icon cannot be loaded
//                Image(systemName: "app.fill") // Example system icon
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            }
//            Text("Barcode Wallet")
//                .font(.headline)
//        }
        ZStack{

            cardView
            HStack{
                if let iconFileName = Bundle.main.iconFileName,
                   let uiImage = UIImage(named: iconFileName) {
                    Image(uiImage: uiImage)
                    //                    .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .opacity(0.5)
                } else {
                    // Fallback or placeholder if the icon cannot be loaded
                    Image(systemName: "app.fill") // Example system icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Text("Barcode Wallet")
                    .bold()
                    .opacity(0.5)
                    .font(.largeTitle)
                    .foregroundStyle(Color.gray)
            }
            .padding(.bottom, 30)
            
        }
        
        
    }
}
extension Bundle {
        var iconFileName: String? {
            guard let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
                  let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
                  let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
                  let iconFileName = iconFiles.last else { return nil }
            return iconFileName
        }
    }

#Preview {
    ShareBarcodeView(barcodeCard: EmptyView())
}
