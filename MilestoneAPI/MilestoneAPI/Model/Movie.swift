//
//  Movie.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import Foundation

struct MovieResponse: Codable {
    let movie: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movie = "results"
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let year: String?
    let rate: Double
    let posterImage: String?
    let overview: String
    
    private enum CodingKeys: String, CodingKey {
        case title, overview, id
        case year = "release_date"
        case rate = "vote_average"
        case posterImage = "poster_path"
    }
}
