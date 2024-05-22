//
//  PokemonDetailViewModel.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import SwiftUI

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?
    private let pokemonRepository: IPokemonRepository
    
    
    init(pokemonRepository: IPokemonRepository = PokemonRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    func fetchPokemonDetail(pokemonId: Int) async {
        do {
            let pokemonDetail: PokemonDetail = try await pokemonRepository.fetch(endpoint: PokemonDetailsAPI(id: pokemonId))
            DispatchQueue.main.async {
                self.pokemonDetail = pokemonDetail
            }
            
        } catch {
            //handle error
        }
    }
}
