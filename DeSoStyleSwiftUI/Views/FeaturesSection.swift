// FeaturesSection.swift
// Displays the animated features grid and feature cards.
import SwiftUI

struct FeaturesSection: View {
    struct Feature: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let description: String
        let color: Color
    }
    let features: [Feature] = [
        Feature(icon: "heart.fill", title: "Heart Health", description: "Track 20+ heart markers including cholesterol, ApoB, and more.", color: .red),
        Feature(icon: "bolt.heart.fill", title: "Hormones & Energy", description: "Monitor testosterone, estrogen, cortisol, and more.", color: .purple),
        Feature(icon: "leaf.fill", title: "Inflammation & Immunity", description: "Get insights on inflammation, immune health, and recovery.", color: .green),
        Feature(icon: "flame.fill", title: "Metabolism & Weight", description: "Understand your metabolism, blood sugar, and body composition.", color: .orange),
        Feature(icon: "brain.head.profile", title: "Cognition & Mood", description: "Track brain health, focus, and stress markers.", color: .blue)
    ]
    @State private var appeared = false
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("Features")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 32)
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 220), spacing: 24)
            ], spacing: 24) {
                ForEach(Array(features.enumerated()), id: \ .element.id) { idx, feature in
                    FeatureCard(feature: feature, appeared: appeared, delay: Double(idx) * 0.18)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGray6))
        .cornerRadius(32)
        .padding(.vertical, 32)
        .onAppear { appeared = true }
    }
}

struct FeatureCard: View {
    let feature: FeaturesSection.Feature
    let appeared: Bool
    let delay: Double
    @State private var float = false
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(feature.color.opacity(0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: feature.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(feature.color)
                    .offset(y: float ? -8 : 8)
                    .animation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: float)
            }
            Text(feature.title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text(feature.description)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.07), radius: 12, x: 0, y: 6)
        .scaleEffect(appeared ? 1 : 0.85)
        .rotationEffect(.degrees(appeared ? 0 : -8))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 60)
        .animation(.spring(response: 0.7, dampingFraction: 0.7).delay(delay), value: appeared)
        .onAppear { float = true }
    }
} 