import SwiftUI

struct FinishQuestionnaireButtonView: View {
    var body: some View {
        ZStack {
            Color.reccoPrimary

            VStack(spacing: .XXS) {
                Image(resource: "reload_ic")
                    .renderingMode(.template)
                    .foregroundColor(.reccoOnPrimary)

                Text("recco_dashboard_review_area".localized)
                    .foregroundColor(.reccoOnPrimary)
                    .h3()
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: .cardSize.width)
        .clipShape(
            RoundedRectangle(cornerRadius: .XXS)
        )
    }
}

struct FinishQuestionnaireButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FinishQuestionnaireButtonView()
    }
}
