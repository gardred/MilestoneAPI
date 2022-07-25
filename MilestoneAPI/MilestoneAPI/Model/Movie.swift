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
    let releaseDate: String
    let voteAverage: Double
    let posterPath: String?
    let overview: String
    let genreIds: [Int]?
    let genres: [Genre]?
    let backdropPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, overview, id, genres
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
    }
    
    func getGeneres() -> [Genre] {
        
        if let genreIds = genreIds {
            
            return GenreManager.shared.genre
                .filter({ _genre in
                    return genreIds.contains(where: { $0 == _genre.id })
                })
        }
        
        return []
    }
}
