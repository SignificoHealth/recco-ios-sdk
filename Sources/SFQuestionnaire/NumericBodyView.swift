//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 16/6/23.
//

import SwiftUI
import SFEntities

struct NumericBodyView: View {
    let question: NumericQuestion
    
    var body: some View {
        Text("Numeric!")
    }
}

struct NumericBodyView_Previews: PreviewProvider {
    static var previews: some View {
        NumericBodyView(question: .init(maxValue: 0, minValue: 10, format: .decimal))
    }
}
