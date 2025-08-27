//
//  LivePricePoint.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 26/08/25.
//


import Foundation

struct LivePricePoint: Identifiable {
    let id = UUID()
    let time: Date
    let price: Double
}
