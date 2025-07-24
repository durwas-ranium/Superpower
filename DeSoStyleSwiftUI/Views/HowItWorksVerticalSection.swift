// HowItWorksVerticalSection.swift
// Displays the vertical timeline/stepper for 'How It Works' with animated steps.
import SwiftUI

struct HowItWorksVerticalSection: View {
    struct Step: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let description: String
        let color: Color
    }
    let steps: [Step] = [
        Step(icon: "person.crop.circle.badge.plus", title: "Sign Up", description: "Book your first lab draw at home or in-person.", color: .blue),
        Step(icon: "drop.fill", title: "Day 1", description: "Test 100+ labs and visualize your data.", color: .purple),
        Step(icon: "folder.fill", title: "Week 1", description: "Store all your medical records in one place.", color: .green),
        Step(icon: "list.bullet.rectangle.portrait.fill", title: "After 10 Days", description: "Get a personalized action plan and protocol.", color: .orange),
        Step(icon: "message.fill", title: "Available 24/7", description: "Message your private medical team anytime.", color: .yellow)
    ]
    @State private var appeared = false
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("How it works (Timeline)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 32)
            VStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \ .element.id) { idx, step in
                    HowItWorksVerticalStep(step: step, appeared: appeared, delay: Double(idx) * 0.18)
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

struct HowItWorksVerticalStep: View {
    let step: HowItWorksVerticalSection.Step
    let appeared: Bool
    let delay: Double
    @State private var float = false
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            ZStack {
                Circle()
                    .fill(step.color.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: step.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(step.color)
                    .offset(y: float ? -6 : 6)
                    .animation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: float)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(step.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text(step.description)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 32)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 60)
        .scaleEffect(appeared ? 1 : 0.85)
        .animation(.spring(response: 0.7, dampingFraction: 0.7).delay(delay), value: appeared)
        .onAppear { float = true }
    }
} 