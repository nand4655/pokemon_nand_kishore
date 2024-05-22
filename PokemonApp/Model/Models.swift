//
//  Models.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
    let next: String?
}

struct Pokemon: Identifiable, Codable {
    let name: String
    let url: String
    var id: Int {
        return Int(url.split(separator: "/").last!) ?? 0
    }
}

struct PokemonDetail: Codable {
    let id: Int
    let name: String?
    let base_experience: Int?
    let abilities: [Ability]?
    let sprites: Sprites?
    
    struct Ability: Codable {
        let ability: NameAndUrl
        
        struct NameAndUrl: Codable {
            let name: String
            let url: String
        }
    }
}

struct Sprites: Codable {
    let front_default: String?
    let back_default: String?
    let front_shiny: String?
    let back_shiny: String?
    
    var all: [String] {
        var arr: [String?] = []
        arr.append(front_default)
        arr.append(back_default)
        arr.append(front_shiny)
        arr.append(back_shiny)
        
        return arr.compactMap { $0 }
    }
}
