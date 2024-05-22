//
//  PokemonListView.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $viewModel.sortOrder, label: Text("Sort"), content: {
                    Text("ID").tag(PokemonListViewModel.SortOrder.id)
                    Text("Name").tag(PokemonListViewModel.SortOrder.name)
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing, .top])
                
                List(viewModel.sortedPokemonList.indices, id: \.self) { index in
                    NavigationLink(destination: PokemonDetailView(pokemonId: viewModel.sortedPokemonList[index].id)) {
                        Text(viewModel.sortedPokemonList[index].name)
                    }
                    .onAppear {
                        if index == viewModel.sortedPokemonList.count - 1 {
                            Task {
                                await viewModel.fetchPokemonList()
                            }
                        }
                    }
                }
                .task {
                    await viewModel.fetchPokemonList()
                }
            }
            .navigationTitle("Pokemons")
        }
    }
}

#Preview {
    PokemonListView()
}

