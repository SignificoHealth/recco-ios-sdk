import Foundation
import SwiftUI

extension Text {
    func h1() -> some View {
        return self
            .kerning(-0.1)
            .font(Font(CurrentReccoStyle.font.uiFont(size: 28, weight: .semibold)))
            .lineSpacing(2)
            .foregroundColor(.reccoPrimary)
    }
    
    func h2() -> some View {
        return self
            .kerning(-0.1)
            .font(Font(CurrentReccoStyle.font.uiFont(size: 24, weight: .medium)))
            .lineSpacing(2)
            .foregroundColor(.reccoPrimary)
    }
    
    func h3() -> some View {
        return self
            .kerning(0.1)
            .font(Font(CurrentReccoStyle.font.uiFont(size: 22, weight: .bold)))
            .lineSpacing(1)
            .foregroundColor(.reccoPrimary)
    }
    
    func h4() -> some View {
        return self
            .kerning(0.1)
            .font(Font(CurrentReccoStyle.font.uiFont(size: 17, weight: .semibold)))
            .lineSpacing(1.5)
            .foregroundColor(.reccoPrimary)
    }
    
    func body1() -> some View {
        return self
            .font(Font(CurrentReccoStyle.font.uiFont(size: 18, weight: .regular)))
            .lineSpacing(3)
            .foregroundColor(.reccoPrimary)
    }
    
    func body1bold() -> some View {
        return self
            .font(Font(CurrentReccoStyle.font.uiFont(size: 18, weight: .semibold)))
            .lineSpacing(3)
            .foregroundColor(.reccoPrimary)
    }
    
    func body2() -> some View {
        return self
            .font(Font(CurrentReccoStyle.font.uiFont(size: 15, weight: .medium)))
            .lineSpacing(3.5)
            .foregroundColor(.reccoPrimary)
    }
    
    func body2bold() -> some View {
        return self
            .font(Font(CurrentReccoStyle.font.uiFont(size: 15, weight: .semibold)))
            .lineSpacing(3.5)
            .foregroundColor(.reccoPrimary)
    }
    
    func body3() -> some View {
        return self
            .font(Font(CurrentReccoStyle.font.uiFont(size: 12, weight: .medium)))
            .lineSpacing(3)
            .foregroundColor(.reccoPrimary)
    }
    
    func cta() -> some View {
        return self
            .font(Font(CurrentReccoStyle.font.uiFont(size: 16, weight: .bold)))
            .lineSpacing(3)
            .foregroundColor(.reccoPrimary)
    }
    
    func labelSmall() -> some View {
        return self
            .font(Font(CurrentReccoStyle.font.uiFont(size: 13, weight: .semibold)))
            .lineSpacing(3.5)
            .foregroundColor(.reccoPrimary)
    }
    
    func contentTitle() -> some View {
        return self
            .kerning(0.1)
            .font(Font(CurrentReccoStyle.font.uiFont(size: 12, weight: .medium)))
            .lineSpacing(3)
            .foregroundColor(.reccoPrimary)
    }
}

struct Typography_Previews: PreviewProvider {
    static var fonts: [(Text) -> AnyView] = [
        { AnyView($0.h1()) },
        { AnyView($0.h2()) },
        { AnyView($0.h3()) },
        { AnyView($0.h4()) },
        { AnyView($0.body1()) },
        { AnyView($0.body1bold()) },
        { AnyView($0.body2()) },
        { AnyView($0.body2bold()) },
        { AnyView($0.body3()) },
        { AnyView($0.cta()) },
        { AnyView($0.labelSmall()) },
        { AnyView($0.contentTitle()) },
    ]
    static var previews: some View {
        let _ = { CurrentReccoStyle.font = .sfPro }()
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<fonts.count, id: \.self) { mod in
                    fonts[mod](
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
                    )
                }
            }
        }
    }
}
