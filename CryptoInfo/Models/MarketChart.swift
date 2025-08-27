//
//  MarketChart.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 26/08/25.
//


import Foundation

struct MarketChart: Decodable {
    let prices: [[Double]]  // array of [timestamp, price]
}
