//
//  Movie.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import Foundation

struct MovieResponse: Codable {
    let result: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case original_title = "original_title"
        case poster_path = "poster_path"
        case overview = "overview"
        case vote_count = "vote_count"
        case release_date = "release_date"
        case vote_average = "vote_average"
    }
}

/*
 
 {
     page = 1;
     results =     (
                 {
             adult = 0;
             "backdrop_path" = "/wcKFYIiVDvRURrzglV9kGu7fpfY.jpg";
             "genre_ids" =             (
                 14,
                 28,
                 12
             );
             id = 453395;
             "original_language" = en;
             "original_title" = "Doctor Strange in the Multiverse of Madness";
             overview = "Doctor Strange, with the help of mystical allies both old and new, traverses the mind-bending and dangerous alternate realities of the Multiverse to confront a mysterious new adversary.";
             popularity = "12833.993";
             "poster_path" = "/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg";
             "release_date" = "2022-05-04";
             title = "Doctor Strange in the Multiverse of Madness";
             video = 0;
             "vote_average" = "7.5";
             "vote_count" = 3596;
         }
 
 */
