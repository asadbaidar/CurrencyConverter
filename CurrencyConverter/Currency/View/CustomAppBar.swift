//
//  CustomAppBar.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 07/02/2023.
//

import Foundation
import SwiftUI

struct CustomAppBar<Content> : View where Content : View {
    @ViewBuilder public var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16, content: content)
            .padding()
            
            Divider()
        }
    }
}

struct CustomAppBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomAppBar {}
    }
}
