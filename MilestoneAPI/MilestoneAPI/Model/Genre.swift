//
//  Genere.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 29.06.2022.
//

import Foundation

struct GenreResponse: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    var id: Int
    var name: String
}
