//
//  CurrencyTextField.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 06/02/2023.
//

import SwiftUI
import Combine

struct AmountInputField: View {
    public var maxLength: Int = 18
    @Binding public var amount: Double
    
    @State private var text = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("", text: $text)
                .font(.title2)
                .keyboardType(.numberPad)
                .textFieldStyle(PlainTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .disableAutocorrection(true)
                .foregroundColor(.clear)
                .accentColor(.clear)
                .focused($focused)
                .onChange(of: text) { amount = $0.number2f }
                .onReceive(Just(text)) { _ in applyLimit() }
            
            HStack {
                Spacer()
                Text(amount.formatted2f)
                    .font(.title2)
            }
            .contentShape(Rectangle())
            .highPriorityGesture(LongPressGesture().onEnded { _ in })
            .simultaneousGesture(TapGesture().onEnded({ _ in
                focused = !focused
            }))
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                DoneButton()
            }
        }
    }
    
    func applyLimit() {
        if text.count > maxLength {
            text = String(text.prefix(maxLength))
        }
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        AmountInputField(amount: .constant(1))
    }
}

struct DoneButton: View {
    
    public var action: VoidCallback?
    
    var body: some View {
        Button("Done") {
            action?()
            endEditing()
        }
    }
}
