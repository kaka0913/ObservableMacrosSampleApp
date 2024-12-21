//
//  ContentView.swift
//  ObservablePerformanceTest
//
//  Created by 株丹優一郎 on 2024/12/20.
//

import SwiftUI

struct PokemonListItem: View {
    @Binding var pokemon: Pokemon
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                Text("No.\(pokemon.id)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                pokemon.isFavorite.toggle()
            }) {
                Image(systemName: pokemon.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(pokemon.isFavorite ? .red : .gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PokemonBookView: View {
    @State private var viewModel = PokemonViewModel()
    
    var body: some View {
        NavigationStack {
            List($viewModel.pokemons) { $pokemon in
                PokemonListItem(pokemon: $pokemon)
            }
            .navigationTitle("ポケモン図鑑")
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert("エラー", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .task {
            viewModel.fetchPokemons()
        }
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}
