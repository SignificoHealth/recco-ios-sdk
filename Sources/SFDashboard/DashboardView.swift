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
        NavigationView {
            SFLoadingView(viewModel.isLoading) {
                RefreshableScrollView(
                    refreshAction: viewModel.getFeedItems) {
                        VStack(alignment: .leading) {
                            DashboardHeader()
                            
                            ForEach(viewModel.sections, id: \.self) { section in
                                FeedSectionView(
                                    section: section,
                                    items: viewModel.items[section.section, default: []],
                                    goToDetail: viewModel.goToDetail
                                )
                            }
                        }
                        .padding(.vertical, .M)
                    }
            }
            .errorView(error: $viewModel.initialLoadError, onRetry: viewModel.getFeedItems)
            .padding(.top, .M)
            .background(Color.sfBackground)
            .navigationBarHidden(true)
        }
    }
}

struct DashboardHeader: View {
    var body: some View {
        HStack(alignment: .top, spacing: .XS) {
            VStack(alignment: .leading) {
                Text("dashboard.title".localized)
                    .h1()
                Text("dashboard.subtitle".localized)
                    .body1()
            }
            .padding(.leading, .M)
            
            Spacer()
            
            Image(resource: "flower_fill")
                .renderingMode(.template)
                .foregroundColor(Color.sfIllustration80)
                .overlay(Image(resource: "flower_outline"))
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardHeader()
        
        withAssembly { r in
            DashboardView(viewModel: r.get())
        }
    }
}
