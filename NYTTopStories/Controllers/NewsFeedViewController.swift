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
        newsFeedView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "articleCell")
    }
    
    private func fetchArticles(for section: String = "technology") {
        NYYTopStoriesAPIClient.fetchItems(for: section) { [weak self] result in
            switch result {
            case .failure(let appError):
                print("error getting article \(appError)")
            case .success(let articles):
                DispatchQueue.main.async {
                    self?.articles = articles
                }
            }
        }
    }
}

extension NewsFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newsFeedView.collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath)
        cell.backgroundColor = .systemGray3
        return cell
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = (view.window?.windowScene?.coordinateSpace.bounds.size)!
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.30
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
