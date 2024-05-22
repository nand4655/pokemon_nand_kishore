//
//  PokemonDetailView.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemonId: Int
    @StateObject var viewModel = PokemonDetailViewModel()
    
    var body: some View {
        VStack {
            if let pokemonDetail = viewModel.pokemonDetail {
                
                TabView {
                    ForEach(pokemonDetail.sprites?.all ?? [], id: \.self) { url in
                        AsyncImage(url: URL(string: url)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Text(pokemonDetail.name?.capitalized ?? "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                Text("ID: \(pokemonDetail.id)")
                    .font(.title2)
                    .padding(.top, 4)
                Text("Base Experience: \(pokemonDetail.base_experience ?? 0)")
                    .font(.title2)
                    .padding(.top, 4)
                Text("Abilities")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 12)
                ForEach(pokemonDetail.abilities ?? [], id: \.ability.name) { ability in
                    Text(ability.ability.name)
                        .font(.title2)
                        .padding(.top, 4)
                }
                Spacer().background(Color.red)
            }
        }
        .task {
            await viewModel.fetchPokemonDetail(pokemonId: pokemonId)
        }
        .frame(alignment: .leading)
        
    }
}
