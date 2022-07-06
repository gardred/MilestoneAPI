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
