//
//  ContentView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/19/24.
//

import SwiftUI

struct LinearBarcodeView: View {
    @State private var inputText = ""
    var barcodeGen = BarcodeGenModel()
    @State private var selectedTab = 0
    var body: some View {
        
        VStack {
            Picker("", selection: $selectedTab){
                Text("Manual Input").tag(0)
                Text("Scan").tag(1)
                
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TabView(selection: $selectedTab,
                    content:  {
                ManualBarcodeView(inputText: $inputText, title: "Sathvik's Library Card")
                .tag(0)
                
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeIn, value: selectedTab)
            
        }
        .padding()
    }
    
    
}



#Preview {
    LinearBarcodeView()
}
