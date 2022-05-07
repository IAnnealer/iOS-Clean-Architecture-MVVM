//
//  MoviesSearchFlowCoordinator.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 03.03.19.
//

import UIKit

protocol MoviesSearchFlowCoordinatorDependencies  {
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController
}

final class MoviesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies

    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

  // VC 객체를 생성할때, 화면전환과 같은 이벤트를 처리하기 위한 Actions 객체를 생성하여 전달을 하며 해당 객체는 Coordinator가 가지고 있는다.
  // 뷰모델 내에서 actions를 체이닝하여 메소드를 호출하면 Coordinator가 이벤트를 수신하여 화면전환과 같은 이벤트를 실행한다.
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = MoviesListViewModelActions(showMovieDetails: showMovieDetails,
                                                 showMovieQueriesSuggestions: showMovieQueriesSuggestions,
                                                 closeMovieQueriesSuggestions: closeMovieQueriesSuggestions)
        let vc = dependencies.makeMoviesListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        moviesListVC = vc
    }

    private func showMovieDetails(movie: Movie) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showMovieQueriesSuggestions(didSelect: @escaping (MovieQuery) -> Void) {
        guard let moviesListViewController = moviesListVC, moviesQueriesSuggestionsVC == nil,
            let container = moviesListViewController.suggestionsListContainer else { return }

        let vc = dependencies.makeMoviesQueriesSuggestionsListViewController(didSelect: didSelect)

        moviesListViewController.add(child: vc, container: container)
        moviesQueriesSuggestionsVC = vc
        container.isHidden = false
    }

    private func closeMovieQueriesSuggestions() {
        moviesQueriesSuggestionsVC?.remove()
        moviesQueriesSuggestionsVC = nil
        moviesListVC?.suggestionsListContainer.isHidden = true
    }
}
