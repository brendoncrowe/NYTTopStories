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
    
    private var sectionName = "Technology" {
        didSet {
            getSectionTitle()
        }
    }
    
    override func loadView() {
        view = newsFeedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchArticles()
    }
    
    private func configureVC() {
        newsFeedView.collectionView.dataSource = self
        newsFeedView.collectionView.delegate = self
        newsFeedView.collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "articleCell")
        navigationItem.searchController = newsFeedView.searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func getSectionTitle() {
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
    
    private func fetchArticles(for section: String = "Arts") {
        
        // get section from user defaults
        if let sectionName = UserDefaults.standard.object(forKey: UserKey.sectionName) as? String {
            if sectionName != self.sectionName {
                // at this point the section will be different
                // make a new query
                queryAPI(for: sectionName)
                self.sectionName = sectionName
            }
        } else {
            // use default section name
            queryAPI(for: sectionName)
            navigationItem.title = sectionName + " news articles"
        }
    }
    
    private func queryAPI(for section: String) {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
}

extension NewsFeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension NewsFeedViewController: UISearchBarDelegate {
    
    
}
