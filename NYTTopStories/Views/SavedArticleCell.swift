//
//  SavedArticleCell.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/20/23.
//

import UIKit

class SavedArticleCell: UICollectionViewCell {
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero) // Making the x,y width and height 0. Layout will be setup later
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    // label for user name
    private let articleTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.text = "Article"
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
        setupLayoutConstraints()
        setArticleTitleLabelConstraints()
    }
    
    private func setupLayoutConstraints() {
        addSubview(articleImageView)
        // Constraints for userImageView
        NSLayoutConstraint.activate([
            articleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            articleImageView.heightAnchor.constraint(equalToConstant: 160.0)
        ])
    }
    
    private func setArticleTitleLabelConstraints() {
        addSubview(articleTitleLabel)
        NSLayoutConstraint.activate([
            articleTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            articleTitleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8),
            articleTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            articleTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    public func configureCell(for article: Article) {
        articleImageView.getImage(with: article.getArticleImageArticle(for: .thumbLarge)) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.articleImageView.image = UIImage(systemName: "photo.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.articleImageView.image = image
                }
            }
        }
        articleTitleLabel.text = article.title
    }
}
