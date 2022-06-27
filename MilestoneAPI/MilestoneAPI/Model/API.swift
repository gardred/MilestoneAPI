//
//  API.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 27.06.2022.
//

import Foundation

struct Constants {
    static let API_KEY = "a560703232bc4d393f220567c65184df"
    static let baseURL = "https://api.themoviedb.org"
}


class API {
    
    static let shared = API()
    
    func getMovies(completion: @escaping (String) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let result = try JSONDecoder().decode(MovieResponse.self, from: data)
                print(result)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
