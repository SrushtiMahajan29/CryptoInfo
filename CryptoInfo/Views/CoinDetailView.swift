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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack{
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
                    
                    //                HStack(spacing: 20){
                    //                    VStack(spacing: 20){
                    //                        if let marketCap = coin.market_cap {
                    //                            Text("Market Cap: $\(marketCap, specifier: "%.0f")")
                    //                        }
                    //                        if let supply = coin.circulating_supply {
                    //                            Text("Circulating Supply: \(supply, specifier: "%.0f")")
                    //                        }
                    //                    }
                    //                    VStack(spacing: 20){
                    //                        Text("Current Price: $\(coin.current_price, specifier: "%.2f")")
                    //                            .font(.title2)
                    //                        if let volume = coin.total_volume {
                    //                            Text("24h Volume: $\(volume, specifier: "%.0f")")
                    //                        }
                    //                    }
                    //                }.padding()
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        StatView(title: "Market Cap", value: coin.market_cap)
                        StatView(title: "Circulating Supply", value: coin.circulating_supply)
                        StatView(title: "Total Supply", value: coin.total_supply)
                        StatView(title: "Max Supply", value: coin.max_supply)
                        StatView(title: "24h Volume", value: coin.total_volume)
                        StatView(title: "24h High", value: coin.high_24h)
                        StatView(title: "24h Low", value: coin.low_24h)
                        StatView(title: "Price Change %", value: coin.price_change_percentage_24h, isPercentage: true)
                    }
                    Text("Price Changes")
                        .font(.headline)
                    if !prices.isEmpty {
                        Chart {
                            ForEach(prices.indices, id: \.self) { index in
                                LineMark(
                                    x: .value("Day", index),
                                    y: .value("Price", prices[index])
                                ).interpolationMethod(.catmullRom)
                            }
                        }
                        .frame(height: 200)
                        .padding()
                    } else {
                        ProgressView("Loading chart...")
                            .padding()
                    }
                    
                    let deltas = zip(prices, prices.dropFirst()).map { abs($1 - $0) }
                    
                    Text("Changes per time")
                        .font(.headline)
                    Chart {
                        ForEach(deltas.indices, id: \.self) { i in
                            BarMark(
                                x: .value("Time", i),
                                y: .value("Change", deltas[i])
                            )
                        }
                    }
                    .frame(height: 150)

                }
                .padding()
                
            }
            .onAppear {
                fetchChartData()
            }
        }.navigationTitle(coin.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation{
                            fetchChartData()
                        }
                        
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
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
}

