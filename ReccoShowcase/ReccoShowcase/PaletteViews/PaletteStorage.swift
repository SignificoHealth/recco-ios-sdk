//
//  PaletteStorage.swift
//  ReccoShowcase
//
//  Created by Adrián R on 27/7/23.
//

import Foundation
import ReccoUI

final class PaletteStorageObservable: ObservableObject {
    @Published var storage: PaletteStorage

    private init() {
        storage = .get()
    }
    
    static let shared: PaletteStorageObservable = .init()
}

struct PaletteStorage: Codable {
    var palettes: [String: ReccoStyle]
    var selectedKeyOrName: String = ReccoStyle.fresh.name
    
    var selectedStyle: ReccoStyle {
        palettes[selectedKeyOrName] ?? [ReccoStyle.fresh, .tech, .ocean, .spring].first { $0.name == selectedKeyOrName } ?? .fresh
    }
}

extension PaletteStorage {
    static let key = "palettesStorageKey"

    func store() {
        let data = try? JSONEncoder().encode(self)
        UserDefaults.standard.set(data, forKey: PaletteStorage.key)
    }
    
    static func get() -> PaletteStorage {
        (UserDefaults.standard.object(forKey: PaletteStorage.key) as? Data)
            .flatMap { try? JSONDecoder().decode(PaletteStorage.self, from: $0) } ?? PaletteStorage(palettes: [:])
    }
}
