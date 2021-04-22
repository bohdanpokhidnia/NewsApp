//
//  FeedViewModel.swift
//  NewsApp
//
//  Created by Bogdan Pohidnya on 13.04.2021.
//

import RxSwift
import RxRelay
import PromiseKit

private let logger = Logger(identifier: "FeedViewModel")

protocol FeedViewModelInput {
    func viewDidLoad()
    
    func numberOfRows() -> Int
    func item(for indexPath: IndexPath) -> Article
    
    func tapSelectCell(at indexPath: IndexPath)
    func pullToRefresh(completion: @escaping () -> Void)
    func scrollToEnd()
}

protocol FeedViewModelOutput {
    var reloadCells: Observable<Void> { get }
}

typealias FeedViewModelProtocol = FeedViewModelInput & FeedViewModelOutput

final class FeedViewModel {
    
    // MARK: - Lifecycle
    
    init(coordinator: FeedCoordinatorProtocol, networkService: NetworkNewsProtocol) {
        self.coordinator = coordinator
        self.networkService = networkService
    }
    
    // MARK: - Private
    
    private let coordinator: FeedCoordinatorProtocol
    private let networkService: NetworkNewsProtocol
    private var articles: [Article] = []
    private let reloadCellsSubj = PublishRelay<Void>()
    
}

// MARK: - FeedViewModelInput

extension FeedViewModel: FeedViewModelInput {
    
    func viewDidLoad() {
        fetchArticles(country: .ua, pageNumber: 1)
    }
    
    func numberOfRows() -> Int {
        return articles.count
    }
    
    func item(for indexPath: IndexPath) -> Article {
        return articles[indexPath.row]
    }
    
    func tapSelectCell(at indexPath: IndexPath) {
        coordinator.open(article: articles[indexPath.row])
    }
    
    func scrollToEnd() {
        fetchArticles(country: .ua, pageNumber: 2)
    }
    
    func pullToRefresh(completion: @escaping () -> Void) {
        fetchArticles(country: .ua, pageNumber: 1)
        completion()
    }
    
}

// MARK: - FeedViewModelOutput

extension FeedViewModel: FeedViewModelOutput {
    
    var reloadCells: Observable<Void> {
        return reloadCellsSubj.asObservable()
    }
    
}

// MARK: -

private extension FeedViewModel {
    
    func addArticles(newsResponse: ArticleResponse, pageNumber: Int) {
        let newCount = self.articles.count + newsResponse.articles.count
        guard newCount <= newsResponse.totalResults else {
            return
        }
        
        if pageNumber > 1 {
            self.articles += newsResponse.articles
        } else {
            self.articles.removeAll()
            self.articles = newsResponse.articles
        }
    }
    
}

// MARK: - Network

private extension FeedViewModel {
    
    func fetchArticles(country: Countrys, pageNumber: Int) {
        firstly {
            networkService.getNews(country: country, pageNumber: pageNumber)
        }.done { newsResponse in
            self.addArticles(newsResponse: newsResponse, pageNumber: pageNumber)
            self.reloadCellsSubj.accept(())
        }.catch { error in
            logger.error(error.localizedDescription)
        }
    }
    
}
