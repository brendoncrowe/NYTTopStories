//
//  SavedArticlesViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit
import DataPersistence

class SavedArticlesViewController: UIViewController {
    
    public var dataPersistence: DataPersistence<Article>!
    private var savedArticlesView = SavedArticlesView()
    private var articles = [Article]() {
        didSet {
            savedArticlesView.collectionView.reloadData()
            if articles.isEmpty {
                // setup empty view
                savedArticlesView.collectionView.backgroundView = EmptyView()
            } else {
                // remove empty view
                savedArticlesView.collectionView.backgroundView = nil
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view = savedArticlesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchSavedArticles()
        configureVC()
    }
    
    private func configureVC() {
        savedArticlesView.collectionView.dataSource = self
        savedArticlesView.collectionView.delegate = self
        savedArticlesView.collectionView.register(SavedArticleCell.self, forCellWithReuseIdentifier: "articleCell")
        title = "Saved Articles"
    }
    
    private func fetchSavedArticles() {
        do {
            articles = try dataPersistence.loadItems()
        } catch {
            print("error loading saved articles: \(error)")
        }
    }
}

extension SavedArticlesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = savedArticlesView.collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? SavedArticleCell else {
            fatalError("could not dequeue a SavedArticleCell")
        }
        let article = articles[indexPath.row]
        cell.configureCell(for: article)
        cell.backgroundColor = .systemBackground
        return cell
    }
}

extension SavedArticlesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 15 // space between items
        let maxWidth = (view.window?.windowScene?.screen.bounds.size.width)! // device's width
        let numberOfItems: CGFloat = 2 // items
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension SavedArticlesViewController: DataPersistenceDelegate {
    
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        fetchSavedArticles()
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        print("Item deleted")
    }
}
