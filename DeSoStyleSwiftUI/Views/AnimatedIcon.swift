// AnimatedIcon.swift
// Animated SF Symbol icon with floating and scaling effect.
import SwiftUI

struct AnimatedIcon: View {
    let systemName: String
    let color: Color
    let delay: Double
    @State private var float = false
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .foregroundColor(color)
            .opacity(0.85)
            .frame(width: 40, height: 40)
            .offset(y: float ? -12 : 12)
            .scaleEffect(float ? 1.1 : 0.95)
            .animation(Animation.easeInOut(duration: 2.2).repeatForever(autoreverses: true).delay(delay), value: float)
            .onAppear { float = true }
    }
} 