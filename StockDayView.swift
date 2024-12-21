//
//  StockDayView.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/5/24.
//

import SwiftUI

struct StockDayView: View {
    @EnvironmentObject var brightnessManager: BrightnessManager

    let result: StockResult
    let ticker: String
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            Color.black.opacity(1.0 - brightnessManager.brightness)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("\(formattedDate(from: result.t)) Details for \(ticker)")
                    .font(.headline)
                    .bold()
                
                Text("---")
                
                Text("Open Price: \(result.o)")
                Text("Close Price: \(result.c)")
                Text("Highest Price: \(result.h)")
                Text("Lowest Price: \(result.l)")
                Text("Trading Volume: \(result.v)")
                Text("Number of Transactions: \(result.n)")
            }
            .padding()
        }
    }
    
    private func formattedDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp)/1000.0)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    StockDayView(
        result: StockResult(
            v: 1200000,   // Volume
            vw: 148.00,   // Volume-weighted average price
            o: 145.50,    // Open price
            c: 150.30,    // Close price
            h: 152.00,    // High price
            l: 144.00,    // Low price
            t: Int(Date().timeIntervalSince1970 * 1000), // Current timestamp in milliseconds
            n: 8500       // Number of transactions
        ),
        ticker: "AAPL" // Example ticker
    )
    .environmentObject(BrightnessManager())
}
