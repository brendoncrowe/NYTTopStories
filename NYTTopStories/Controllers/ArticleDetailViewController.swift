//
//  ArticleDetailViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/19/23.
//

import UIKit
import ImageKit

class ArticleDetailViewController: UIViewController {
    
    private let DetailView = ArticleDetailView()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed))
    }
    
    @objc private func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
        print("saved button pressed")
    }
}
