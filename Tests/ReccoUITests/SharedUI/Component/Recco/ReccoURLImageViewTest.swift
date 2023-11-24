//
//  File.swift
//  
//
//  Created by Saúl on 24/11/23.
//

@testable import ReccoHeadless
@testable import ReccoUI
import XCTest
import Foundation
import SwiftUI

class ReccoURLImageViewTests: XCTestCase {
    
    struct PlaceholderView: View {
        var body: some View {
            Text("Placeholder")
        }
    }
    
    
    func testConstructDynamicImageUrlFullStructure() {
        let testSize = CGSize(width: 300, height: 300)
        let screenScale = UIScreen.main.nativeScale
        let expectedWidth = Int(testSize.width * screenScale)
        let expectedHeight = Int(testSize.height * screenScale)
        
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

