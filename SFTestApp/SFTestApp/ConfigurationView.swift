//
//  ConfigurationView.swift
//  SFTestApp
//
//  Created by Adrián R on 1/6/23.
//

import SwiftUI
import SignificoSF

struct LoginError: LocalizedError {
    var errorDescription: String? {
        "There was en error"
    }
}
struct ConfigurationView: View {
    init(user: Binding<String>) {
        self._user = user
        self.userText = user.wrappedValue
    }
    
    @Binding var user: String
    
    @State private var userText: String
    @State var loginLoading: Bool = false
    @State var logoutLoading: Bool = false
    @State var errorOcurred: Bool = false
    
    var body: some View {
        Form {
            Section {
                Text("Current user").font(.headline)
                TextField("User name or id", text: $userText)
                
                HStack {
                    Button {
                        loginLoading = true
                        Task {
                            do {
                                try await SignificoSF.login(user: userText)
                                user = userText
                            } catch {
                                errorOcurred = true
                            }
                            loginLoading = false
                        }
                    } label: {
                        HStack {
                            Text("Log in")
                        }
                    }
                    
                    Spacer()
                    if loginLoading {
                        ProgressView()
                    }
                }
                
                HStack {
                    Button {
                        logoutLoading = true
                        Task {
                            do {
                                try await SignificoSF.logout()
                                user = ""
                                userText = ""
                            } catch {
                                errorOcurred = true
                            }
                            logoutLoading = false
                        }
                    } label: {
                        HStack {
                            Text("Log out")
                        }
                    }
                    
                    Spacer()
                    
                    if logoutLoading {
                        ProgressView()
                    }
                }
            }
            .alert(isPresented: $errorOcurred) {
                Alert(title: Text("An error ocurred"))
            }
        }
        .navigationTitle("Configuration")
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView(user: .constant(""))
    }
}
