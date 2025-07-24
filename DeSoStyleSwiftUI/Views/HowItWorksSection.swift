// HowItWorksSection.swift
// Displays the horizontal 'How It Works' stepper with animated cards.
import SwiftUI

struct HowItWorksSection: View {
    struct Step: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let subtitle: String
        let details: String
        let color: Color
    }
    let steps: [Step] = [
        Step(icon: "person.crop.circle.badge.plus", title: "SIGN UP", subtitle: "Book an at-home or in-person lab draw", details: "Get started by booking your first lab draw, either at home or at a local clinic.", color: .blue),
        Step(icon: "drop.fill", title: "DAY 1", subtitle: "Test 100+ labs and visualize all your data", details: "Your first test covers 100+ lab markers. See your results in a beautiful dashboard.", color: .purple),
        Step(icon: "folder.fill", title: "WEEK 1", subtitle: "Store all your medical records in one place", details: "All your health data and records are securely stored and accessible anytime.", color: .green),
        Step(icon: "list.bullet.rectangle.portrait.fill", title: "AFTER 10 DAYS", subtitle: "Get a personalized action plan and protocol", details: "Receive a custom plan from your medical team, tailored to your results.", color: .orange),
        Step(icon: "message.fill", title: "AVAILABLE 24/7", subtitle: "Message your private medical team anytime", details: "Your care team is always available for questions, advice, and support.", color: .yellow)
    ]
    @State private var expandedStep: UUID? = nil
    @State private var appeared = false
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("How it works")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 32)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(Array(steps.enumerated()), id: \ .element.id) { idx, step in
                        HowItWorksCard(step: step, expanded: expandedStep == step.id, appeared: appeared, delay: Double(idx) * 0.18)
                            .frame(width: 300, height: expandedStep == step.id ? 320 : 220)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    expandedStep = expandedStep == step.id ? nil : step.id
                                }
                            }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(32)
        .padding(.vertical, 32)
        .onAppear { appeared = true }
    }
}

struct HowItWorksCard: View {
    let step: HowItWorksSection.Step
    let expanded: Bool
    let appeared: Bool
    let delay: Double
    @State private var float = false
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(step.color.opacity(0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: step.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(step.color)
                    .offset(y: float ? -8 : 8)
                    .animation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: float)
            }
            Text(step.title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text(step.subtitle)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            if expanded {
                Text(step.details)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            Spacer()
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.07), radius: 12, x: 0, y: 6)
        .scaleEffect(appeared ? 1 : 0.85)
        .rotationEffect(.degrees(appeared ? 0 : 8))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 60)
        .animation(.spring(response: 0.7, dampingFraction: 0.7).delay(delay), value: appeared)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: expanded)
        .onAppear { float = true }
    }
} 