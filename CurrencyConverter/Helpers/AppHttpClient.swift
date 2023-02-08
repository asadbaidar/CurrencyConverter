//
//  AppHttpClient.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 05/02/2023.
//

import Foundation

class AppHttpClient : IHttpClient {
    override init(config: HttpConfig = Constants.httpConfig) {
        super.init(config: config)
    }
}
