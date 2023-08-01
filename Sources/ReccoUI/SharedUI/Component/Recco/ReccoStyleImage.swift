//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 28/7/23.
//

import SwiftUI

struct ReccoStyleImage: View {
    var name: String
    var resizable: Bool = false
    
    @ViewBuilder
    private func resizable(_ image: Image, renderinMode: Image.TemplateRenderingMode = .template) -> some View {
        if resizable {
            image
                .resizable()
                .renderingMode(renderinMode)
        } else {
            image
                .renderingMode(renderinMode)
        }
    }
    
    var body: some View {
        resizable(
            Image(resource: "\(name)_static"),
            renderinMode: .original
        )
        .overlay(
            resizable(Image(resource: "\(name)_fill"))
                .foregroundColor(Color.reccoIllustration)
                .overlay(
                    resizable(
                        Image(resource: "\(name)_outline")
                    )
                    .foregroundColor(Color.reccoIllustrationLine)
                )
        )
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ReccoStyleImage(
            name: "potted_plant"
        )
    }
}
