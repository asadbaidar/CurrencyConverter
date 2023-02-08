//
//  CurrencyMenu.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 06/02/2023.
//

import SwiftUI

struct CurrencyMenu: View {
    public var currencies: [String] = []
    @Binding public var currency: String

    var body: some View {
        Menu {
            ForEach(currencies, id: \.self) { item in
                Button {
                    currency = item
                } label: {
                    Text(item)
                    if(currency == item) {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Text(currency)
                .font(.title2)
                .frame(minWidth: 50)
        }
    }
}

struct CurrencyMenu_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyMenu(
            currencies: ["USD", "PKR"],
            currency: .constant("USD")
        )
    }
}
