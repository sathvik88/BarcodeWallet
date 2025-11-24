//
//  UpdateCardView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/25.
//

import SwiftUI

struct UpdateCardView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) private var barcodeItems: FetchedResults<BarcodeData>
    @Binding var isPresented: Bool
    @State private var updatedCardName: String = ""
    @State private var selectedColor = Color(.sRGB, red: 1, green: 1, blue: 1)
    @State private var isCoupon = false
    var body: some View {
        NavigationStack{
            VStack{
                GroupBox{
                    HStack{
                        Text("Card Name")
                            .bold()
                            
                        TextField("Updated card name", text: $updatedCardName)
                            .padding()
                            
                    }
                    
                }
                GroupBox{
                    ColorPicker("Choose a Color", selection: $selectedColor)
                        
                }
                GroupBox{
                    HStack{
                        Toggle("Is this a coupon?", isOn: $isCoupon)
                    }
                }
                Spacer()
                Button{
                    
                    isPresented = false
                }label: {
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10.0)
                            .frame(height: 45)
                        Text("Save")
                            .foregroundStyle(Color.white)
                            .bold()
                    }
                    
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Update Card")
                        .bold()
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "xmark")
                        .bold()
                        .onTapGesture {
                            isPresented = false
                        }
                }
                
            }
        
        }
        
    }
}

#Preview {
    UpdateCardView(isPresented: .constant(false))
}
