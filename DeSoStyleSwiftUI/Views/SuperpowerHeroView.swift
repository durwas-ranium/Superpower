// SuperpowerHeroView.swift
// Animated hero section for the Superpower app.
import SwiftUI

struct SuperpowerHeroView: View {
    @State private var animate = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedGradientBackground()
                VStack(spacing: 32) {
                    Spacer()
                    VStack(spacing: 16) {
                        Text("Peak health starts now")
                            .font(.system(size: geo.size.width > 600 ? 54 : 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(radius: 8)
                            .opacity(animate ? 1 : 0)
                            .offset(y: animate ? 0 : 40)
                            .animation(.easeOut(duration: 1.0), value: animate)
                        Text("100+ lab tests, results tracked over your life time, and a private medical team. All for just $499.")
                            .font(.system(size: geo.size.width > 600 ? 28 : 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.95))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .opacity(animate ? 1 : 0)
                            .offset(y: animate ? 0 : 40)
                            .animation(.easeOut(duration: 1.0).delay(0.2), value: animate)
                    }
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Text("Join Today")
                                .font(.system(size: geo.size.width > 600 ? 22 : 18, weight: .bold, design: .rounded))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 32)
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(32)
                                .shadow(radius: 8)
                        }
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 40)
                        .animation(.easeOut(duration: 1.0).delay(0.4), value: animate)
                        Button(action: {}) {
                            Text("How It Works")
                                .font(.system(size: geo.size.width > 600 ? 22 : 18, weight: .bold, design: .rounded))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 32)
                                .background(Color.white.opacity(0.15))
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .cornerRadius(32)
                                .shadow(radius: 8)
                        }
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 40)
                        .animation(.easeOut(duration: 1.0).delay(0.6), value: animate)
                    }
                    Spacer()
                }
                .frame(maxWidth: 700)
                .padding(.top, geo.size.height * 0.12)
                .padding(.bottom, geo.size.height * 0.18)
            }
            .onAppear { animate = true }
        }
    }
} 