//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 25/5/23.
//

import SwiftUI
import SFSharedUI
import SFEntities

public struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    
    public init(viewModel: DashboardViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        SFLoadingView(viewModel.isLoading) {
            RefreshableScrollView(
                refreshAction: viewModel.getFeedItems
            ) {
                VStack(alignment: .leading, spacing: .XXS) {
                    DashboardHeader()
                    
                    ForEach(viewModel.sections, id: \.self) { section in
                        FeedSectionView(
                            performedUnlockAnimation: .init(get: {
                                viewModel.unlockAnimationsDone[section.section.type, default: true]
                            }, set: { new in
                                viewModel.unlockAnimationsDone[section.section.type] = new
                            }),
                            section: section,
                            items: viewModel.items[section.section.type, default: []],
                            goToDetail: viewModel.goToDetail,
                            pressedLockedSection: viewModel.pressedLocked
                        )
                    }
                }
                .padding(.bottom, .M)
            }
            .sfAlert(
                showWhenPresent: $viewModel.lockedSectionAlert,
                body: unlockAlert
            )
        }
        .sfErrorView(
            error: $viewModel.initialLoadError,
            onRetry: { await viewModel.getFeedItems() },
            onClose: viewModel.dismiss
        )
        .background(
            Color.sfBackground.ignoresSafeArea()
        )
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.sfPrimary)
                }
            }
        }
        .navigationBarHidden(false)
        .task {
            if viewModel.items.isEmpty {
                await viewModel.getFeedItems()
            }
        }
    }
    
    private func unlockAlert(for section: FeedSection) -> SFAlert<some View> {
        SFAlert(
            isPresent: $viewModel.lockedSectionAlert.isPresent(),
            title: section.type.recName,
            text: section.type.description,
            buttonText: "dashboard.unlockSection.button".localized,
            header: {
                Image(resource: "digital_people")
                    .frame(minHeight: 238, alignment: .bottom)
            },
            action: viewModel.pressedUnlockSectionStart
        )
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
