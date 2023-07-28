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
    var palettes: [String: ReccoTheme]
    var selectedKeyOrName: String = ReccoTheme.summer.name
    
    var selectedTheme: ReccoTheme {
        palettes[selectedKeyOrName] ?? [ReccoTheme.summer, .tech, .ocean, .spring].first { $0.name == selectedKeyOrName } ?? .summer
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
