//
//  PokemonDetailViewModelTests.swift
//  PokemonAppTests
//
//  Created by Nand Kishore on 22/05/24.
//

import XCTest
@testable import PokemonApp

class PokemonDetailViewModelTests: XCTestCase {
    var viewModel: PokemonDetailViewModel!
    var mockRepository: MockPokemonRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockPokemonRepository()
        viewModel = PokemonDetailViewModel(pokemonRepository: mockRepository)
    }

    func testFetchPokemonDetailSuccess() async {
        // Given
        let expectation = XCTestExpectation(description: "Pokemon detail fetched")
        let pokemonDetail = PokemonDetail(id: 0, name: "Pikachu", base_experience: 7, abilities: [], sprites: nil)
        mockRepository.pokemonDetail = pokemonDetail
        
        // When
        do {
            try await viewModel.fetchPokemonDetail(pokemonId: 0)
        } catch {
            XCTFail("Fetch failed: \(error)")
        }
        
        DispatchQueue.main.async {
            // Then
            XCTAssertEqual(self.viewModel.pokemonDetail?.name, "Pikachu")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchPokemonDetailFailure() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch failed")
        mockRepository.error = NSError(domain: "", code: 0, userInfo: nil)
        
        // When
        Task.init {
            do {
                try await self.viewModel.fetchPokemonDetail(pokemonId: 0)
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
