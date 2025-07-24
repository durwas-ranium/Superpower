// HowItWorksTab.swift
// Tab for displaying both horizontal and vertical 'How It Works' sections.
import SwiftUI

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