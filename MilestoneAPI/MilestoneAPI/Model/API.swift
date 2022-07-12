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
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(.success(result.movies))
                } catch {
                    self.handleApiError("Something went wrong. Please try again later!")
                }
                
            } else if let error = error {
                self.handleApiError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getGenre(completion: @escaping (Result<[Genre], Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(Constants.API_KEY)&language=en-US") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
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
    
    func getMovieById(id: Int, completion: @escaping (Result<SingleMovie, Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(id)?api_key=\(Constants.API_KEY)&language=en-US") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            if let data = data {
                
                do {
                    let results = try JSONDecoder().decode(SingleMovie.self, from: data)
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
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
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
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(id)/reviews?api_key=\(Constants.API_KEY)&language=en-US&page=\(page)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
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
