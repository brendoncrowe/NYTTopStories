//
//  EmptyView.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/20/23.
//

import UIKit

class EmptyView: UIView {
    
    public lazy var boxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "emptyBox")
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.alpha = 0.5
        label.numberOfLines = 1
        label.text = "oops!"
        label.textAlignment = .center
        return label
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.alpha = 0.5
        label.text = "You do not have any saved articles"
        label.numberOfLines = 4
        label.textAlignment = .center
        
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
        setLabelConstraints()
    }
    
    private func setLabelConstraints() {
        addSubview(boxImageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: boxImageView.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            boxImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            boxImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            boxImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            boxImageView.widthAnchor.constraint(equalTo: boxImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: boxImageView.bottomAnchor, constant: 20)
        ])
    }
}
