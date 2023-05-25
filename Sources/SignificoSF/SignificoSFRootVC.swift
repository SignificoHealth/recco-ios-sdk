//
//  File.swift
//  
//
//  Created by Adrián R on 25/5/23.
//

import Foundation
import SwiftUI
import DashboardFeature

public var SignificoSFRootVC: UIViewController {
    UIHostingController(rootView: SignificoSFRootView())
}

public struct SignificoSFRootView: View {
    public init() {}
    
    public var body: some View {
        DashboardView()
    }
}
