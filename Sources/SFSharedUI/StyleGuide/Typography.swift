//
//  Typography.swift
//  
//
//  Created by Adrián R on 13/7/22.
//

import Foundation
import SFResources
import SwiftUI

extension Text {
    public func h1() -> some View {
        return self
            .tracking(0.1)
            .font(.custom("SF-Pro", size: 40))
            .lineSpacing(6)
            .foregroundColor(.black)
    }

}
// swiftlint:enable opening_brace
