//
//  ContentView.swift
//  DeSoStyleSwiftUI
//
//  Created by Durvas Shende on 24/07/25.
//

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

struct HomeTab: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SuperpowerHeroView()
                    .frame(maxWidth: .infinity, minHeight: 500, maxHeight: 700)
                FeaturesSection()
                    .frame(maxWidth: .infinity)
                TestimonialsSection()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// Ensure only one definition of HowItWorksTab exists:
struct HowItWorksTab: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HowItWorksSection()
                    .frame(maxWidth: .infinity)
                HowItWorksVerticalSection()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

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

struct BiomarkersBar: View {
    let animate: Bool
    @State private var fill: CGFloat = 0
    @State private var counter: Int = 0
    let maxValue: Int = 100
    let icons: [(String, Color)] = [
        ("heart.fill", .red),
        ("drop.fill", .blue),
        ("bolt.heart.fill", .purple),
        ("leaf.fill", .green),
        ("flame.fill", .orange),
        ("brain.head.profile", .yellow)
    ]
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 24)
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.green, Color.orange, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: fill, height: 24)
                    .animation(.easeOut(duration: 1.6), value: fill)
                HStack(spacing: 0) {
                    ForEach(Array(icons.enumerated()), id: \ .offset) { idx, icon in
                        Image(systemName: icon.0)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(icon.1 as? Color ?? .white)
                            .opacity(fill > CGFloat(idx) / CGFloat(icons.count) * 260 ? 1 : 0.3)
                            .scaleEffect(fill > CGFloat(idx) / CGFloat(icons.count) * 260 ? 1.1 : 0.9)
                            .animation(.spring(response: 0.7, dampingFraction: 0.7).delay(Double(idx) * 0.12), value: fill)
                    }
                }
                .padding(.leading, 12)
            }
            .frame(height: 32)
            .frame(maxWidth: 320)
            .padding(.vertical, 8)
            HStack {
                Spacer()
                Text("\(counter)+ Lab Markers")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
            }
            .frame(maxWidth: 320)
        }
        .onAppear {
            if animate {
                withAnimation(.easeOut(duration: 1.6)) {
                    fill = 260
                }
                // Animate counter
                Timer.scheduledTimer(withTimeInterval: 0.012, repeats: true) { timer in
                    if counter < maxValue {
                        counter += 1
                    } else {
                        timer.invalidate()
                    }
                }
            }
        }
    }
}

struct BiomarkersInRangeBar: View {
    @State private var fill: CGFloat = 0
    @State private var counter: Int = 0
    let maxValue: Int = 100
    let inRange: Int = 92
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 8) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 20)
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: fill, height: 20)
                        .animation(.easeOut(duration: 1.2), value: fill)
                }
                .frame(height: 28)
                .frame(maxWidth: 320)
                .padding(.vertical, 4)
                HStack {
                    Spacer()
                    Text("\(counter)/\(maxValue) In Range")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }
                .frame(maxWidth: 320)
            }
            .onAppear {
                let barWidth = geo.size.width * CGFloat(inRange) / CGFloat(maxValue)
                withAnimation(.easeOut(duration: 1.2)) {
                    fill = barWidth
                }
                // Animate counter
                counter = 0
                Timer.scheduledTimer(withTimeInterval: 0.014, repeats: true) { timer in
                    if counter < inRange {
                        counter += 1
                    } else {
                        timer.invalidate()
                    }
                }
            }
        }
        .frame(height: 48)
    }
}

struct PhysicalHealthCurve: View {
    @State private var progress: CGFloat = 0
    let score: Int = 83
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 8) {
                ZStack(alignment: .bottomLeading) {
                    PhysicalHealthCurveShape(progress: 1)
                        .stroke(Color.white.opacity(0.18), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(height: 60)
                    PhysicalHealthCurveShape(progress: progress)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.green]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(height: 60)
                        .animation(.easeOut(duration: 1.4), value: progress)
                }
                .frame(maxWidth: 320)
                .padding(.vertical, 4)
                HStack {
                    Spacer()
                    Text("Health Score: \(score)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }
                .frame(maxWidth: 320)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.4)) {
                    progress = 1
                }
            }
        }
        .frame(height: 72)
    }
}

struct PhysicalHealthCurveShape: Shape {
    var progress: CGFloat // 0 to 1
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        // Draw a smooth curve (Bezier) from left to right
        path.move(to: CGPoint(x: 0, y: height * 0.8))
        path.addCurve(to: CGPoint(x: width, y: height * 0.2),
                      control1: CGPoint(x: width * 0.3, y: height * 0.1),
                      control2: CGPoint(x: width * 0.7, y: height * 1.1))
        return path.trimmedPath(from: 0, to: progress)
    }
}

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

struct TestimonialsSection: View {
    struct Testimonial: Identifiable {
        let id = UUID()
        let name: String
        let title: String
        let quote: String
        let avatar: String // system image or placeholder
        let color: Color
    }
    let testimonials: [Testimonial] = [
        Testimonial(name: "Dr Anant Vinjamoori, MD", title: "Superpower Chief Longevity Officer, Harvard MD & MBA", quote: "Superpower is revolutionizing preventive health. The depth of data and care is unmatched.", avatar: "person.crop.circle.fill", color: .blue),
        Testimonial(name: "Giannis Antetokounmpo", title: "NBA Player, Milwaukee Bucks", quote: "I trust Superpower to keep me at my peak, on and off the court.", avatar: "sportscourt.fill", color: .green),
        Testimonial(name: "Vanessa Hudgens", title: "Actress & Singer", quote: "Superpower makes it easy to track my health and feel my best every day.", avatar: "star.circle.fill", color: .purple),
        Testimonial(name: "Dr Leigh Erin Connealy, MD", title: "Founder, Centre for New Medicine", quote: "The most comprehensive health platform I've seen for patients and doctors alike.", avatar: "cross.case.fill", color: .orange),
        Testimonial(name: "Steve Aoki", title: "Producer & DJ", quote: "Superpower helps me optimize my energy and performance on tour.", avatar: "music.note.list", color: .pink)
    ]
    @State private var appeared = false
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("Trusted by the best")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 32)
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 320), spacing: 24)
            ], spacing: 24) {
                ForEach(Array(testimonials.enumerated()), id: \ .element.id) { idx, t in
                    TestimonialCard(testimonial: t, appeared: appeared, delay: Double(idx) * 0.18)
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

struct TestimonialCard: View {
    let testimonial: TestimonialsSection.Testimonial
    let appeared: Bool
    let delay: Double
    @State private var float = false
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(testimonial.color.opacity(0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: testimonial.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(testimonial.color)
                    .offset(y: float ? -8 : 8)
                    .animation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: float)
            }
            Text(testimonial.name)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text(testimonial.title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Text("\"" + testimonial.quote + "\"")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            Spacer()
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: testimonial.color.opacity(0.13), radius: 12, x: 0, y: 6)
        .scaleEffect(appeared ? 1 : 0.85)
        .rotationEffect(.degrees(appeared ? 0 : (testimonial.color == .blue ? 8 : -8)))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 60)
        .animation(.spring(response: 0.7, dampingFraction: 0.7).delay(delay), value: appeared)
        .onAppear { float = true }
    }
}

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
            // Removed vertical line animation
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
