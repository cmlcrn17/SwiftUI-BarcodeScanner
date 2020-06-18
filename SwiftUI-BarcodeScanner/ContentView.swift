//
//  ContentView.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Ceren on 2.06.2020.
//  Copyright © 2020 ceren. All rights reserved.
//

import SwiftUI
import CodeScanner
import CarBode
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State private var isShowingScanner = false
    @State var torceIsOn = false
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let data):
            print("Success with \(data)")
        case .failure(let error):
            print("Scanning failed \(error)")
        }
    }
    
    @State private var name = "Ceren"
    @State private var emailAddress = "https://medium.com/@cmlcrn17"
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        
        VStack(alignment: .center ){
            
            Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
            .interpolation(.none) //netlik sağlar
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            
            
            
            Button(action: {
                self.isShowingScanner = true
            }) {
                Text("Show Scanner")
            }.padding()
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.handleScan)
            }
            
            
            Button(action: {
                self.isShowingScanner = true
                self.torceIsOn.toggle()
            }) {
                Text("Show Barcode")
            }.sheet(isPresented: $isShowingScanner) {
                CBScanner(supportBarcode: [.qr, .code128]) //Set type of barcode you want to scan
                    .torchLight(isOn: self.torceIsOn) // Turn torch light on/off
                    .interval(delay: 5.0) //Event will trigger every 5 seconds
                    .found{
                        //Your..Code..Here
                        print($0)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
