//
//  UpdateCardView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 11/24/25.
//

import SwiftUI

struct UpdateCardView: View {
    let cardId: UUID?
    @Binding var red: Float
    @Binding var green: Float
    @Binding var blue: Float
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
                    let pickedColor = UIColor(selectedColor)
                    for i in barcodeItems{
                        guard let cardId = cardId else {return}
                        if cardId == i.id{
                            if updatedCardName != ""{
                                i.name = updatedCardName
                            }
                            if i.alpha != Float(pickedColor.components.alpha) || i.red != Float(pickedColor.components.red) || i.blue != Float(pickedColor.components.blue) || i.green != Float(pickedColor.components.blue){
                                i.alpha = Float(pickedColor.components.alpha)
                                i.red = Float(pickedColor.components.red)
                                i.blue = Float(pickedColor.components.blue)
                                i.green = Float(pickedColor.components.green)
                                red = Float(pickedColor.components.red)
                                blue = Float(pickedColor.components.blue)
                                green = Float(pickedColor.components.green)
                                selectedColor = Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue))
                                try? moc.save()
                                
                            }else{
                                print("Color not updated")
                            }
                            
                        }
                    }
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
            
            .onAppear(){
                selectedColor = Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue))
            }
        
        }
        
    }
}

#Preview {
    UpdateCardView(cardId: UUID(), red: .constant(1), green: .constant(1), blue: .constant(1), isPresented: .constant(false))
}
