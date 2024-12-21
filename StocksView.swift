//
//  StocksView.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/4/24.
//

import SwiftUI

struct StocksView: View {
    @EnvironmentObject var brightnessManager: BrightnessManager
    
    @State private var stockInfo: StockInfo?
    @State private var stocksTicker = ""
    @State private var errorMessage: String?
    @State private var favoriteTickers: [String] = []
    @State private var spinningFavButton: String?
    @State private var bounceFavorites = false
    private let stocksHelper = StocksHelper()
    private let stocksInfoURL = "https://polygon.io/"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                Color.black.opacity(1.0 - brightnessManager.brightness)
                    .ignoresSafeArea()
                
                VStack {
                    GoBarView(goString: $stocksTicker, title: NSLocalizedString("Stock Info for:", comment: "Label for stock information")) {
                        Task {
                            fetchStocksData()
                        }
                    }
                    .padding(.vertical)
                    
                    if let stockInfo = stockInfo {
                        HStack {
                            Text("Ticker: \(stockInfo.ticker)")
                                .font(.headline)
                                .padding(.top)
                                .padding()
                            Spacer()
                            Button(action: {
                                toggleFavorite(ticker: stockInfo.ticker)
                            }) {
                                Image(systemName: isFavorite(ticker: stockInfo.ticker) ? "star.fill" : "star")
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                    .rotationEffect(
                                        spinningFavButton == stockInfo.ticker ? Angle.degrees(360) : Angle.degrees(0)
                                    )
                                    .animation(
                                        spinningFavButton == stockInfo.ticker ? Animation.linear(duration: 0.5) : .default, value: spinningFavButton
                                    )
                            }
                            .padding()
                        }
                        
                        List {
                            ForEach(stockInfo.results, id: \.t) { result in
                                NavigationLink(
                                    destination: StockDayView(result: result, ticker: stockInfo.ticker)
                                ) {
                                    Text(formattedDate(from: result.t))
                                        .font(.subheadline)
                                        .bold()
                                }
//                                VStack(alignment: .leading) {
//                                    Text("Date: \(formattedDate(from: result.t))")
//                                        .font(.subheadline)
//                                        .bold()
//                                    
//                                    Text("Open Price: \(result.o)")
//                                    Text("Close Price: \(result.c)")
//                                    Text("Highest Price: \(result.h)")
//                                    Text("Lowest Price: \(result.l)")
//                                    Text("Trading Volume: \(result.v)")
//                                    Text("Number of Transactions: \(result.n)")
//                                }
                            }
                        }
                        .listStyle(.plain)
                        
                        if let stocksInfoURL = URL(string: stocksInfoURL) {
                            Link("Stock Data by Polygon API", destination: stocksInfoURL)
                                .font(.body)
                                .foregroundColor(.green)
                        }
                    } else if errorMessage != nil {
                        Text(errorMessage!)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        if let stocksInfoURL = URL(string: stocksInfoURL) {
                            Link("Stock Data by Polygon API", destination: stocksInfoURL)
                                .font(.body)
                                .foregroundColor(.green)
                        }
                    }
                    NavigationLink(destination: FavoritesView(favoriteTickers: $favoriteTickers)) {
                        Text("View Favorites")
                        //                    .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: 200, maxHeight: 40)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(100)
                            .padding(.horizontal)
                            .scaleEffect(bounceFavorites ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 0.3).repeatCount(3, autoreverses: true), value: bounceFavorites
                            )
                    }
                }
            }
        }
    }
    
    private func fetchStocksData() {
        print("Refresh button tapped")
        stocksHelper.fetchStocksData(for: stocksTicker) { fetchedInfo in
            DispatchQueue.main.async {
                if let info = fetchedInfo {
                    self.stockInfo = info
                    print("State updated with new stock info")
                } else {
                    print("Failed to fetch stock info")
                }
            }
        }
    }
    
    private func loadStockData() {
        if let cachedInfo: StockInfo =
            FileManager.readFromFile(StockInfo.self, filename: "stockInfo.json") {
            stockInfo = cachedInfo
        }
    }
    
    private func toggleFavorite(ticker: String) {
        spinningFavButton = ticker
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            spinningFavButton = nil
        }
        
        
        if isFavorite(ticker: ticker) {
            favoriteTickers.removeAll { $0 == ticker }
        } else {
            favoriteTickers.append(ticker)
        }
        saveFavorites()
        
        withAnimation {
            bounceFavorites = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            bounceFavorites = false
        }
    }
    
    private func isFavorite(ticker: String) -> Bool {
        return favoriteTickers.contains(ticker)
    }
    
    private func saveFavorites() {
        FileManager.saveToFile(favoriteTickers, filename: "favorites.json")
    }
    
    private func loadFavorites() {
        if let loadedFavorites: [String] = FileManager.readFromFile([String].self, filename: "favorites.json") {
            favoriteTickers = loadedFavorites
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
    StocksView()
        .environmentObject(BrightnessManager())
}
