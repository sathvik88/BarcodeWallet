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
    @State private var expirationDate = Date()
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 12) {

                        // Name
                        HStack(spacing: 12) {
                            Image(systemName: "creditcard.fill")
                                .foregroundStyle(.blue)
                                .frame(width: 24)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Card Name")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                TextField("Updated card name", text: $updatedCardName)
                            }
                        }
                        .padding(14)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))

                        // Color
                        HStack(spacing: 12) {
                            Image(systemName: "paintpalette.fill")
                                .foregroundStyle(.purple)
                                .frame(width: 24)
                            ColorPicker("Card Color", selection: $selectedColor)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))

                        // Coupon toggle
                        HStack(spacing: 12) {
                            Image(systemName: "tag.fill")
                                .foregroundStyle(.orange)
                                .frame(width: 24)
                            Toggle("Is this a coupon?", isOn: $isCoupon.animation())
                        }
                        .padding(14)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                        if isCoupon {
                            HStack(spacing: 12) {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundStyle(.red)
                                    .frame(width: 24)
                                DatePicker(
                                    "Expiration Date",
                                    selection: $expirationDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                            }
                            .padding(14)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }

                // MARK: - Save Button
                Divider()
                Button {
                    let pickedColor = UIColor(selectedColor)
                    for i in barcodeItems {
                        guard let cardId else { return }
                        if cardId == i.id {
                            if !updatedCardName.isEmpty {
                                i.name = updatedCardName
                            }
                            if i.alpha != Float(pickedColor.components.alpha) ||
                               i.red   != Float(pickedColor.components.red)   ||
                               i.blue  != Float(pickedColor.components.blue)  ||
                               i.green != Float(pickedColor.components.green) {
                                i.alpha = Float(pickedColor.components.alpha)
                                i.red   = Float(pickedColor.components.red)
                                i.blue  = Float(pickedColor.components.blue)
                                i.green = Float(pickedColor.components.green)
                                red   = Float(pickedColor.components.red)
                                blue  = Float(pickedColor.components.blue)
                                green = Float(pickedColor.components.green)
                                selectedColor = Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue))
                                try? moc.save()
                            }
                            if isCoupon {
                                i.expirationDate = expirationDate
                                let content = UNMutableNotificationContent()
                                content.title = "Coupon Expiring"
                                content.subtitle = "\(i.name) is set to expire today"
                                content.sound = UNNotificationSound.default
                                var components = Calendar.current.dateComponents([.year, .month, .day], from: expirationDate)
                                components.hour = 9
                                components.minute = 0
                                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                                let request = UNNotificationRequest(identifier: i.id?.uuidString ?? UUID().uuidString, content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request)
                            }
                            
                        }
                    }
                    isPresented = false
                } label: {
                    Text("Save Changes")
                        .font(.system(.body, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Update Card")
                        .bold()
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .bold()
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
