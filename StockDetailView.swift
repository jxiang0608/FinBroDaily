//
//  StockDetailView.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/4/24.
//

import SwiftUI

struct StockDetailView: View {
    @EnvironmentObject var brightnessManager: BrightnessManager
    
    let ticker: String
    @State private var stockInfo: StockInfo?
    @State private var errorMessage: String?
    private let stocksHelper = StocksHelper()
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            Color.black.opacity(1.0 - brightnessManager.brightness)
                .ignoresSafeArea()
            
            VStack {
                if let stockInfo = stockInfo {
                    List {
                        ForEach(stockInfo.results, id: \.t) { result in
                            VStack(alignment: .leading) {
                                Text("Date: \(formattedDate(from: result.t))")
                                    .font(.subheadline)
                                    .bold()
                                Text("Open Price: \(result.o)")
                                Text("Close Price: \(result.c)")
                                Text("Highest Price: \(result.h)")
                                Text("Lowest Price: \(result.l)")
                                Text("Trading Volume: \(result.v)")
                                Text("Number of Transactions: \(result.n)")
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                } else if errorMessage != nil {
                    Text(errorMessage!)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ProgressView("Loading...")
                }
            }
            .onAppear(perform: fetchStockData)
            .navigationTitle(ticker)
            .scrollContentBackground(.hidden)
        }
    }
    
    private func fetchStockData() {
        stocksHelper.fetchStocksData(for: ticker) { fetchedInfo in
            DispatchQueue.main.async {
                if let info = fetchedInfo {
                    self.stockInfo = info
                } else {
                    self.errorMessage = "Failed to fetch stock data"
                }
            }
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
    StockDetailView(ticker: "AAPL")
        .environmentObject(BrightnessManager())
}
