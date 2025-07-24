// HomeTab.swift
// Displays the main landing page with hero, features, and testimonials sections.
import SwiftUI

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