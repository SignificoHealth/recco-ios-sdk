//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 1/8/23.
//

import SwiftUI
#if canImport(NukeUI)
import NukeUI
#elseif canImport(Kingfisher)
#endif

enum ReccoURLImageDownsample {
    case size(CGSize)
    case width(CGFloat)
    case height(CGFloat)
}

struct ReccoURLImageView<
        ErrorView: View,
        LoadingView: View,
        NewImageView: View
>: View {
    init(
        url: URL?,
        downSampleSize: ReccoURLImageDownsample? = nil,
        @ViewBuilder errorView: @escaping () -> ErrorView,
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder transformView: @escaping (Image) -> NewImageView
    ) {
        self.downSampleSize = downSampleSize
        self.url = url
        self.errorView = errorView
        self.loadingView = loadingView
        self.transformView = transformView
    }
    
    var downSampleSize: ReccoURLImageDownsample?
    var url: URL?
    var transformView: (Image) -> NewImageView
    var errorView: () -> ErrorView
    var loadingView: () -> LoadingView
    
    #if canImport(NukeUI)
    var body: some View {
        LazyImage(
            url: url
        ) { state in
            if let image = state.image {
                transformView(image)
            } else if state.error != nil {
                Color.reccoPrimary20.overlay(
                    Image(resource: "error_image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .addBlackOpacityOverlay()
            } else {
                ReccoImageLoadingView(feedItem: false)
                    .scaledToFill()
                    .addBlackOpacityOverlay()
            }
        }
        .processors(
            downSampleSize.map { type in
                switch type {
                case let .height(height):
                    return [.resize(height: height)]
                case let .width(width):
                    return [.resize(width: width)]
                case let .size(size):
                    return [.resize(size: size)]
                }
            }
        )
    }
    #elseif canImport(Kingfisher)
    var body: some View {
        Text("Hello, World!")
    }
    #endif
}

struct ReccoURLImageView_Previews: PreviewProvider {
    static var previews: some View {
        ReccoURLImageView(
            url: URL(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg")
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

    }
}
