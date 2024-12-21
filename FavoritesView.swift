//
//  FavoritesView.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/4/24.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var brightnessManager: BrightnessManager
    @Binding var favoriteTickers: [String]
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            Color.black.opacity(1.0 - brightnessManager.brightness)
                .ignoresSafeArea()
            
            VStack {
                if favoriteTickers.isEmpty {
                    Text("No favorites yet!")
                        .font(.headline)
                        .padding()
                } else {
                    List {
                        ForEach(favoriteTickers, id: \.self) { ticker in
                            NavigationLink(destination: StockDetailView(ticker: ticker)) {
                                Text(ticker)
                                    .font(.headline)
                            }
                        }
                        .background(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
//                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorite Stocks")
        }
    }
}

#Preview {
    FavoritesView(favoriteTickers: .constant(["AAPL", "GOOGL", "MSFT"]))
        .environmentObject(BrightnessManager())
}
