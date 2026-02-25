//
//  ATTConsent.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 2/25/26.
//

import Foundation
import AppTrackingTransparency
import AdSupport

enum ATTAuthorization{
    static func requestIfNeeded(){
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            ATTrackingManager.requestTrackingAuthorization(){
                _ in 
            }
        }
    }
}
