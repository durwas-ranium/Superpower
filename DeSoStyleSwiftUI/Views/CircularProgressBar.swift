// CircularProgressBar.swift
// Animated circular progress bar with gradient stroke and counter.
import SwiftUI

struct CircularProgressBar: View {
    let percentage: Double // 0.0 to 1.0
    let label: String
    let icon: String?
    let color: Color
    @State private var animatedPercent: Double = 0
    @State private var counter: Int = 0
    var body: some View {
        ZStack {
            // Pulse effect
            Circle()
                .stroke(color.opacity(0.18), lineWidth: 16)
                .scaleEffect(animatedPercent > 0.95 ? 1.08 : 1)
                .opacity(animatedPercent > 0.95 ? 0.5 : 0)
                .animation(Animation.easeOut(duration: 1.2).repeatForever(autoreverses: true), value: animatedPercent)
            // Background circle
            Circle()
                .stroke(Color.white.opacity(0.13), lineWidth: 12)
            // Foreground animated circle
            Circle()
                .trim(from: 0, to: animatedPercent)
                .stroke(AngularGradient(gradient: Gradient(colors: [color, .blue, .purple, .green, .yellow]), center: .center), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.4), value: animatedPercent)
            VStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(color)
                        .opacity(0.85)
                }
                Text("\(counter)%")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                Text(label)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.4)) {
                animatedPercent = percentage
            }
            // Animate counter
            let target = Int(percentage * 100)
            counter = 0
            Timer.scheduledTimer(withTimeInterval: 0.012, repeats: true) { timer in
                if counter < target {
                    counter += 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }
} 