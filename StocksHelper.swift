//
//  StocksHelper.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/4/24.
//

import Foundation

class StocksHelper {
    func fetchStocksData(for stocksTicker: String, completion: @escaping (StockInfo?) -> Void) {
        let stocksURL = "https://api.polygon.io/v2/aggs/ticker/\(stocksTicker)/range/1/day/2024-11-01/2024-11-25?adjusted=true&sort=asc&apiKey=ARZeOUAHaPPiTKPgn9n2AFucYTQbqKLN"
        print("Fetching from URL: \(stocksURL)")
        
        guard let url = URL(string: stocksURL) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(rawResponse)")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("HTTP Error: \(httpResponse.statusCode)")
                    completion(nil)
                    return
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let stockInfo = try decoder.decode(StockInfo.self, from: data)
                completion(stockInfo)
            } catch {
                print("Decoding error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
