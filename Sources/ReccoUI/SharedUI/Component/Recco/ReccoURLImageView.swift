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
import Kingfisher
#endif

enum ReccoURLImageDownsample {
    case size(CGSize)
    //    case width(CGFloat)
    //    case height(CGFloat)
}

struct ReccoURLImageView<
    ErrorView: View,
    LoadingView: View,
    NewImageView: View
>: View {
    init(
        url: URL?,
        alt: String? = nil,
        downSampleSize: ReccoURLImageDownsample? = nil,
        @ViewBuilder errorView: @escaping () -> ErrorView,
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder transformView: @escaping (Image) -> NewImageView
    ) {
        self.downSampleSize = downSampleSize
        self.url = url
        self.alt = alt
        self.errorView = errorView
        self.loadingView = loadingView
        self.transformView = transformView
    }

    var downSampleSize: ReccoURLImageDownsample?
    var url: URL?
    var alt: String?
    var transformView: (Image) -> NewImageView
    var errorView: () -> ErrorView
    var loadingView: () -> LoadingView

    private var dynamicUrl: URL? {
        let actualSize: CGSize? = downSampleSize.flatMap { size in
            if case let .size(value) = size { return value }
            return nil
        }
        
        return url.flatMap {
            constructDynamicImageUrl(url: $0.absoluteString, downSampleSize: actualSize)
        }
    }
    
#if canImport(NukeUI)
    var body: some View {
        LazyImage(
            url: dynamicUrl
        ) { state in
            if let image = state.image {
                transformView(image)
            } else if state.error != nil {
                errorView()
            } else {
                loadingView()
            }
        }
        .accessibilityLabel(alt ?? "")
    }
#elseif canImport(Kingfisher)
    var body: some View {
        KFImage
            .url(dynamicUrl)
            .resizable()
            .placeholder { _ in
                loadingView()
            }
            .scaledToFill()
            .accessibilityLabel(alt)
    }
#endif
    func constructDynamicImageUrl(url: String, downSampleSize: CGSize?) -> URL? {
        var (standardWidth, standardHeight) = downSampleSize != nil
        ? mapToStandardSize(viewSize: downSampleSize!.inPixels)
        : (1080, 1080)
        
        standardWidth *= Int(UIScreen.main.nativeScale)
        standardHeight *= Int(UIScreen.main.nativeScale)

        let quality = 70
        let format = "webp"
        let fit = "cover"

        var components = URLComponents(string: url)
        components?.queryItems = [
            URLQueryItem(name: "width", value: "\(standardWidth)"),
            URLQueryItem(name: "height", value: "\(standardHeight)"),
            URLQueryItem(name: "quality", value: "\(quality)"),
            URLQueryItem(name: "format", value: format),
            URLQueryItem(name: "fit", value: fit)
        ]
        
        return components?.url
    }
    
    func mapToStandardSize(viewSize: CGSize) -> (Int, Int) {
        let standardWidth = mapDimensionToStandardSize(dimension: viewSize.width)
        let standardHeight = mapDimensionToStandardSize(dimension: viewSize.height)
        return (standardWidth, standardHeight)
    }

    func mapDimensionToStandardSize(dimension: CGFloat) -> Int {
        let maxServerSize = 1080

        switch dimension {
        case 0..<640:
            return 320
        case 640..<930:
            return 640
        case 930..<CGFloat(maxServerSize):
            return 930
        default:
            return maxServerSize
        }
    }
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
