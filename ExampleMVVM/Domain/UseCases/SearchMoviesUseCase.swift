//
//  SearchMoviesUseCase.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 22.02.19.
//

import Foundation

// 무비 검색 시나리오에 대한 명세
protocol SearchMoviesUseCase {
    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 cached: @escaping (MoviesPage) -> Void,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable?
}

// 시나리오 프로토콜을 채택한 구현체
final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {

  // 데이터 레이어의 레포지터리 구현체가 아닌 도메인 레이어의 인터페이스를 갖는다.
    private let moviesRepository: MoviesRepository
    private let moviesQueriesRepository: MoviesQueriesRepository

  // 인스턴스 생성시에는 인터페이스를 구현한 구현체를 함께 주입받는다.
    init(moviesRepository: MoviesRepository,
         moviesQueriesRepository: MoviesQueriesRepository) {

        self.moviesRepository = moviesRepository
        self.moviesQueriesRepository = moviesQueriesRepository
    }

    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 cached: @escaping (MoviesPage) -> Void,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable? {

        return moviesRepository.fetchMoviesList(query: requestValue.query,
                                                page: requestValue.page,
                                                cached: cached,
                                                completion: { result in

            if case .success = result {
                self.moviesQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }

            completion(result)
        })
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
