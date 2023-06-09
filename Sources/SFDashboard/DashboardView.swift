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
    @Environment(\.presentationMode) private var dismiss

    public init(viewModel: DashboardViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            SFLoadingView(viewModel.isLoading) {
                RefreshableScrollView(
                    refreshAction: viewModel.getFeedItems) {
                        VStack(alignment: .leading, spacing: .XXS) {
                            DashboardHeader(
                                dismiss: { dismiss.wrappedValue.dismiss() }
                            )
                            
                            ForEach(viewModel.sections, id: \.self) { section in
                                FeedSectionView(
                                    section: section,
                                    items: viewModel.items[section.section, default: []],
                                    goToDetail: viewModel.goToDetail
                                )
                            }
                        }
                        .padding(.bottom, .M)
                    }
            }
            .errorView(
                error: $viewModel.initialLoadError,
                onRetry: viewModel.getFeedItems,
                onClose: { dismiss.wrappedValue.dismiss() }
            )
            .background(Color.sfBackground)
            .navigationBarHidden(true)
        }
    }
}

struct DashboardHeader: View {
    var dismiss: () -> Void
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.sfPrimary)
            }
            .padding(.trailing, .M)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.vertical, .M)
            
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
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardHeader(dismiss: {})
        
        withAssembly { r in
            DashboardView(viewModel: r.get())
        }
    }
}
