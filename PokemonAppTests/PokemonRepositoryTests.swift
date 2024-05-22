//
//  PokemonRepositoryTests.swift
//  PokemonAppTests
//
//  Created by Nand Kishore on 22/05/24.
//

import XCTest
@testable import PokemonApp

class MockNetworkService: INetworkService {
    func fetch<T>(endpoint: APIEndpoint) async throws -> T where T : Decodable {
        let pokemonList = PokemonList(results: [Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1/")], next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
        return pokemonList as! T
    }
}

class MockLocalDataService: ILocalDataService {
    func save<T: Encodable>(data: T, for key: String) {
        // Do nothing
    }

    func load<T: Decodable>(for key: String) -> T? {
        let pokemonList = PokemonList(results: [Pokemon(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")], next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
        return pokemonList as? T
    }
}

class PokemonRepositoryTests: XCTestCase {
    var pokemonRepository: PokemonRepository!

    override func setUp() {
        super.setUp()
        let mockNetworkService = MockNetworkService()
        let localDataService = LocalDataService.shared
        localDataService.clear() // Add this line to clear the cache
        pokemonRepository = PokemonRepository(networkService: mockNetworkService, localDataService: localDataService)
    }

    func testFetchPokemonList() async {
        do {
            let pokemonList: PokemonList = try await pokemonRepository.fetch(endpoint: PokemonAPI(page: "/v2/pokemon?limit=20"))
            XCTAssertEqual(pokemonList.results.first?.name, "Pikachu")
        } catch {
            XCTFail("Fetch failed: \(error)")
        }
    }
    
    func testFetchPokemonListFromCache() async {
        let pokemonRepositoryWithMockLocalData = PokemonRepository(networkService: MockNetworkService(), localDataService: MockLocalDataService())
        
        do {
            let pokemonList: PokemonList = try await pokemonRepositoryWithMockLocalData.fetch(endpoint: PokemonAPI(page: "/v2/pokemon?limit=20"))
            XCTAssertEqual(pokemonList.results.first?.name, "Charmander")
        } catch {
            XCTFail("Fetch failed: \(error)")
        }
    }
}
