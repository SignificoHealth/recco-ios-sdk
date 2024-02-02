//
//  File.swift
//
//
//  Created by Adrián R on 1/2/24.
//

import Foundation
import SwiftUI

struct ReccoContentImageView: View {
    var url: URL?
    var alt: String?

    var body: some View {
        if let imageUrl = url {
            ReccoURLImageView(
                url: imageUrl,
                alt: alt,
                downSampleSize: .size(.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.7))
            ) {
                Color.reccoPrimary20.overlay(
                    Image(resource: "error_image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .addBlackOpacityOverlay()
            } loadingView: {
                ReccoImageLoadingView(feedItem: false)
                    .scaledToFill()
                    .addBlackOpacityOverlay()
            } transformView: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .addBlackOpacityOverlay()
            }
        } else {
            ZStack {
                Color.reccoIllustration
                ReccoStyleImage(name: "default_image", resizable: true)
                    .scaledToFill()
            }
        }
    }
}
