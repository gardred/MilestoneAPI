//
//  Movie.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import Foundation

struct MovieResponse: Codable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let release_date: String?
    let vote_average: Double
    let poster_path: String?
    let overview: String
    
    private enum CodingKeys: String, CodingKey {
        case title, overview, id
        case release_date = "release_date"
        case vote_average = "vote_average"
        case poster_path = "poster_path"
    }
}
