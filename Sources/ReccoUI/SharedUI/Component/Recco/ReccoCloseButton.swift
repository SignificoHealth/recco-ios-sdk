//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 14/6/23.
//

import SwiftUI

struct ReccoCloseButton: View {
    var closeAction: () -> Void
    
    var body: some View {
        Button {
            closeAction()
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.reccoPrimary)
                .frame(width: .M * 2, height: .M * 2)
                .background(
                    Color.reccoLightGray
                )
                .clipShape(Circle())
        }

    }
}

struct ReccoCloseButton_Previews: PreviewProvider {
    static var previews: some View {
        ReccoCloseButton(closeAction: {})
    }
}
