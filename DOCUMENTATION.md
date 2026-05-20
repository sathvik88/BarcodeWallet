# BarcodeWallet — Developer Documentation

**Author:** Sathvik Konuganti  
**Platform:** iOS (SwiftUI)  
**Architecture:** MVVM + UIKit bridges

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture](#2-architecture)
3. [Project Structure](#3-project-structure)
4. [Source Files](#4-source-files)
5. [Data Layer](#5-data-layer)
6. [API & Service Integrations](#6-api--service-integrations)
7. [Third-Party Dependencies](#7-third-party-dependencies)
8. [Barcode Support](#8-barcode-support)
9. [Monetization & Ads](#9-monetization--ads)
10. [Permissions & Entitlements](#10-permissions--entitlements)
11. [Configuration](#11-configuration)

---

## 1. Project Overview

BarcodeWallet is a digital wallet app for iOS that lets users store, scan, create, and share barcodes. Each barcode is saved as a customizable card with a user-chosen color, name, and optional expiration date. Cards sync across devices via iCloud and can be exported to Apple Wallet as PKPasses.

**Key capabilities:**
- Create cards from 13 barcode formats
- Scan barcodes via camera or photo library
- Sync across devices with iCloud / CloudKit
- Export cards to Apple Wallet (Pro feature)
- Free tier with Google AdMob banner ads; Pro tier via RevenueCat subscription

---

## 2. Architecture

### Pattern: MVVM with UIKit bridges

| Layer | Responsibility |
|---|---|
| **Model** | Plain Swift structs/enums; Core Data entity (`BarcodeData`) |
| **ViewModel / Service** | Business logic, Core Data access, barcode generation, camera session |
| **View** | SwiftUI views; UIKit screens wrapped via `UIViewControllerRepresentable` |

### SwiftUI State Strategy

| Wrapper | Used for |
|---|---|
| `@State` | Local, ephemeral view state |
| `@Binding` | Parent-to-child data propagation |
| `@FetchRequest` | Live Core Data queries |
| `@StateObject` | Service instances owned by a view (`WalletService`) |
| `@Environment(\.managedObjectContext)` | Core Data context injection |

### UIKit Integration

Two UIKit view controllers are bridged into SwiftUI:
- `BarcodeScannerController` — live camera feed
- `UploadViewController` — photo library image picker

Both use `UIViewControllerRepresentable` and a `Coordinator` delegate pattern to return results to SwiftUI state.

---

## 3. Project Structure

```
BarcodeWallet/
├── BarcodeWallet/
│   ├── BarcodeWalletApp.swift          # App entry point
│   ├── Info.plist                      # App configuration & API keys
│   ├── BarcodeWallet.entitlements      # iCloud, Wallet, Push capabilities
│   ├── DataModel.xcdatamodeld/         # Core Data schema
│   ├── Model/                          # Data models & encoders
│   ├── ViewModel/                      # Business logic & controllers
│   ├── View/
│   │   ├── Main Views/                 # Primary screens
│   │   ├── Service/                    # App-level services (AppDelegate, ATT)
│   │   ├── Barcodes/                   # Barcode rendering components
│   │   └── viewComponents/             # Shared UI components
│   └── Services/                       # Swift extensions
├── BarcodeWalletTests/
└── BarcodeWalletUITests/
```

---

## 4. Source Files

### App Entry

#### `BarcodeWalletApp.swift`
App entry point (`@main`). On launch:
1. Configures `DataController` and injects its `viewContext` into the environment.
2. Initializes **Google Mobile Ads** SDK.
3. Configures **RevenueCat** with the production API key.
4. Presents `TabsView` as the root scene.

---

### Model

#### `BarcodeModel.swift`
A lightweight Swift `struct` representing an in-memory barcode card. Fields mirror the Core Data entity `BarcodeData` but are value types, used for passing data between views before persistence.

| Property | Type | Description |
|---|---|---|
| `id` | `UUID` | Unique identifier |
| `name` | `String` | User-assigned card name |
| `barcodeNumber` | `String` | Raw barcode value |
| `barcodeType` | `String` | Format string (e.g., `"QR Code"`) |
| `red/green/blue/alpha` | `Float` | Card background color components (0–1) |
| `expirationDate` | `Date?` | Optional coupon expiry |

#### `DragState.swift`
Enum used by `HomeView` to track card drag gesture state.

| Case | Description |
|---|---|
| `.inactive` | No gesture active |
| `.pressing` | Long-press detected, no movement |
| `.dragging(translation:)` | Active drag with offset |

#### `CDCodabarEncoder.swift`
Custom encoder for the Codabar barcode symbology, which is not natively supported by `CIFilter`. Converts a Codabar string into a binary bar/space sequence. Validates start/stop characters (A, B, C, D).

---

### ViewModel

#### `DataController.swift`
Manages the `NSPersistentCloudKitContainer` ("DataModel") for Core Data + CloudKit sync.

- Uses `NSMergeByPropertyObjectTrumpMergePolicy` so in-memory changes always win on conflict.
- Enables persistent history tracking (`NSPersistentHistoryTrackingKey`) required for CloudKit sync.
- `viewContext.automaticallyMergesChangesFromParent = true` keeps the UI context live.
- Provides a convenience `preview` static instance with an in-memory store for SwiftUI previews.

#### `BarcodeGenModel.swift`
Generates barcode `UIImage` objects using `CIFilter`.

| Method | Output |
|---|---|
| `generateCode128(from:)` | Code 128 linear barcode |
| `generateQRCode(from:)` | QR code |
| `generateAztec(from:)` | Aztec 2D code |

All three scale the `CIImage` output to a fixed pixel size before converting to `UIImage`.

#### `BarcodeScannerController.swift`
`UIViewController` that manages a live `AVCaptureSession` for real-time barcode detection. Supports 13 metadata object types. Draws a highlight rectangle overlay as barcodes are detected. Uses `Coordinator` as the `AVCaptureMetadataOutputObjectsDelegate`.

#### `Coordinator.swift`
`AVCaptureMetadataOutputObjectsDelegate` implementation. Extracts the string value from the first detected metadata object and passes it back to the SwiftUI view via a `@Binding`.

#### `UploadViewController.swift`
`UIViewController` that presents `UIImagePickerController` for photo library access. On image selection, uses the **Vision** framework (`VNDetectBarcodesRequest`) to scan the image for barcodes. Returns the first detected barcode's string value and symbology type to SwiftUI.

---

### Services

#### `WalletService.swift`
Handles adding a barcode card to Apple Wallet.

**Flow:**
1. Maps the app's barcode type string to the `PKPassLibrary` format string.
2. Converts the card's `Color` to RGB float components.
3. Calculates luminance to choose an appropriate foreground/label color (white vs. black).
4. POSTs a JSON payload to the remote pass-signing server.
5. On success, decodes the binary response as `PKPass` and presents `PKAddPassesViewController`.

**Pass-signing server endpoint:**
```
POST https://pass-signer-production-e33f.up.railway.app/sign-pass
```

**Request body (JSON):**
```json
{
  "barcodeValue": "<raw barcode string>",
  "barcodeFormat": "<format, e.g. 'qr'>",
  "title": "<card name>",
  "backgroundColor": "rgb(r, g, b)",
  "foregroundColor": "rgb(r, g, b)",
  "labelColor": "rgb(r, g, b)"
}
```

**Response:** Raw `PKPass` binary data (`.pkpass` format).

#### `AppDelegate.swift`
`UIApplicationDelegate` that manages screen brightness to improve barcode readability.

- Stores the user's original brightness when the app moves to inactive/background.
- On `applicationDidBecomeActive`, restores or adjusts brightness as needed.

#### `ATTConsent.swift`
Requests App Tracking Transparency authorization via `ATTrackingManager.requestTrackingAuthorization`. Called from the app foreground transition to comply with Apple's privacy requirements and enable personalized ads.

#### `Extensions.swift`
`UIColor` extension that adds:
- `ciColor` — converts `UIColor` to `CIColor` for use with `CIFilter`.
- `rgba` — returns `(red:green:blue:alpha:)` float tuple.

---

### Views — Main Screens

#### `TabsView.swift`
Root navigation shell. Three tabs:

| Tab | Icon | Destination |
|---|---|---|
| Wallet | `wallet.pass` | `HomeView` |
| Barcode | `barcode` | `ScanBarcodeView` |
| QR Code | `qrcode` | `QRCodeView` |

#### `HomeView.swift`
Primary wallet screen. Fetches all `BarcodeData` records with `@FetchRequest` sorted by name.

- Renders cards as a draggable stack using `DragState` and spring animations.
- Tapping a card opens `CardDetailView`.
- FAB triggers `UploadSheetView` (scan or manual entry) → `CreateBarcodeView`.
- Displays a `BannerAdView` for non-Pro users.
- Swipe-to-delete removes the card from Core Data.
- Shows a RevenueCat paywall sheet when non-Pro users attempt a Pro action.

#### `CreateBarcodeView.swift`
Form for creating a new barcode card.

- Text field for card name.
- `ColorPicker` for background color.
- Toggle to mark as a coupon; if enabled, shows a `DatePicker` for expiration.
- Live preview via `BarcodeCard`.
- On save: inserts a new `BarcodeData` managed object and calls `context.save()`.

#### `UpdateCardView.swift`
Edit form for an existing card. Pre-populates all fields from the selected `BarcodeData` object. On save, updates the managed object properties and calls `context.save()`.

#### `CardDetailView.swift`
Full-screen card presentation.

- Increases screen brightness to maximum for easy scanning.
- "Add to Apple Wallet" button (Pro-gated) calls `WalletService.addToWallet(...)`.
- Share button renders `ShareBarcodeView` off-screen and captures it as a `UIImage` for `ShareLink`.
- `BannerAdView` shown at the bottom for non-Pro users.

#### `BarcodeCard.swift`
Reusable card component used in `HomeView`, `CreateBarcodeView`, and `CardDetailView`.

- Renders the correct barcode view based on `barcodeType` (routes to one of 13 barcode view types).
- Applies the card's background color.
- Shows expiration date badge if the card is a coupon.
- Uses `autoContrastTextColor` to ensure the card name is readable against the background.

#### `BarcodeScannerView.swift`
SwiftUI wrapper (`UIViewControllerRepresentable`) for `UploadViewController`. Bridges the photo library barcode detection result back into SwiftUI `@Binding` state.

#### `UploadSheetView.swift`
Modal sheet presented from `HomeView`'s FAB. Offers two paths:

| Option | Action |
|---|---|
| Camera | Opens `CameraView` / `ScanBarcodeView` |
| Photo Library | Opens `BarcodeScannerView` |

After detection, navigates to `CreateBarcodeView` with pre-filled barcode data.

---

### Views — Supporting Components

#### `BarcodeCollectionView.swift`
Contains individual SwiftUI view structs for each barcode format. Each struct wraps either:
- A `RSBarcodes_Swift` generator for formats it supports, or
- A `BarcodeGenModel` `CIFilter` call for QR/Aztec/Code128.

Supported views: `Code128View`, `Code39View`, `EAN8View`, `EAN13View`, `PDF417View`, `ITF14View`, `Interleaved2of5View`, `UPCEView`, `QRCodeBarcodeView`, `AztecView`.

#### `CDCodabrView.swift`
`UIView` subclass that draws a Codabar barcode by converting the binary output of `CDCodabarEncoder` into a series of vertical bars using `CGContext`.

#### `CodabarBarcodeView.swift`
SwiftUI `UIViewRepresentable` wrapper around `CDCodabrView` for embedding in `BarcodeCard`.

#### `BannerAdView.swift`
`UIViewRepresentable` wrapping `GADBannerView` (Google Mobile Ads). Uses `GADAdSizeFullWidthPortraitWithHeight` with a `GeometryReader` to match the available width. Loads ads on `makeUIView`.

#### `ShareBarcodeView.swift`
An off-screen view rendering a `BarcodeCard` with the app name watermark. Used by `CardDetailView` to snapshot a shareable card image.

#### `BrightnessOverlay.swift`
A semi-transparent black `Rectangle` overlaid on the screen. Fades in/out to simulate brightness changes without UIKit calls where not possible.

#### `ScanBarcodeView.swift`
SwiftUI `UIViewControllerRepresentable` wrapper around `BarcodeScannerController`. Receives the scanned barcode value via `@Binding` through the `Coordinator`.

---

## 5. Data Layer

### Core Data Entity: `BarcodeData`

| Attribute | Type | Notes |
|---|---|---|
| `id` | `UUID` | Primary key; auto-generated |
| `name` | `String` | Card display name |
| `barcodeNumber` | `String` | Raw barcode content |
| `barcodeType` | `String` | Format identifier string |
| `red` | `Float` | Background color — red channel (0–1) |
| `green` | `Float` | Background color — green channel (0–1) |
| `blue` | `Float` | Background color — blue channel (0–1) |
| `alpha` | `Float` | Background color — alpha channel (0–1) |
| `expirationDate` | `Date?` | Optional; set for coupon cards only |

### CloudKit Sync

The container `iCloud.BlackBox.BarcodeWallet` mirrors the `BarcodeData` entity to CloudKit. All CRUD operations on the `viewContext` are automatically synced. Persistent history tracking is required and enabled.

### Color Round-Trip

Colors are broken into RGBA float components for Core Data storage because `Color`/`UIColor` are not directly storable. The conversion path is:

```
SwiftUI Color  ──▶  UIColor  ──▶  rgba tuple  ──▶  4× Float attributes
Float attributes  ──▶  Color(red:green:blue:opacity:)
```

---

## 6. API & Service Integrations

### Pass-Signing Server

| Detail | Value |
|---|---|
| URL | `https://pass-signer-production-e33f.up.railway.app/sign-pass` |
| Method | `POST` |
| Content-Type | `application/json` |
| Host | Railway (production) |

The app itself does **not** hold the Apple certificate or private key needed to sign PKPasses. Instead, the signing is delegated to a remote Node.js/Express server. The app sends card metadata and receives a signed `.pkpass` binary in the response body.

**Barcode format mapping (app type → pass format):**

| App Type String | Pass Format |
|---|---|
| `QR Code` | `qr` |
| `Aztec` | `aztec` |
| `PDF417` | `pdf417` |
| `Code 128` | `code128` |
| `Code 39` | `code39` |
| `Code 93` | `code93` |
| `EAN-8` | `ean8` |
| `EAN-13` | `ean13` |
| `ITF-14` | `itf14` |
| `Codabar` | `codabar` |
| `Interleaved 2 of 5` | `interleaved2of5` |
| `UPC-E` | `upce` |

### Google Mobile Ads (AdMob)

| Detail | Value |
|---|---|
| SDK | `GoogleMobileAds` (SPM) |
| App ID | `ca-app-pub-6951214266085379~5344806223` |
| Ad Type | Adaptive banner only |
| Shown to | Non-Pro users on `HomeView` and `CardDetailView` |

Initialized in `BarcodeWalletApp` via `GADMobileAds.sharedInstance().start(completionHandler: nil)`.

### RevenueCat (In-App Purchases)

| Detail | Value |
|---|---|
| SDK | `RevenueCat` + `RevenueCatUI` (SPM) |
| API Key (prod) | `appl_RHXwalTzjyJnJIUAvyoemEUSsoP` |
| Tier | `Pro` |

Initialized via `Purchases.configure(withAPIKey:)`. The `isPro` state is checked wherever Pro features are gated (Apple Wallet export, ad removal). Non-Pro users see a `PaywallView` sheet from `RevenueCatUI`.

### Vision Framework (Apple)

Used in `UploadViewController` to detect barcodes in still images selected from the photo library.

**Request type:** `VNDetectBarcodesRequest`  
**Supported symbologies:** All that Vision supports (16+).  
**Output:** `VNBarcodeObservation.payloadStringValue` and `.symbology` passed back via completion closure.

### AVFoundation (Apple)

Used in `BarcodeScannerController` for live camera scanning.

**Session preset:** `.high`  
**Detected types (13):**

```swift
[.aztec, .code128, .code39, .code39Checksum, .code39FullASCII,
 .code93, .dataMatrix, .ean13, .ean8, .itf14, .pdf417, .qr, .upce]
```

### CIFilter (Apple)

Used in `BarcodeGenModel` for on-device barcode image generation.

| Filter | Barcode |
|---|---|
| `CIQRCodeGenerator` | QR Code |
| `CIAztecCodeGenerator` | Aztec |
| `CICode128BarcodeGenerator` | Code 128 |

### PassKit (Apple)

`WalletService` uses:
- `PKPassLibrary` — check if Wallet is available.
- `PKAddPassesViewController` — present the pass-add UI.
- `PKPass(data:error:)` — decode the server response into a pass object.

---

## 7. Third-Party Dependencies

All dependencies are managed via Swift Package Manager.

| Package | Version | Purpose |
|---|---|---|
| `RSBarcodes_Swift` | Latest | Generate barcode `UIImage` for Code39, Code93, EAN-8/13, PDF417, ITF14, I2of5, UPC-E, Aztec, QR |
| `GoogleMobileAds` | Latest | AdMob banner ad SDK |
| `RevenueCat` | Latest | Subscription management & receipt validation |
| `RevenueCatUI` | Latest | Pre-built paywall UI |

### `RSBarcodes_Swift` Usage

Used exclusively inside `BarcodeCollectionView.swift`. Each barcode view calls the corresponding `RSUnifiedCodeGenerator.shared.generateCode(...)` method with the barcode string and format. No network call is involved — generation is entirely local.

---

## 8. Barcode Support

### Supported Formats

| Format | Render Method | Scan Detection |
|---|---|---|
| QR Code | `CIFilter` (`CIQRCodeGenerator`) | AVFoundation + Vision |
| Aztec | `CIFilter` (`CIAztecCodeGenerator`) | AVFoundation + Vision |
| Code 128 | `CIFilter` (`CICode128BarcodeGenerator`) | AVFoundation + Vision |
| Code 39 | `RSBarcodes_Swift` | AVFoundation + Vision |
| Code 93 | `RSBarcodes_Swift` | AVFoundation + Vision |
| EAN-8 | `RSBarcodes_Swift` | AVFoundation + Vision |
| EAN-13 | `RSBarcodes_Swift` | AVFoundation + Vision |
| PDF417 | `RSBarcodes_Swift` | AVFoundation + Vision |
| ITF-14 | `RSBarcodes_Swift` | AVFoundation + Vision |
| Interleaved 2 of 5 | `RSBarcodes_Swift` | AVFoundation + Vision |
| UPC-E | `RSBarcodes_Swift` | AVFoundation + Vision |
| Codabar | Custom (`CDCodabarEncoder` + `CDCodabrView`) | AVFoundation + Vision |

### Codabar Custom Implementation

Codabar is not supported by `CIFilter` or `RSBarcodes_Swift`, so it has a fully custom implementation:

1. `CDCodabarEncoder` — validates the string and converts characters to binary bar sequences using the standard Codabar encoding table.
2. `CDCodabrView: UIView` — reads the binary sequence and draws the barcode bars using Core Graphics.
3. `CodabarBarcodeView: UIViewRepresentable` — embeds `CDCodabrView` into SwiftUI.

---

## 9. Monetization & Ads

### Free vs. Pro

| Feature | Free | Pro |
|---|---|---|
| Create & manage cards | ✓ | ✓ |
| Barcode scanning | ✓ | ✓ |
| iCloud sync | ✓ | ✓ |
| Banner ads | Shown | Hidden |
| Add to Apple Wallet | — | ✓ |

### Ad Display Logic

`HomeView` and `CardDetailView` both check the RevenueCat `isPro` flag before rendering `BannerAdView`. No ad network calls are made for Pro users.

### ATT Consent

`ATTConsent.requestTracking()` is called when the app becomes active. Authorization status determines whether AdMob can serve personalized ads.

---

## 10. Permissions & Entitlements

### Required Permissions (Info.plist)

| Key | Reason |
|---|---|
| `NSCameraUsageDescription` | Live barcode scanning |
| `NSPhotoLibraryUsageDescription` | Upload image for barcode detection |
| `NSUserTrackingUsageDescription` | ATT prompt for personalized ads |

### Entitlements

| Entitlement | Value |
|---|---|
| iCloud containers | `iCloud.BlackBox.BarcodeWallet` |
| CloudKit | Enabled |
| Associated Passes | `$(TeamIdentifierPrefix)pass.com.blackbox.barcodewallet` |
| APS Environment | `development` |

---

## 11. Configuration

### Info.plist Keys

| Key | Value |
|---|---|
| `GADApplicationIdentifier` | `ca-app-pub-6951214266085379~5344806223` |
| `NSAppTransportSecurity.NSAllowsArbitraryLoads` | `YES` (HTTP allowed for development) |
| `UIBackgroundModes` | `fetch`, `remote-notification` |
| `ITSAppUsesNonExemptEncryption` | `NO` |

### RevenueCat API Keys

```swift
// Production (active)
Purchases.configure(withAPIKey: "appl_RHXwalTzjyJnJIUAvyoemEUSsoP")
```

### Pass-Signing Server

The server URL is hardcoded in `WalletService.swift`. To switch environments, update:

```swift
let url = URL(string: "https://pass-signer-production-e33f.up.railway.app/sign-pass")!
```

---

*Generated: May 2026*
