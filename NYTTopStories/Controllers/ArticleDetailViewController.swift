//
//  ArticleDetailViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/19/23.
//

import UIKit
import ImageKit
import DataPersistence

class ArticleDetailViewController: UIViewController {
    
    private let DetailView = ArticleDetailView()
    public var dataPersistence: DataPersistence<Article>!
    public var article: Article
    private var bookmarkBarButton: UIBarButtonItem!
    
    init(_ dataPersistence: DataPersistence<Article>, article: Article) {
        self.dataPersistence = dataPersistence
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = DetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBookmarkState(article)
    }
    
    private func updateUI() {
        DetailView.configureView(for: article)
        navigationItem.title = article.title
        bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
        navigationItem.rightBarButtonItem = bookmarkBarButton
    }
    
    @objc private func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
        if dataPersistence.hasItemBeenSaved(article) {
            if let index = try? dataPersistence.loadItems().firstIndex(of: article) {
                do {
                    try dataPersistence.deleteItem(at: index)
                } catch {
                    print("error deleting article: \(error)")
                }
            }
        } else {
            do {
                // save to documents directory
                try dataPersistence.createItem(article)
            } catch {
                print("error saving article: \(error)")
            }
        }
        updateBookmarkState(article)
    }
    
    // ADDITION
    private func updateBookmarkState(_ article: Article) {
        if dataPersistence.hasItemBeenSaved(article) {
            bookmarkBarButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkBarButton.image = UIImage(systemName: "bookmark")
        }
    }
}
