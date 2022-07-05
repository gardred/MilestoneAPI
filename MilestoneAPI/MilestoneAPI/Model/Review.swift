//
//  Review.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 04.07.2022.
//

import Foundation

struct ReviewResponse: Codable {
    let id, page: Int
    let results: [Review]
    let total_pages, total_results: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case total_pages = "total_pages"
        case total_results = "total_results"
    }
}

// MARK: - Review

struct Review: Codable {
    let author: String
    let author_details: AuthorDetails
    let content, created_at, id, updated_at: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case author_details = "author_details"
        case content
        case created_at = "created_at"
        case id
        case updated_at = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let name, username, avatar_path: String
    let rating: Int

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatar_path = "avatar_path"
        case rating
    }
}
