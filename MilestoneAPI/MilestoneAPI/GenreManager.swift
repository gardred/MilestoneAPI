//
//  GenreManager.swift
//  MilestoneAPI
//
//  Created by Сережа Присяжнюк on 14.07.2022.
//

import Foundation


class GenreManager {
    
    static let shared = GenreManager()
    
    var genre: [Genre] = []
    
    func getGenre() {
       
        API.shared.getGenre { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
           
            case .success(let getGenre):
                
                self.genre.append(contentsOf: getGenre)
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
}
