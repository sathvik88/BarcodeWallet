//
//  BannerAdView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 2/25/26.
//

import SwiftUI
import GoogleMobileAds
struct BannerAdView: UIViewRepresentable {
    let adUnitID: String = "ca-app-pub-3940256099942544/2934735716"
    let width: CGFloat
    
    func makeUIView(context: Context) -> BannerView {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        let banner = BannerView(adSize: adSize)
        
        banner.adUnitID = adUnitID
        banner.delegate = context.coordinator
        banner.rootViewController = UIApplication.shared.firstKeyWindowRootViewController()
        banner.load(Request())
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        let newSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        
        if !CGSizeEqualToSize(newSize.size, uiView.adSize.size){
            uiView.adSize = newSize
            uiView.load(Request())
        }
    }
    
    //Handles bridge between UIKit and SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator: NSObject, BannerViewDelegate{
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("Banner Loaded")
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: any Error) {
            print("Banner Failed \(error.localizedDescription)")
        }
    }
}

private extension UIApplication{
    func firstKeyWindowRootViewController() -> UIViewController? {
        connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController
    }
}

private extension UIWindowScene{
    var keyWindow: UIWindow? {windows.first(where: {$0.isKeyWindow})}
}
