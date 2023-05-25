//
//  ContentView.swift
//  SFTestApp
//
//  Created by Adrián R on 25/5/23.
//

import SwiftUI
import SignificoSF

struct ContentView: View {
    var body: some View {
        VStack {
            SignificoSFRootView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
