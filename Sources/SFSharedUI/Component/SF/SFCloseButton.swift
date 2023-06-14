//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 14/6/23.
//

import SwiftUI

struct SFCloseButton: View {
    var closeAction: () -> Void
    
    var body: some View {
        Button {
            closeAction()
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.sfPrimary)
                .frame(width: .M * 2, height: .M * 2)
                .background(
                    Color.sfLightGray
                )
                .clipShape(Circle())
        }

    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SFCloseButton(closeAction: {})
    }
}
