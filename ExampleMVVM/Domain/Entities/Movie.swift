//
//  Movie.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

/// 비즈니스 모델로서 고차원으로 추상화
struct Movie: Equatable, Identifiable {
    typealias Identifier = String
    enum Genre {
        case adventure
        case scienceFiction
    }
    let id: Identifier
    let title: String?
    let genre: Genre?
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
}

struct MoviesPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}
