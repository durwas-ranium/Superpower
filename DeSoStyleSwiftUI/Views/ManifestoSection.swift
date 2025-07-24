// ManifestoSection.swift
// Displays the animated Manifesto tab with a rotating radial bar ring and central image.
import SwiftUI

struct ManifestoSection: View {
    @State private var appeared = false
    @State private var isScrolling = false
    let lines = [
        "We believe everyone deserves access to the best health insights and care.",
        "Superpower is on a mission to empower you with data, knowledge, and a world-class medical team—",
        "so you can live your best, healthiest life."
    ]
    var body: some View {
        ZStack {
            AnimatedGradientBackground()
            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 60)
                    HStack(spacing: 16) {
                        AnimatedIcon(systemName: "heart.fill", color: .red, delay: 0.1)
                        Text("Manifesto")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 40)
                            .scaleEffect(appeared ? 1 : 0.85)
                            .animation(.spring(response: 0.7, dampingFraction: 0.7), value: appeared)
                        AnimatedIcon(systemName: "bolt.fill", color: .yellow, delay: 0.2)
                    }
                    VStack(spacing: 20) {
                        ForEach(Array(lines.enumerated()), id: \ .offset) { idx, line in
                            Text(line)
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .opacity(appeared ? 1 : 0)
                                .offset(y: appeared ? 0 : 40)
                                .scaleEffect(appeared ? 1 : 0.95)
                                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2 + Double(idx) * 0.18), value: appeared)
                        }
                    }
                    ZStack {
                        RotatingRadialBarRing(isRotating: !isScrolling)
                            .frame(width: 340, height: 340)
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.18)))
                            .clipShape(Circle())
                            .frame(width: 180, height: 180)
                            .shadow(radius: 16)
                    }
                    .padding(.top, 8)
                    AnimatedIcon(systemName: "sparkles", color: .white, delay: 0.5)
                        .frame(width: 48, height: 48)
                    Button(action: {}) {
                        Text("Join the Movement")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 40)
                            .background(Color.white.opacity(0.15))
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .cornerRadius(32)
                            .shadow(radius: 8)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 40)
                            .scaleEffect(appeared ? 1 : 0.9)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.7), value: appeared)
                    }
                    Spacer()
                }
                .padding(.vertical, 32)
                .onAppear { appeared = true }
            }
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { _ in isScrolling = true }
                    .onEnded { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isScrolling = false
                        }
                    }
            )
        }
    }
} 