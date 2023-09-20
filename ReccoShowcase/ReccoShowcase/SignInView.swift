//
//  SignInView.swift
//  ReccoShowcase
//
//  Created by Carmelo J Cortés Alhambra on 5/7/23.
//

import ReccoUI
import SwiftUI




struct SignInView: View {
    @AppStorage("username") var username: String = ""
    @State private var input: String = ""
    @State var loginLoading = false
    @State var loginError = false

    var inputView: some View {
        VStack(alignment: .leading) {
            Text("user_id")
                .inputTitle()

            TextField("username", text: $input)
                .font(.system(size: 15, weight: .light))
                .foregroundColor(.warmBrown)
                .keyboardType(.alphabet)
                .autocorrectionDisabled(true)
                .cornerRadius(8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)
                .preferredColorScheme(.light)
        }
    }

    var body: some View {
        VStack(spacing: 32) {
            CompanyView()
                .padding(.top, 75)

            Text("sign_in_text")
                .bodySmall()
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            inputView

            Spacer()

            if loginLoading {
                ProgressView()
            } else {
                Button("login") {
                    hideKeyboard()
                    loginLoading = true
                    Task {
                        do {
                            try await ReccoUI.login(userId: input)
                            username = input
                        } catch {
                            loginError = true
                        }
                        loginLoading = false
                    }
                }
                .buttonStyle(CallToActionPrimaryStyle())
                .disabled(input.isEmpty)
            }
        }
        .padding(24)
        .background(Color.lightGray)
        .alert(isPresented: $loginError) {
            Alert(title: Text("error"))
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
