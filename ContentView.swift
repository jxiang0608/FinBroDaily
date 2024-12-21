//
//  ContentView.swift
//  FinBroDaily
//
//  Created by Joy Xiang on 12/5/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var brightnessManager: BrightnessManager

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                Color.black.opacity(1.0 - brightnessManager.brightness)
                    .ignoresSafeArea()
                
                TabView {
//                    WeatherView()
//                        .tabItem {
//                            Label(TabType.weather.title, image: TabType.weather.image)
//                        }
//                        .tag(0)
                    StocksView()
                        .tabItem {
                            Label(TabType.stocks.title, image: TabType.stocks.image)
                        }
                        .tag(0)
                    //            SettingsView()
                    //                .tabItem {
                    //                    Label(TabType.settings.title, image: TabType.settings.image)
                    //                }
                    //                .tag(2)
                    AppInfoView()
                        .tabItem {
                            Label(TabType.appInfo.title, image: TabType.appInfo.image)
                        }
                        .tag(1)
                }
            }
//            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BrightnessManager())
}
