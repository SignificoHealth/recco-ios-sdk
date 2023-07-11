import SwiftUI
import ReccoHeadless

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
        
    var body: some View {
        ReccoLoadingView(viewModel.isLoading) {
            RefreshableScrollView(
                refreshAction: viewModel.getFeedItems
            ) {
                LazyVStack(alignment: .leading, spacing: .XXS) {
                    DashboardHeader(
                        dismiss: viewModel.dismiss,
                        onBookmarks: viewModel.goToBookmarks
                    )
                    
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
            .reccoAlert(
                showWhenPresent: $viewModel.lockedSectionAlert,
                body: unlockAlert
            )
        }
        .reccoErrorView(
            error: $viewModel.initialLoadError,
            onRetry: { await viewModel.getFeedItems() },
            onClose: viewModel.dismiss
        )
        .background(
            Color.reccoBackground.ignoresSafeArea()
        )
        .showNavigationBarOnScroll()
        .addCloseSDKToNavbar(viewModel.dismiss)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.goToBookmarks()
                } label: {
                    Image(resource: "bookmark_filled")
                        .renderingMode(.template)
                        .foregroundColor(Color.reccoAccent)
                }
            }
        }
        .navigationTitle("dashboard.title".localized)
    }
    
    private func unlockAlert(for section: FeedSection) -> ReccoAlert<some View> {
        ReccoAlert(
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
    var dismiss: () -> Void
    var onBookmarks: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    onBookmarks()
                } label: {
                    Image(resource: "bookmark_filled")
                        .renderingMode(.template)
                        .foregroundColor(Color.reccoAccent)
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(resource: "close_ic")
                        .renderingMode(.template)
                        .foregroundColor(.reccoPrimary)
                }
            }
            .padding(.M)
            
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
                    .foregroundColor(Color.reccoIllustration80)
                    .overlay(Image(resource: "flower_outline"))
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardHeader(dismiss: {}, onBookmarks: {})
        
        withAssembly { r in
            DashboardView(viewModel: r.get())
        }
    }
}
