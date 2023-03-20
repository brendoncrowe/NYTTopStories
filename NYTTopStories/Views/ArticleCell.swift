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
    
    public lazy var byLineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.text = "By Line"
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
        setByLineLabelConstraints()
    }
    
    public func configCell(with article: Article) {
        articleTitle.text = article.title
        abstractHeadline.text = article.abstract
        byLineLabel.text = article.byline
        articleImageView.getImage(with: article.getArticleImageArticle(for: .thumbLarge)) { [weak self] result in
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
            articleImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            articleImageView.widthAnchor.constraint(equalTo: articleImageView.heightAnchor)
        ])
    }
    
    private func setArticleTitleConstraints() {
        addSubview(articleTitle)
        NSLayoutConstraint.activate( [
            articleTitle.topAnchor.constraint(equalTo: articleImageView.topAnchor),
            articleTitle.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 12),
            articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setAbstractHeadlineConstraints() {
        addSubview(abstractHeadline)
        NSLayoutConstraint.activate([
            abstractHeadline.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 8),
            abstractHeadline.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 12),
            abstractHeadline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setByLineLabelConstraints() {
        addSubview(byLineLabel)
        NSLayoutConstraint.activate([
            byLineLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            byLineLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 280),
            byLineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
