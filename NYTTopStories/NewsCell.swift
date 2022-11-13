//
//  NewsCell.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 13/11/22.
//

import UIKit
import ImageKit // getimage()

class NewsCell: UICollectionViewCell {
    
    // image view of the article
    // title of article
    // abstract of title
    
    public lazy var newsImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
//        iv.backgroundColor = .yellow // for testing
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    public lazy var articleTitle: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Article title"
        return label
    }()
    
    public lazy var abstractTitle: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Abstract headline"
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
        setupNewsImageViewConstraints()
        setupArticleTitleConstraints()
        setupAbstractHeadlineConstraints()
    }
    
    private func setupNewsImageViewConstraints() {
        addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            newsImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.30),
            newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor)
        ])
    }
    
    private func setupArticleTitleConstraints() {
        addSubview(articleTitle)
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleTitle.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            articleTitle.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 8),
            articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    private func setupAbstractHeadlineConstraints() {
        addSubview(abstractTitle)
        abstractTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            abstractTitle.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 8),
            abstractTitle.leadingAnchor.constraint(equalTo: articleTitle.leadingAnchor),
            abstractTitle.trailingAnchor.constraint(equalTo: articleTitle.trailingAnchor)
        ])
    }
    
    public func configureCell(with article: Article) {
        articleTitle.text = article.title
        abstractTitle.text = article.abstract
        newsImageView.getImage(with: article.getAricleImageURL(for: .largeThumbnail)) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(systemName: "exclamationmark-octagon")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.newsImageView.image = image
                }
            }
        }
    }
    
}
