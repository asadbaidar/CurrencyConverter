//
//  VExpanded.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 07/02/2023.
//

import Foundation
import SwiftUI

struct VExpanded<Content> : View where Content : View {
    public var background: Color = Color(.tertiarySystemGroupedBackground)
    @ViewBuilder public var content: () -> Content
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                content()
                Spacer()
            }
            Spacer()
        }
        .background(background)
    }
}

struct VExpanded_Previews: PreviewProvider {
    static var previews: some View {
        VExpanded {}
    }
}
