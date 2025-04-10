//
//  MainView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 12/03/2025.
//
import SwiftUI

struct MainView: View {
    @State private var tabController = TabController()
    @State private var path: [DestinationViews] = []
    
    @Environment(LocationStore.self) private var store

    var body: some View {
        ZStack {
            // TabView Background
            TabView(selection: $tabController.activeTab) {
                
               // ContentView()
                   // .tabItem {
                   //     Label("Home", systemImage: "house")
                  //  }
                  // .tag(CoffeeTab.menuTab)
                
                FavView()
                    .tabItem {
                        Label("Favorites", systemImage: "star")
                    }
                    .badge(store.locations.count)
                    .tag(CoffeeTab.FavTab)
                ContentView(path: $path)
                    // .tabItem {
                    //     Label("Home", systemImage: "house")
                   //  }
                    .tag(CoffeeTab.menuTab)
                
                MapView()
                    .tabItem {
                        Label("Map", systemImage: "location")
                    }
                    .tag(CoffeeTab.orderTab)
                    .environment(tabController)
            }
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            
            // Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        tabController.open(tab: .menuTab)
                        path = []
                    }) {
                        Image(systemName: "house")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .offset(x:0, y: 0) // Raise button above tab bar
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(LocationStore())
}

enum CoffeeTab {
    case menuTab
    case orderTab
    case FavTab
}

@Observable
class TabController {
    var activeTab = CoffeeTab.menuTab
    
    func open(tab: CoffeeTab) {
        activeTab = tab
    }
}
