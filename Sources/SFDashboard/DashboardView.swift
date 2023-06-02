//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 25/5/23.
//

import SwiftUI
import SFSharedUI

public struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    
    public init(viewModel: DashboardViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack {
            Text("Hola Significo")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            DashboardView(viewModel: r.get())
        }
    }
}
