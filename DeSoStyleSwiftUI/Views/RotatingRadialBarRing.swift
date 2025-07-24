// RotatingRadialBarRing.swift
// Animated circular bar ring with random bar heights, used for biomarker visualization.
import SwiftUI

struct RotatingRadialBarRing: View {
    var isRotating: Bool = true
    @State private var angle: Double = 0
    let barCount: Int = 100
    let minHeight: CGFloat = 28
    let maxHeight: CGFloat = 64
    let barWidth: CGFloat = 4
    let color: Color = Color.orange
    @State private var barHeights: [CGFloat] = []
    var body: some View {
        ZStack {
            ForEach(0..<barCount, id: \ .self) { i in
                Capsule()
                    .fill(i % 20 == 0 ? Color.yellow : color)
                    .frame(width: barWidth, height: barHeights.indices.contains(i) ? barHeights[i] : minHeight)
                    .offset(y: -(170 - (barHeights.indices.contains(i) ? barHeights[i]/2 : minHeight/2)))
                    .rotationEffect(.degrees(Double(i) / Double(barCount) * 360 + angle))
            }
        }
        .onAppear {
            barHeights = (0..<barCount).map { _ in CGFloat.random(in: minHeight...maxHeight) }
            animateRotation()
        }
        .onChange(of: isRotating) { newValue in
            if newValue {
                animateRotation()
            }
        }
    }
    private func animateRotation() {
        guard isRotating else { return }
        withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
            angle = 360
        }
    }
} 