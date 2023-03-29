//
//  SavedArticlesViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import UIKit
import DataPersistence

class SavedArticlesViewController: UIViewController {
    
    private var dataPersistence: DataPersistence<Article>
    private var savedArticlesView = SavedArticlesView()
    
    private var savedArticles = [Article]() {
        didSet {
            savedArticlesView.collectionView.reloadData()
            if savedArticles.isEmpty {
                // setup empty view
                savedArticlesView.collectionView.backgroundView = EmptyView()
            } else {
                // remove empty view
                savedArticlesView.collectionView.backgroundView = nil
            }
        }
    }
    
    init(_ dataPersistence: DataPersistence<Article>) {
        self.dataPersistence = dataPersistence
        super.init(nibName: nil, bundle: nil)
        self.dataPersistence.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            savedArticles = try dataPersistence.loadItems()
        } catch {
            print("error loading saved articles: \(error)")
        }
    }
}

extension SavedArticlesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = savedArticlesView.collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? SavedArticleCell else {
            fatalError("could not dequeue a SavedArticleCell")
        }
        let savedArticle = savedArticles[indexPath.row]
        cell.configureCell(for: savedArticle)
        cell.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let savedArticle = savedArticles[indexPath.row]
        let detailController = ArticleDetailViewController(dataPersistence, article: savedArticle)
        navigationController?.pushViewController(detailController, animated: true)
    }
}

extension SavedArticlesViewController: DataPersistenceDelegate {
    
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        fetchSavedArticles()
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        fetchSavedArticles()
    }
}

extension SavedArticlesViewController: SavedArticleCellDelegate {
    
    func didLongPress(_ articleCell: SavedArticleCell, article: Article) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
            self?.deleteArticle(article)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func deleteArticle(_ article: Article) {
        guard let index = savedArticles.firstIndex(of: article) else {
            return
        }
        do {
            // deletes from documents directory
            try dataPersistence.deleteItem(at: index)
        } catch {
            print("Error deleting article: \(article)")
        }
    }
}
