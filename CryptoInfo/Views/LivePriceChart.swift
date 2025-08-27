/*//
//  LivePriceChart.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 26/08/25.
//

//
//  CoinDetailView.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 26/08/25.
//


import SwiftUI
import Charts

struct CoinDetailView: View {
    let coin: CryptoModel
    @State private var prices: [Double] = []
    @State private var livePrices: [LivePricePoint] = []
    @State private var timer: Timer?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: coin.image)) { image in
                    image.resizable()
                        .frame(width: 60, height: 60)
                } placeholder: {
                    ProgressView()
                }
                
                Text(coin.name)
                    .font(.largeTitle)
                    .bold()
                
                Text("Current Price: $\(coin.current_price, specifier: "%.2f")")
                    .font(.title2)
                
                if let marketCap = coin.market_cap {
                    Text("Market Cap: $\(marketCap, specifier: "%.0f")")
                }
                
                if let volume = coin.total_volume {
                    Text("24h Volume: $\(volume, specifier: "%.0f")")
                }
                
                if let supply = coin.circulating_supply {
                    Text("Circulating Supply: \(supply, specifier: "%.0f")")
                }
                
                if !prices.isEmpty {
                    Chart {
                        ForEach(prices.indices, id: \.self) { index in
                            LineMark(
                                x: .value("Day", index),
                                y: .value("Price", prices[index])
                            )
                        }
                    }
                    .frame(height: 200)
                    .padding()
                } else {
                    ProgressView("Loading chart...")
                        .padding()
                }
                
                if !livePrices.isEmpty {
                    Chart {
                        ForEach(livePrices) { point in
                            LineMark(
                                x: .value("Time", point.time),
                                y: .value("Price", point.price)
                            )
                        }
                    }
                    .frame(height: 200)
                    .padding()
                } else {
                    ProgressView("Fetching live data...")
                        .padding()
                }
            }
            .padding()
        }
        .onAppear {
            fetchChartData()
            startLiveUpdates()
        }
        .onDisappear {
            stopLiveUpdates()
        }
    }
    
    private func fetchChartData() {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coin.id)/market_chart?vs_currency=usd&days=7"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Chart data error:", error ?? "Unknown error")
                return
            }
            do {
                let chart = try JSONDecoder().decode(MarketChart.self, from: data)
                let pricePoints = chart.prices.map { $0[1] }
                DispatchQueue.main.async {
                    self.prices = pricePoints
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
    
    func startLiveUpdates() {
        fetchLatestPrice() // fetch immediately

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            fetchLatestPrice()
        }
    }

    func stopLiveUpdates() {
        timer?.invalidate()
        timer = nil
    }

    func fetchLatestPrice() {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin.id)&vs_currencies=usd"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let coinData = json[coin.id] as? [String: Any],
                       let price = coinData["usd"] as? Double {
                        
                        DispatchQueue.main.async {
                            let newPoint = LivePricePoint(time: Date(), price: price)
                            livePrices.append(newPoint)

                            // Limit to last 20 points for performance
                            if livePrices.count > 20 {
                                livePrices.removeFirst()
                            }
                        }
                    }
                } catch {
                    print("JSON error: \(error)")
                }
            }
        }.resume()
    }
}
*/
