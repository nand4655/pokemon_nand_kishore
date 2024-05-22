//
//  APIEndpoint.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import Foundation

protocol APIEndpoint {
    var fullPath: String { get }
    var url: URL? { get }
}

struct PokemonAPI: APIEndpoint {
    let page: String?
    
    init(page: String?) {
        self.page = page
    }
    
    var fullPath: String {
        page ?? Constant.pokemonBaseApi + "?limit=100"
    }
    
    var url: URL? {
        return URL(string: fullPath)
    }
}

struct PokemonDetailsAPI: APIEndpoint {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var fullPath: String {
        Constant.pokemonBaseApi + "/\(id)/"
    }
    
    
    var url: URL? {
        return URL(string: fullPath)
    }
}
