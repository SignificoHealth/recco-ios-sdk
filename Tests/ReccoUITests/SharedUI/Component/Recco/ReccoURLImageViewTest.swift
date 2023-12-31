//
//  File.swift
//
//
//  Created by Saúl on 24/11/23.
//

import Foundation
@testable import ReccoHeadless
@testable import ReccoUI
import SwiftUI
import XCTest

class ReccoURLImageViewTests: XCTestCase {
    struct PlaceholderView: View {
        var body: some View {
            Text("Placeholder")
        }
    }

    func test_dynamic_url_generatesRightStructure() {
        let testSize = CGSize(width: 300, height: 300)
        let screenScale = UIScreen.main.nativeScale
        let expectedWidth = Int(400 * screenScale) // 300 will land in a standard 400 size
        let expectedHeight = Int(400 * screenScale)

        let imageView = ReccoURLImageView<PlaceholderView, PlaceholderView, PlaceholderView>(
            url: URL(string: "https://example.com/image.jpg"),
            errorView: { PlaceholderView() },
            loadingView: { PlaceholderView() },
            transformView: { _ in PlaceholderView() }
        )

        let resultUrl = imageView.constructDynamicImageUrl(url: "https://example.com/image.jpg", downSampleSize: testSize)

        let expectedUrlString = "https://example.com/image.jpg?width=\(expectedWidth)&height=\(expectedHeight)&quality=70&format=webp&fit=cover"
        XCTAssertEqual(resultUrl?.absoluteString, expectedUrlString, "URL should match expected structure")
    }
}
