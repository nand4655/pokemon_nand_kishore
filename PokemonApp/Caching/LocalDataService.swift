//
//  Caching.swift
//  PokemonApp
//
//  Created by Nand Kishore on 22/05/24.
//

import Foundation

protocol ILocalDataService {
    func save<T: Encodable>(data: T, for key: String)
    func load<T: Decodable>(for key: String) -> T?
}

class LocalDataService: ILocalDataService {
    static let shared = LocalDataService()
    private init() {}
    
    func save<T: Encodable>(data: T, for key: String) {
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    func load<T: Decodable>(for key: String) -> T? {
        if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
            return try? JSONDecoder().decode(T.self, from: savedData)
        }
        return nil
    }
}
