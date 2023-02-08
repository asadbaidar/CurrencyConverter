//
//  CurrencyPageView.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 04/02/2023.
//

import SwiftUI
import Combine

struct CurrencyPageView: View {
    
    @StateObject var bloc = CurrencyBloc()
    
    var body: some View {
        VStack(spacing: 0) {
            CurrencyAppBar()
            
            CurrencyBody()
        }
        .environmentObject(bloc)
        .onAppear {
            bloc.event = .loadRates
        }
    }
}

struct CurrencyPageView_Previews: PreviewProvider {
    static var previews: some View {
        
        let bloc = CurrencyBloc()
        bloc.state.apiState = .init(status: .loaded, data: CurrencyRateData(
            timestamp: Date.now,
            base: "USD",
            rates: [
                "EUR" : 0.98,
                "PKR" : 275.0,
                "USD" : 1.0
            ]
        ))
        bloc.state.amount = 120
        return CurrencyPageView(bloc: bloc)
    }
}

struct CurrencyAppBar: View {
    
    @EnvironmentObject var bloc: CurrencyBloc
    
    var body: some View {
        CustomAppBar {
            CurrencyMenu(
                currencies: bloc.state.currencies,
                currency: $bloc.state.currency
            )
            
            AmountInputField(
                amount: $bloc.state.amount
            )
        }
    }
}

struct CurrencyBody: View {
    
    @EnvironmentObject var bloc: CurrencyBloc
    
    var body: some View {
        switch bloc.state.apiState.status {
        case .initial:
            VExpanded {}
            
        case .loading:
            VExpanded {
                ProgressView("Loading...")
                    .padding()
            }
            
        case .loaded:
            CurrencyListView()
                .refreshable {
                    bloc.event = .loadRates
                }
            
        case .failure:
            CurrencyErrorView()
        }
    }
}

struct CurrencyListView: View {
    
    @EnvironmentObject var bloc: CurrencyBloc
    
    var body: some View {
        List {
            ForEach(bloc.state.currencies, id: \.self) { item in
                HStack {
                    Text(item)
                    Spacer()
                    Text(bloc.state.converted(to: item))
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
        }
    }
}

struct CurrencyErrorView: View {
    
    @EnvironmentObject var bloc: CurrencyBloc
    
    var body: some View {
        VExpanded {
            Text(bloc.state.apiState.errorMessage)
                .padding(.horizontal)
            
            Button("Retry",
                   action: {
                bloc.event = CurrencyRateEvent.loadRates
            })
            .padding()
        }
    }
}
