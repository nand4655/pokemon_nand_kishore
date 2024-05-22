//
//  LocalDataServiceTests.swift
//  PokemonAppTests
//
//  Created by Nand Kishore on 22/05/24.
//

import XCTest
@testable import PokemonApp

class LocalDataServiceTests: XCTestCase {
    var localDataService: LocalDataService!

    override func setUp() {
        super.setUp()
        localDataService = LocalDataService.shared
        localDataService.clear()
    }

    func testSaveAndLoadData() {
        let pokemonList = PokemonList(results: [Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1/")], next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
        localDataService.save(data: pokemonList, for: "testKey")

        let loadedData: PokemonList? = localDataService.load(for: "testKey")
        XCTAssertNotNil(loadedData)
        XCTAssertEqual(loadedData?.results.first?.name, "Pikachu")
    }
    
    func testLoadDataNotFound() {
        let loadedData: PokemonList? = localDataService.load(for: "nonexistentKey")
        XCTAssertNil(loadedData)
    }
}

extension LocalDataService {
    func clear() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
