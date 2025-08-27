//
//  CryptoModel.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 25/08/25.
//

import SwiftUI

struct CryptoModel: Identifiable, Decodable {
    let id: String
    let name: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double
    
    let market_cap: Double?
    let total_volume: Double?
    let circulating_supply: Double?
    let max_supply: Double?
    let total_supply: Double?
    let high_24h: Double?
    let low_24h: Double?
}

    
    
