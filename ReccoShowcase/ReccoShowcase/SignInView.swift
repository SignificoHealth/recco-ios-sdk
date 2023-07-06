//
//  SignInView.swift
//  ReccoShowcase
//
//  Created by Carmelo J Cortés Alhambra on 5/7/23.
//

import SwiftUI
import ReccoUI

struct SignInView: View {
    
    @AppStorage("username") var username: String = ""
    @State private var input: String = ""
    @State var loginLoading: Bool = false
    @State var loginError: Bool = false
    
    var inputView: some View {
        VStack(alignment: .leading) {
            Text("User ID")
                .inputTitle()
            
            TextField("Username", text: $input)
                .font(.system(size: 15, weight: .light))
                .foregroundColor(.warmBrown)
                .keyboardType(.alphabet)
                .autocorrectionDisabled(true)
                .cornerRadius(8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Please create any User ID you want to be able to identify you as a User in the SDK.")
                .bodySmall()
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            inputView
            
            Spacer()
            
            if loginLoading {
                ProgressView()
            } else {
                Button("Login") {
                    hideKeyboard()
                    loginLoading = true
                    Task {
                        do {
                            try await ReccoUI.login(user: input)
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
            Alert(title: Text("An error ocurred"))
        }
    }
}

/*
struct SignInView: View {
    
    @AppStorage("username") var username: String = ""
    @State private var input: String = ""
    @State var loginLoading: Bool = false
    @State var loginError: Bool = false
    
    var body: some View {

        VStack(spacing: 32) {
            companyView
                .padding(.top, 70)
            
            Text("Please create any User ID you want to be able to identify you as a User in the SDK.")
              .font(
                Font.custom("Poppins", size: 15)
                  .weight(.medium)
              )
              .foregroundColor(Color.warmBrown)
              .frame(maxWidth: .infinity)
            
            inputView
            
            Spacer()
            
            if loginLoading {
                ProgressView()
            } else {
                Button("Login") {
                    hideKeyboard()
                    loginLoading = true
                    Task {
                        do {
                            try await ReccoUI.login(user: input)
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
            Alert(title: Text("An error ocurred"))
        }
    }
    
    var companyView: some View {
        VStack {
            HStack {
                Image("recco_logo")
                Text("by")
            }
            Image("significo_logo")
        }
        .padding(.vertical, 32)
    }
    
    var inputView: some View {
        VStack(alignment: .leading) {
            Text("User ID")
                .bold()
                .foregroundColor(Color.warmBrown)
            
            TextField("Username", text: $input)
                .keyboardType(.alphabet)
                .autocorrectionDisabled(true)
                .cornerRadius(8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
 */

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
