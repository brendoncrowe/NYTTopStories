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
    private var dataPersistence: DataPersistence<Article>
    private var userPreference: UserPreference
    
    private var articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.newsFeedView.collectionView.reloadData()
            }
        }
    }
    private var masterArticleList = [Article]()

    
    // initializers
    init(_ dataPersistence: DataPersistence<Article>, userPreference: UserPreference) {
        self.dataPersistence = dataPersistence
        self.userPreference = userPreference
        super.init(nibName: nil, bundle: nil)
        self.userPreference.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = newsFeedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureVC()
        let sectionName = userPreference.getSectionName() ?? "Technology"
        fetchArticles(sectionName)
        getSectionTitle(sectionName)
    }
    
    private func configureVC() {
        newsFeedView.collectionView.dataSource = self
        newsFeedView.collectionView.delegate = self
        newsFeedView.collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "articleCell")
        navigationItem.searchController = newsFeedView.searchController
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func getSectionTitle(_ sectionName: String) {
        SectionTitleAPI.fetchItems(for: sectionName) { result in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self.navigationItem.title = "Technology " + "news articles"
                }
                print("Error getting section title: \(appError)")
            case .success(let sectionTitle):
                DispatchQueue.main.async {
                    self.navigationItem.title = "\(sectionTitle) news articles"
                }
            }
        }
    }
    
    private func fetchArticles(_ section: String) {
        NYYTopStoriesAPIClient.fetchItems(for: section) { [weak self] result in
            switch result {
            case .failure(let appError):
                print("error getting article \(appError)")
            case .success(let articles):
                self?.articles = articles
                self?.masterArticleList = articles
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
        let detailController = ArticleDetailViewController(dataPersistence, article: article)
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}

extension NewsFeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            let sectionName = userPreference.getSectionName() ?? "Technology"
            fetchArticles(sectionName)
            return
        }
        articles = masterArticleList.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if newsFeedView.searchController.searchBar.isFirstResponder {
            newsFeedView.searchController.searchBar.resignFirstResponder()
        }
    }
}

extension NewsFeedViewController: UserPreferenceDelegate {
    func didChangeNewsSection(_ userPreference: UserPreference, sectionName: String) {
        getSectionTitle(sectionName)
        fetchArticles(sectionName)
    }
}

