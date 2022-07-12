//
//  SingleMovie.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 06.07.2022.
//

import Foundation

struct SingleMovieResponse: Codable {
    let movies: [SingleMovie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct SingleMovie: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let voteAverage: Double
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    
    private enum CodingKeys: String, CodingKey {
        case title, overview, id
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
