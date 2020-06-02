//
//  ContentView.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Ceren on 2.06.2020.
//  Copyright © 2020 ceren. All rights reserved.
//

import SwiftUI
import CodeScanner


struct ContentView: View {
    
    @State private var isShowingScanner = false
    
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
           Button(action: {
               self.isShowingScanner = true
           }) {
               Text("Show Scanner")
           }
           .sheet(isPresented: $isShowingScanner) {
               CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.handleScan)
           }
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
