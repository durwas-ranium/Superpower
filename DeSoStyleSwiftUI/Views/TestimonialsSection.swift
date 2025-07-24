// TestimonialsSection.swift
// Displays the animated testimonials grid and testimonial cards.
import SwiftUI

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