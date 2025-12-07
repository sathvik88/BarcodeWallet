//
//  BrightnessOverlay.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/7/25.
//

import SwiftUI

struct BrightnessOverlay: View {
    var brightness: CGFloat   // 0 = dark, 1 = normal
        var body: some View {
            Color.black
                .opacity(1.0 - brightness)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
}

#Preview {
    BrightnessOverlay(brightness: 1.0)
}
