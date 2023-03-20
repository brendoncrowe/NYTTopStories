//
//  NewsFeedController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit
import DataPersistence

class NewsFeedViewController: UIViewController {
    
    private let newsFeedView = NewsFeedView()
    public var dataPersistence: DataPersistence<Article>!
    
    private var articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.newsFeedView.collectionView.reloadData()
            }
        }
    }
    
    override func loadView() {
        view = newsFeedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "News Articles"
        fetchArticles()
        configureVC()
    }
    
    private func configureVC() {
        newsFeedView.collectionView.dataSource = self
        newsFeedView.collectionView.delegate = self
        newsFeedView.collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "articleCell")
        navigationItem.searchController = newsFeedView.searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
    }
    
    private func fetchArticles(for section: String = "technology") {
        NYYTopStoriesAPIClient.fetchItems(for: section) { [weak self] result in
            switch result {
            case .failure(let appError):
                print("error getting article \(appError)")
            case .success(let articles):
                self?.articles = articles
            }
        }
    }
}

extension NewsFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = newsFeedView.collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? ArticleCell else {
            fatalError("could not dequeue an ArticleCell")
        }
        let article = articles[indexPath.row]
        cell.configCell(with: article)
        cell.backgroundColor = .systemBackground
        return cell
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = (view.window?.windowScene?.coordinateSpace.bounds.size)!
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.20
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let viewController = ArticleDetailViewController()
        viewController.article = article
        viewController.dataPersistence = dataPersistence
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension NewsFeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension NewsFeedViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        newsFeedView.searchController.searchBar.showsScopeBar = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // used to hide the scope titles when the search bar is not in use 
        newsFeedView.searchController.searchBar.showsScopeBar = false
        return true
    }
}
