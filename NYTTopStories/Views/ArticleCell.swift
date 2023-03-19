//
//  ArticleCell.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/19/23.
//

import UIKit
import ImageKit

class ArticleCell: UICollectionViewCell {
    
    public lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    public lazy var articleTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Article Headline"
        return label
    }()
    
    public lazy var abstractHeadline: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Abstract Headline"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setImageViewConstraints()
        setArticleTitleConstraints()
        setAbstractHeadlineConstraints()
    }
    
    public func configCell(with article: Article) {
        articleTitle.text = article.title
        abstractHeadline.text = article.abstract
        articleImageView.getImage(with: article.multimedia.first!.url) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.articleImageView.image = UIImage(systemName: "photo")
                }
                print("Error getting image")
            case .success(let image):
                DispatchQueue.main.async {
                    self?.articleImageView.image = image
                }
            }
        }
    }
    
    private func setImageViewConstraints() {
        addSubview(articleImageView)
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            articleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            articleImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            articleImageView.widthAnchor.constraint(equalTo: articleImageView.heightAnchor)
        ])
    }
    
    private func setArticleTitleConstraints() {
        addSubview(articleTitle)
        NSLayoutConstraint.activate( [
            articleTitle.topAnchor.constraint(equalTo: articleImageView.topAnchor, constant: 8),
            articleTitle.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 16),
            articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func setAbstractHeadlineConstraints() {
        addSubview(abstractHeadline)
        NSLayoutConstraint.activate([
            abstractHeadline.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 8),
            abstractHeadline.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 16),
            abstractHeadline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
