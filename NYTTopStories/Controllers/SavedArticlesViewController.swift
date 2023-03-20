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
            print("there are \(articles.count) articles")
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
        savedArticlesView.collectionView.dataSource = self
        savedArticlesView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "articleCell")
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = savedArticlesView.collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath)
        cell.backgroundColor = .systemBackground
        return cell
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
