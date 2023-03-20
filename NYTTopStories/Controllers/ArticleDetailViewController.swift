//
//  ArticleDetailViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/19/23.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    private var mainView = ArticleDetailView()
    
    public var article: Article?
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        updateUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed))
    }
    
    private func updateUI() {
        guard let article = article else {
            fatalError("did not load article")
        }
        navigationItem.title = article.title
        mainView.abstractHeadline.text = article.abstract
        mainView.articleImageView.getImage(with: article.getArticleImageArticle(for: .superJumbo)) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.mainView.articleImageView.image = UIImage(systemName: "photo.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.mainView.articleImageView.image = image
                }
            }
        }
    }
    
    
    @objc func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
        print("saved button pressed")
    }
    
}
