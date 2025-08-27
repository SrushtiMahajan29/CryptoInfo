//
//  CryptoView.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 25/08/25.
//

import SwiftUI

struct CryptoView: View {

    var crypto: CryptoModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: crypto.image)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.horizontal, 5)
            } placeholder: {
                ProgressView()
                    .padding(.horizontal, 5)
            }

            VStack(alignment: .leading) {
                Text(crypto.name)
                    .font(.headline)
                Text("$\(crypto.current_price)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Text("\(crypto.price_change_percentage_24h, specifier: "%.2f")%")
                .foregroundStyle(crypto.price_change_percentage_24h < 0 ? .red : .green)
        }
        .padding(.vertical, 5)
    }
}
