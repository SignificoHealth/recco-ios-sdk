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

    #if canImport(NukeUI)
    var body: some View {
        let actualSize: CGSize? = downSampleSize.flatMap { size in
            if case let .size(value) = size { return value }
            return nil
        }
        
        let dynamicUrl = url.flatMap {
            constructDynamicImageUrl(url: $0.absoluteString, downSampleSize: actualSize)
        }
        
        LazyImage(
            url: url
        ) { state in
            if let image = state.image {
                transformView(image)
            } else if state.error != nil {
                errorView()
            } else {
                loadingView()
            }
        }
        .processors(
            downSampleSize.map { type in
                switch type {
                //                case let .height(height):
                //                    return [.resize(height: height)]
                //                case let .width(width):
                //                    return [.resize(width: width)]
                case let .size(size):
                    return [.resize(size: size)]
                }
            }
        )
        .accessibilityHint(alt ?? "")
        .accessibilityLabel(alt ?? "")
        .onAppear(perform: {
            print("URL: \(dynamicUrl)")
        })
    
    }
    #elseif canImport(Kingfisher)
    var body: some View {
        let actualSize: CGSize? = downSampleSize.flatMap { size in
              if case let .size(value) = size { return value }
              return nil
          }
          
          let dynamicUrl = url.flatMap {
              constructDynamicImageUrl(url: $0.absoluteString, downSampleSize: actualSize)
          }
        KFImage
            .url(dynamicUrl)
            .resizable()
            .setProcessors(
                downSampleSize.map { type in
                    switch type {
                    case let .size(size):
                        let newSize = CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale)
                        return [DownsamplingImageProcessor(size: newSize)]
                    }
                } ?? []
            )
            .placeholder { _ in
                loadingView()
            }
            .scaledToFill()
            .accessibilityHint(alt)
            .accessibilityLabel(alt)
    }
    #endif
    
    func constructDynamicImageUrl(url: String, downSampleSize: CGSize?) -> URL? {
        let (standardWidth, standardHeight) = downSampleSize != nil
        ? mapToStandardSize(viewSize: downSampleSize!.inPixels)
        : (1080, 1080)
        
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
        case 0..<120:
            return 60
        case 120..<320:
            return 120
        case 320..<640:
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
