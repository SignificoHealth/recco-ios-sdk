//
//  UI.swift
//  ReccoShowcase
//
//  Created by Carmelo J Cortés Alhambra on 6/7/23.
//

import SwiftUI

extension Color {
    static var lightGray: Color = .init(red: 0.92, green: 0.92, blue: 0.92)
    static var warmBrown: Color = .init(red: 0.27, green: 0.22, blue: 0.22)
    static var softYellow: Color = .init(red: 0.96, green: 0.95, blue: 0.56)
}

extension Text {
    func bodyBig() -> some View {
        return self
            .font(.system(size: 18, weight: .regular))
            .lineSpacing(3.5)
            .foregroundColor(.warmBrown)
    }
    
    func bodySmall() -> some View {
        return self
            .font(.system(size: 15, weight: .regular))
            .lineSpacing(3.5)
            .foregroundColor(.warmBrown)
    }
    
    func bodySmallLight() -> some View {
        return self
            .font(.system(size: 15, weight: .light))
            .lineSpacing(3.5)
            .foregroundColor(.warmBrown)
    }
    
    func inputTitle() -> some View {
        return self
            .font(.system(size: 14, weight: .bold))
            .lineSpacing(3.5)
            .foregroundColor(.warmBrown)
    }
}

struct CallToActionPrimaryStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        CallToActionPrimaryStyle.CallToActionPrimaryBody(configuration: configuration)
    }
    
    struct CallToActionPrimaryBody: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: CallToActionPrimaryStyle.Configuration
        
        var body: some View {
            return configuration
                .label
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    configuration.isPressed || !isEnabled ? Color.warmBrown.opacity(0.7) : Color.warmBrown
                )
                .foregroundColor(
                    !isEnabled ? Color.softYellow.opacity(0.7) : Color.softYellow
                )
                .contentShape(Rectangle())
        }
    }
}

struct CallToActionSecondaryStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding()
            .background(configuration.isPressed ? Color.warmBrown.opacity(0.1) : Color.clear)
            .foregroundColor(.warmBrown)
            .contentShape(Rectangle())
            .overlay(Rectangle().stroke(Color.warmBrown, lineWidth: 1))
    }
}
