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
    
    func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(.success(result.movie))
                } catch {
                    print(error)
                }
                
            } else if let error = error {
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                }
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
                    print(error)
                }
            
            } else if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            }
        }
        task.resume()
    }
    
    func getMovieById(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(id)?api_key=\(Constants.API_KEY)&language=en-US") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
           
            if let data = data {
              
                do {
                    let results = try JSONDecoder().decode(Movie.self, from: data)
                    completion(.success(results))
                } catch {
                    print(error)
                }
            
            } else if let error = error {
                print(error.localizedDescription)
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
                    completion(.success(results.movie))
                } catch {
                    print(error)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
