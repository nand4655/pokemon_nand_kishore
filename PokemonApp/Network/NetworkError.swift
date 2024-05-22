//
//  NetworkError.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import Foundation

protocol INetworkError: Error {
    var description: String { get }
}

enum NetworkError: INetworkError {
    case invalidUrl
    case unknown
    
    var description: String {
        switch self {
        case .invalidUrl:
            ErrorMessage.invalidUrl
        case .unknown:
            ErrorMessage.genericError
        }
    }
}
