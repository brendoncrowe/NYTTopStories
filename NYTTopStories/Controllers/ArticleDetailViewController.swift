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
    public var article: Article?
    
    override func loadView() {
        view = DetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        updateUI()
    }

    private func updateUI() {
        DetailView.configureView(for: article)
        navigationItem.title = article?.title ?? "Article not available"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
    }
    
    @objc private func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
        guard let article = article else { return }
        do {
            // save to documents directory 
            try dataPersistence.createItem(article)
        } catch {
            print("error saving article: \(error)")
        }
    }
}
