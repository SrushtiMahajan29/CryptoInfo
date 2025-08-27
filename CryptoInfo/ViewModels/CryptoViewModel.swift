//
//  CryptoViewModel.swift
//  CryptoInfo
//
//  Created by Srushti Mahajan on 25/08/25.
//


import SwiftUI

class CryptoViewModel: ObservableObject {

    @Published var cryptoData = [CryptoModel]()

    private let apiURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false"
//    private let apiURL = "https://api.coingecko.com/api/v3/coins/markets?x_cg_demo_api_key=CG-uqDS9S6kkRmqkCmSETYNArnJ"
    
//    var request = URLRequest(url: URL(string: apiURL)!)
//    request.addValue("YOUR_API_KEY", forHTTPHeaderField: "x-cg-pro-api-key")

    init() {
        fetchCryptoData()
        fetchData()
    }

    private func fetchCryptoData() {
        guard let url = URL(string: apiURL) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([CryptoModel].self, from: data)

                    DispatchQueue.main.async {
                        self.cryptoData = decodedData
                    }

                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    private func fetchData(){

        // Define the base URL for the GET request
        let baseURLString = "https://api.coingecko.com/api/v3/coins"

        // Create an ephemeral URLSessionConfiguration.You can use default here based on your need
        let configuration = URLSessionConfiguration.ephemeral

        // Create a URLSession with the ephemeral configuration.
        let session = URLSession(configuration: configuration)

        // Define query items
        let queryItems = [
            URLQueryItem(name: "userId", value: "1"),
            URLQueryItem(name: "title", value: "Apple URL Loading System")
        ]

        // Create URL components
        var urlComponents = URLComponents(string: baseURLString)
        urlComponents?.queryItems = queryItems

        // Create a URLRequest with the URL
        guard let url = urlComponents?.url else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Create a data task with the request
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Check for response and data
            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
                print("Invalid response or data")
                return
            }
            
            // Print the HTTP status code
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            // Print the response body as a string
            if let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseBody)")
            }
        }

        // Resume the task
        task.resume()
    }
}
