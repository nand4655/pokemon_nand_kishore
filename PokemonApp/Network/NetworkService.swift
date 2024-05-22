//
//  NetworkService.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import Foundation

protocol INetworkService {
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T
}

class NetworkService: INetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        return decodedResponse
    }
}
