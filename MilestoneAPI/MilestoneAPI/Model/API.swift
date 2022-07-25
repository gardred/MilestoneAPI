//
//  API.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import Foundation
import UIKit

struct Constants {
    static let API_KEY = "a560703232bc4d393f220567c65184df"
    static let baseURL = "https://api.themoviedb.org"
    static let imageURL = "https://image.tmdb.org/t/p/w500/"
}

class API {
    
    static let shared = API()

    func getMovies(atPage page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/discover/movie"
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "a560703232bc4d393f220567c65184df"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "include_video", value: "false"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "with_watch_monetization_types", value: "flatrate")
        ]
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: components.url!)) { data, _, error in
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(.success(result.movies))
                } catch {
                    self.handleApiError("Something went wrong. Please try again later!")
                    print(error)
                }
                
            } else if let error = error {
                self.handleApiError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getGenre(completion: @escaping (Result<[Genre], Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/genre/movie/list"
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "a560703232bc4d393f220567c65184df"),
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: components.url!)) { data, _, error in
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(GenreResponse.self, from: data)
                    completion(.success(result.genres))
                } catch {
                    self.handleApiError("Something went wrong. Please try again later!")
                }
                
            } else if let error = error {
                self.handleApiError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getMovieById(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/movie/\(id)"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "a560703232bc4d393f220567c65184df"),
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: components.url!)) { data, _, error in
            
            if let data = data {
                
                do {
                    let results = try JSONDecoder().decode(Movie.self, from: data)
                    completion(.success(results))
                } catch {
                    self.handleApiError("Something went wrong. Please try again later!")
                    print(error)
                }
                
            } else if let error = error {
                self.handleApiError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/search/movie"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "a560703232bc4d393f220567c65184df"),
            URLQueryItem(name: "query", value: "\(query)")
        ]
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: components.url!)) { data, _, error in
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(.success(results.movies))
                } catch {
                    self.handleApiError("Something went wrong. Please try again later!")
                }
            } else if let error = error {
                self.handleApiError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getReview(id: Int, atPage page: Int, completion: @escaping (Result<[Review], Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/movie/\(id)/reviews"
       
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "a560703232bc4d393f220567c65184df"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: components.url!)) { data, _, error in
            
            if let data = data {
                
                do {
                    let results = try JSONDecoder().decode(ReviewResponse.self, from: data)
                    completion(.success(results.results))
                } catch {
                    print(error)
                }
                
            } else if let error = error {
                self.handleApiError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func handleApiError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancel)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        }
    }
}
