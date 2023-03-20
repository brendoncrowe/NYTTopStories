//
//  ArticleDetailViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/19/23.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    public var article: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        updateUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
    }
    
    private func updateUI() {
        guard let article = article else {
            fatalError("did not load article")
        }
        navigationItem.title = article.title
    }
    
    
    @objc func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
        print("saved button pressed")
    }
    
}
