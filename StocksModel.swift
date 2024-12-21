//
//  StocksModel.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/4/24.
//

import Foundation
// api key: ARZeOUAHaPPiTKPgn9n2AFucYTQbqKLN
/* api ex: https://api.polygon.io/v2/aggs/ticker/AAPL/range/1/day/2024-11-01/2024-11-25?adjusted=true&sort=asc&apiKey=ARZeOUAHaPPiTKPgn9n2AFucYTQbqKLN
*/

struct StockInfo: Codable {
    let ticker: String
    let queryCount: Int
    let resultsCount: Int
    let adjusted: Bool
    let results: [StockResult]
}

struct StockResult: Codable {
    let v: Int // The trading volume of the symbol in the given time period.
    let vw: Double // The volume weighted average price.
    let o: Double // The open price for the symbol in the given time period.
    let c: Double // The close price for the symbol in the given time period.
    let h: Double // The highest price for the symbol in the given time period.
    let l: Double // The lowest price for the symbol in the given time period.
    let t: Int // The Unix Msec timestamp for the start of the aggregate window.
    let n: Int // The number of transactions in the aggregate window.
}

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func saveToFile<T: Codable>(_ data: T, filename: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            try encodedData.write(to: fileURL)
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    static func readFromFile<T: Codable>(_ type: T.Type, filename: String) -> T? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
