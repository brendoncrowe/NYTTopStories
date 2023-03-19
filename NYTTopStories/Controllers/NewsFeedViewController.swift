//
//  NewsFeedController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    private let newsFeedView = NewsFeedView()
    private var articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.newsFeedView.collectionView.reloadData()
            }
            for article in articles {
                print("Article Title: \(article.title)")
            }
        }
    }
    
    override func loadView() {
        view = newsFeedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        newsFeedView.collectionView.dataSource = self
        newsFeedView.collectionView.delegate = self
        fetchArticles()
        newsFeedView.collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "articleCell")
    }
    
    private func fetchArticles(for section: String = "technology") {
        NYYTopStoriesAPIClient.fetchItems(for: section) { result in
            switch result {
            case .failure(let appError):
                print("error getting article \(appError)")
            case .success(let articles):
                self.articles = articles
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
        cell.backgroundColor = .systemBackground
        cell.configCell(with: article)
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
}
