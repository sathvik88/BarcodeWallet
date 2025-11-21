//
//  Extensions.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/25.
//

import Foundation
import UIKit
extension UIColor{
    var coreImageColor: CIColor{
        return CIColor(color: self)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat){
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}
