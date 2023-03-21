//
//  ArticleDetailView.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/19/23.
//

import UIKit

class ArticleDetailView: UIView {
    
    public lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private lazy var abstractHeadline: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.text = "Abstract Headline"
        return label
    }()
    
    private lazy var byLineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.text = "Abstract"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.text = "Date Label"
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
        setAbstractHeadlineConstraints()
    }
    
    public func configureView(for article: Article?) {
        guard let article = article else {
            fatalError("did not load article")
        }
        abstractHeadline.text = article.abstract
        articleImageView.getImage(with: article.getArticleImageArticle(for: .superJumbo)) { [weak self] result in
            switch result {
            case .failure:
                break
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
            articleImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            articleImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
        ])
    }
        
    private func setAbstractHeadlineConstraints() {
        addSubview(abstractHeadline)
        NSLayoutConstraint.activate([
            abstractHeadline.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 16),
            abstractHeadline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            abstractHeadline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    private func setByLineLabelConstraints() {
        addSubview(byLineLabel)
        NSLayoutConstraint.activate([
          // TODO:
        ])
    }
}
