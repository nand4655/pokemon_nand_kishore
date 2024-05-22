//
//  ContentView.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import SwiftUI

class PokemonListViewModel: ObservableObject {
    @Published private(set) var pokemonList = [Pokemon]()
    @Published var sortOrder = SortOrder.id
    private var nextPageURL: String?
    private let pokemonRepository: IPokemonRepository
    
    enum SortOrder {
        case id, name
    }
    
    var sortedPokemonList: [Pokemon] {
        switch sortOrder {
        case .id:
            return pokemonList.sorted(by: { $0.id < $1.id })
        case .name:
            return pokemonList.sorted(by: { $0.name < $1.name })
        }
    }
    
    
    init(repository: IPokemonRepository = PokemonRepository()) {
        self.pokemonRepository = repository
    }
    
    func fetchPokemonList() async {
        do {
            let pokemonList: PokemonList = try await pokemonRepository.fetch(endpoint: PokemonAPI(page: nextPageURL))
            DispatchQueue.main.async {
                self.pokemonList += pokemonList.results
                self.nextPageURL = pokemonList.next
            }
        } catch {
            //handle error
        }
    }
}


















