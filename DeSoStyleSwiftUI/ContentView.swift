// ContentView.swift
// Main entry point for the Superpower UI app. Sets up the tab navigation.
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeTab()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ManifestoSection()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Manifesto")
                }
            HowItWorksTab()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("How It Works")
                }
        }
    }
}
