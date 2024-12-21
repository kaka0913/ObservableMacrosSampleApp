import SwiftUI

@Observable
class Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let url: String
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        
        let components = url.components(separatedBy: "/")
        if let idString = components.dropLast().last {
            id = Int(idString) ?? 0
        } else {
            id = 0
        }
        isFavorite = false
    }
    
    init(id: Int, name: String, url: String, isFavorite: Bool = false) {
        self.name = name
        self.url = url
        // URLから ID を抽出 (例: "https://pokeapi.co/api/v2/pokemon/1/" → 1)
        self.id = Int(url.split(separator: "/").dropLast().last ?? "0") ?? 0
        self.isFavorite = isFavorite
    }
}

struct PokemonResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
} 
