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
    
    private let detailView = ArticleDetailView()
    private var dataPersistence: DataPersistence<Article>
    private var article: Article
    private var bookmarkBarButton: UIBarButtonItem!
    
    private lazy var tapGesture: UITapGestureRecognizer! = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    init(_ dataPersistence: DataPersistence<Article>, article: Article) {
        self.dataPersistence = dataPersistence
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        updateUI()
        
        // setup gesture 
        detailView.articleImageView.isUserInteractionEnabled = true
        detailView.articleImageView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBookmarkState(article)
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        let image = detailView.articleImageView.image ?? UIImage()
        // get instance of ZoomImageViewController from storyboard
        let storyboard = UIStoryboard(name: "ZoomImage", bundle: nil)
        let zoomImageController = storyboard.instantiateViewController(identifier: "ZoomImageViewController") { coder in
            return ZoomImageViewController(coder: coder, image: image)
        }
        present(zoomImageController, animated: true)
    }
    
    
    
    private func updateUI() {
        detailView.configureView(for: article)
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
    
    private func updateBookmarkState(_ article: Article) {
        if dataPersistence.hasItemBeenSaved(article) {
            bookmarkBarButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkBarButton.image = UIImage(systemName: "bookmark")
        }
    }
}
