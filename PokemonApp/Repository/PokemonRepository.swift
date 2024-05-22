//
//  PokemonRepository.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import Foundation

protocol IPokemonRepository {
    func fetch<T: Codable>(endpoint: APIEndpoint) async throws -> T
}

class PokemonRepository: IPokemonRepository {
    private let networkService: INetworkService
    private let localDataService: ILocalDataService
    
    init(networkService: INetworkService = NetworkService.shared,
         localDataService: ILocalDataService = LocalDataService.shared) {
        self.networkService = networkService
        self.localDataService = localDataService
    }
    
    func fetch<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        if let saved: T = localDataService.load(for: endpoint.fullPath) {
            return saved
        } else {
            let response: T = try await networkService.fetch(endpoint: endpoint)
            localDataService.save(data: response, for: endpoint.fullPath)
            return response
        }
    }
}
