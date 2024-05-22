//
//  PokemonListViewModel.swift
//  PokemonAppTests
//
//  Created by Nand Kishore on 22/05/24.
//

import XCTest
@testable import PokemonApp

class MockPokemonRepository: IPokemonRepository {
    var pokemonList: PokemonList?
    var pokemonDetail: PokemonDetail?
    var error: Error?

    func fetch<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        if let error = error {
            throw error
        }
        if let pokemonList = pokemonList {
            return pokemonList as! T
        }
        
        return pokemonDetail as! T
    }
}

class PokemonListViewModelTests: XCTestCase {
    var viewModel: PokemonListViewModel!
    var mockRepository: MockPokemonRepository = MockPokemonRepository()

    override func setUp() {
        super.setUp()
        viewModel = PokemonListViewModel(repository: mockRepository)
    }

    func testFetchPokemonSuccess() async {
        // Given
        let expectation = XCTestExpectation(description: "Pokemon fetched")
        let pokemonList = PokemonList(results: [Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1/")], next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
        mockRepository.pokemonList = pokemonList
        
        // When
        do {
            try await viewModel.fetchPokemonList()
        } catch {
            XCTFail("Fetch failed: \(error)")
        }
        
        DispatchQueue.main.async {
            // Then
            XCTAssertNotNil(self.viewModel.pokemonList.first, "sortedPokemonList is empty")
            XCTAssertEqual(self.viewModel.pokemonList.first?.name, "Pikachu")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchPokemonFailure() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch failed")
        mockRepository.error = NSError(domain: "", code: 0, userInfo: nil)
        
        // When
        Task.init {
            do {
                try await self.viewModel.fetchPokemonList()
            } catch {
                DispatchQueue.main.async {
                    // Then
                    XCTAssertNotNil(error, "Expected fetch to throw error")
                    expectation.fulfill()
                }
            }
        }
        
    }
}
