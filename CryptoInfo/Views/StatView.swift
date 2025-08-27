//
//  StatView.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 26/08/25.
//
import Foundation
import SwiftUI

struct StatView: View {
    let title: String
    let value: Double?
    var isPercentage: Bool = false
    
    var formattedValue: String {
        guard let value = value else { return "N/A" }
        if isPercentage {
            return String(format: "%.2f%%", value)
        } else {
            // Format large numbers with commas
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(formattedValue)
                .font(.headline)
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}
