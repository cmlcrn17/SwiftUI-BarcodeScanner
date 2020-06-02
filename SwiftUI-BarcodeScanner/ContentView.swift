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


struct ContentView: View {
    
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
    
    var body: some View {
        
        VStack(alignment: .center ){
            
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
