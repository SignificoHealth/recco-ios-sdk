import ReccoHeadless
import SwiftUI

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
                            goToQuestionnaire: viewModel.goToQuestionnaire,
                            pressedLockedSection: viewModel.pressedLocked
                        )
                    }
                }
                .padding(.bottom, .M)
            }
            .accentColor(.reccoPrimary)
            .reccoAlert(
                showWhenPresent: $viewModel.lockedSectionAlert,
                body: unlockAlert
            )
        }
        .reccoErrorView(
            error: $viewModel.initialLoadError,
            onRetry: { await viewModel.getFeedItems() }
        )
        .background(
            Color.reccoBackground.ignoresSafeArea()
        )
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
    }

    private func unlockAlert(for section: FeedSection) -> ReccoAlert<some View> {
        ReccoAlert(
            isPresent: $viewModel.lockedSectionAlert.isPresent(),
            title: section.type.recName,
            text: section.type.description,
            buttonText: "recco_start".localized,
            header: {
                ReccoTopicImageView(topic: section.topic)
                    .padding(.horizontal, .XL)
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
			HStack(alignment: .top, spacing: .XS) {
				VStack(alignment: .leading, spacing: .XXXS) {
					Text("recco_dashboard_welcome_back_title".localized)
						.h1()
					Text("recco_dashboard_welcome_back_body".localized)
						.body1()
				}
				.padding(.leading, .M)

				Spacer()

				ReccoStyleImage(name: "potted_plant")
			}
		}
	}
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.reccoBackground
            DashboardHeader(dismiss: {}, onBookmarks: {})
        }
        withAssembly { r in
            DashboardView(viewModel: r.get())
        }
    }
}
