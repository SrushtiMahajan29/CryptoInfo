//
//  ContentView.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 25/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CryptoViewModel()

    var body: some View {
        NavigationView {
            if viewModel.cryptoData.isEmpty {
                NoDataView()
            } else {
                List(viewModel.cryptoData) { crypto in
//                    CryptoView(crypto: crypto)
                    NavigationLink(destination: CoinDetailView(coin: crypto)) {
                        CryptoView(crypto: crypto)
                    }
                }
                .navigationBarTitle("Crypto Info", displayMode: .inline)
            }
        }
    }
}

#Preview {
    ContentView()
}
