//
//  CreateBarcodeView.swift
//  BarcodeWallet
//
//  Created by Sathvik Konuganti on 12/17/24.
//

import SwiftUI
import RSBarcodes_Swift
import AVFoundation
import UserNotifications
struct CreateBarcodeView: View {
    @Binding var barcodeType: String
    @Binding var barcodeData: String
    var barcodeGenerator = BarcodeGenModel()
    @Binding var dismiss: Bool
    @State private var title = ""
    @FocusState private var showKeyboard
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var expenses: FetchedResults<BarcodeData>
    @Binding var isLoading: Bool
    @State private var selectedColor = Color(.sRGB, red: 1, green: 1, blue: 1)
    @State private var isCoupon = false
    @State private var expirationDate = Date()
    @Environment(\.self) var environmentValues
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {

                    // MARK: - Barcode Card Preview
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(selectedColor)
                            .shadow(color: selectedColor.opacity(0.4), radius: 12, x: 0, y: 6)

                        VStack(alignment: .leading, spacing: 12) {
                            Text(title.isEmpty ? "Card Name" : title)
                                .font(.system(.subheadline, design: .monospaced, weight: .bold))
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            // Barcode rendering
                            Group {
                                switch barcodeType {
                                case "org.iso.Code128", "VNBarcodeSymbologyCode128":
                                    Code128(barcodeData: barcodeData)

                                case "Codabar", "VNBarcodeSymbologyCodabar":
                                    CodabarView(text: .constant(barcodeData))
                                        .frame(height: 100)

                                case "org.iso.Code39", "VNBarcodeSymbologyCode39":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue) {
                                        Code39(barcodeData: barcodeData, image: image)
                                    }

                                case "com.intermec.Code93", "VNBarcodeSymbologyCode93":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue) {
                                        Code39(barcodeData: barcodeData, image: image)
                                    }

                                case "VNBarcodeSymbologyEAN8", "org.gs1.EAN-8":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue) {
                                        En8(barcodeData: barcodeData, image: image)
                                    }

                                case "VNBarcodeSymbologyEAN13", "org.gs1.EAN-13":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue) {
                                        En13(barcodeData: barcodeData, image: image)
                                    }

                                case "org.iso.PDF417", "VNBarcodeSymbologyPDF417":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.pdf417.rawValue) {
                                        Pdf417(barcodeData: barcodeData, image: image)
                                    }

                                case "org.ansi.Interleaved2of5":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.interleaved2of5.rawValue) {
                                        Interleaved2of5(barcodeData: barcodeData, image: image)
                                    }

                                case "VNBarcodeSymbologyITF14", "org.gs1.ITF14":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue) {
                                        ITF14(barcodeData: barcodeData, image: image)
                                    }

                                case "org.iso.Aztec", "VNBarcodeSymbologyAztec":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.aztec.rawValue) {
                                        Aztec(image: image)
                                    }

                                case "org.iso.QRCode", "VNBarcodeSymbologyQR":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.qr.rawValue) {
                                        QRcode(image: image)
                                    }

                                case "org.gs1.UPC-E", "VNBarcodeSymbologyUPCE":
                                    if let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeData, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue) {
                                        Upce(barcodeData: barcodeData, image: image)
                                    }

                                default:
                                    Label("Unsupported barcode format", systemImage: "exclamationmark.triangle")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(16)
                    }
                    .frame(maxHeight: 260)
                    .padding(.horizontal)

                    // MARK: - Settings Form
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
                                TextField("e.g. Starbucks Rewards", text: $title)
                                    .focused($showKeyboard)
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
                            Toggle("Is this is a coupon?", isOn: $isCoupon.animation())
                        }
                        .padding(14)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))

                        // Expiration date (conditional)
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
                    .animation(.spring(duration: 0.3), value: isCoupon)
                }
                .padding(.vertical, 20)
            }

            // MARK: - Save Button
            Divider()
            Button {
                let barcodeDataController = BarcodeData(context: moc)
                let pickedColor = UIColor(selectedColor)
                barcodeDataController.id = UUID()
                barcodeDataController.name = title
                barcodeDataController.barcodeNumber = barcodeData
                barcodeDataController.barcodeType = barcodeType
                barcodeDataController.red = Float(pickedColor.components.red)
                barcodeDataController.green = Float(pickedColor.components.green)
                barcodeDataController.blue = Float(pickedColor.components.blue)
                barcodeDataController.alpha = Float(pickedColor.components.alpha)
                if isCoupon {
                    barcodeDataController.expirationDate = expirationDate
                    let content = UNMutableNotificationContent()
                    content.title = "Coupon Expiring"
                    content.subtitle = "\(title) is set to expire today"
                    content.sound = UNNotificationSound.default
                    var components = Calendar.current.dateComponents([.year, .month, .day], from: expirationDate)
                    components.hour = 9
                    components.minute = 0
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    let request = UNNotificationRequest(identifier: barcodeDataController.id?.uuidString ?? UUID().uuidString, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                }
                try? moc.save()
                dismiss.toggle()
            } label: {
                Text("Save Card")
                    .font(.system(.body, weight: .semibold))
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .disabled(title.isEmpty)
        }
        .padding([.leading, .trailing, .top])
        .onAppear(){
            isLoading = false
        }
        .onChange(of: isCoupon, { _, newValue in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ success, error in
                if success{
                    print("All set!")
                }else if let error{
                    print(error.localizedDescription)
                }
                
                
            }
        })
        .navigationBarBackButtonHidden()
    }
}
extension Color {
        var rgba: (red: Double, green: Double, blue: Double, alpha: Double)? {
            guard let components = UIColor(self).cgColor.components else { return nil }
            return (red: Double(components[0]), green: Double(components[1]), blue: Double(components[2]), alpha: Double(components[3]))
        }
    }

#Preview {
    CreateBarcodeView(barcodeType: .constant("org.gs1.EAN-13"), barcodeData: .constant("0009800125104"), dismiss: .constant(false), isLoading: .constant(false))
}
