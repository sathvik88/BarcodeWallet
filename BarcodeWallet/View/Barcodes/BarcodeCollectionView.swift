//
//  Code128.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/25.
//

import SwiftUI
import RSBarcodes_Swift
struct Code128: View {
    let barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    var body: some View {
        VStack{
            barcodeGenerator.generateCode128Barcode(text: barcodeData)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .scaledToFit()
            Text(barcodeData)
                .foregroundStyle(Color.black)
                .font(.footnote)
            
        }
        .frame(width: 200, height: 100)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 200, height: 100)
                .foregroundStyle(Color.white)
                
        }
    }
}

struct Code39: View {
    let barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .scaledToFit()
                
            Text(barcodeData)
                .font(.footnote)
                .foregroundStyle(Color.black)
        }
        .frame(minWidth: 200, maxWidth: 300,minHeight: 80,maxHeight: 80)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.white)
                .padding(.bottom)
        }
    }
}

struct En8: View {
    let barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .scaledToFit()
                
            Text(barcodeData)
                .font(.footnote)
                .foregroundStyle(Color.black)
        }
        .frame(width: 200,height: 80)
        .padding()
    }
}

struct En13: View {
    let barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .scaledToFit()
                
            Text(barcodeData)
                .font(.footnote)
                .foregroundStyle(Color.black)
        }
        .frame(width: 200,height: 80)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.white)
                .padding(.bottom)
        }
    }
}

struct Pdf417: View {
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .scaledToFit()
               
            
        }
        .frame(width: 200,height: 80)
        .padding()
        .padding(.bottom)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.white)
        }
    }
}


struct Interleaved2of5: View {
    let barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .scaledToFit()
            Text(barcodeData)
                .font(.footnote)
                .foregroundStyle(Color.black)
        }
        .frame(width: 220,height: 120)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.white)
        }
    }
}

struct ITF14: View {
    let barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .scaledToFit()
                .frame(width: 200,height: 80)
            Text(barcodeData)
                .font(.footnote)
                .foregroundStyle(Color.black)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 220,height: 120)
                .foregroundStyle(Color.white)
                .padding(.bottom)
        }
    }
}

struct Upce: View {
    let barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .scaledToFit()
                .frame(width: 200,height: 80)
            Text(barcodeData)
                .font(.footnote)
                .foregroundStyle(Color.black)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.white)
                .frame(width: 180,height: 120)
                .padding(.bottom)
        }
    }
}

struct QRcode: View {
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            if let scaledImg = RSAbstractCodeGenerator.resizeImage(image, scale: CGFloat(12)){
                Image(uiImage: scaledImg)
            }
        }
        .frame(width: 100,height: 100)
        .padding()
        .padding(.bottom)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.white)
                .frame(width: 150,height: 150)
                .padding(.bottom)
        }
    }
}

struct Aztec: View {
    var barcodeGenerator = BarcodeGenModel()
    let image: UIImage
    var body: some View {
        VStack{
            if let scaledImg = RSAbstractCodeGenerator.resizeImage(image, scale: CGFloat(20)){
                Image(uiImage: scaledImg)
                    .cornerRadius(10)
            }
        }
        
        .frame(width: 100,height: 100)
        .padding()
        .padding(.bottom)
    }
}

#Preview {
    Code128(barcodeData: "ABC-abc-1234")
}
