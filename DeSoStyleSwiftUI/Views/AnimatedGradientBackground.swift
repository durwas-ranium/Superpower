// AnimatedGradientBackground.swift
// Animated background gradient for hero and manifesto sections.
import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animate = false
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            Color(red: 0.2, green: 0.3, blue: 0.8),
            Color(red: 0.5, green: 0.1, blue: 0.7),
            Color(red: 0.1, green: 0.7, blue: 0.8),
            Color(red: 0.9, green: 0.7, blue: 0.2)
        ]), startPoint: animate ? .topLeading : .bottomTrailing, endPoint: animate ? .bottomTrailing : .topLeading)
            .animation(Animation.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
            .onAppear { animate = true }
            .ignoresSafeArea()
    }
} 