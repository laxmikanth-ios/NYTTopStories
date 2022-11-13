//
//  ArticleDetailView.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 13/11/22.
//

import UIKit

class ArticleDetailView: UIView {
    
    // image view
    // abstract headline
    // byline
    // date
    
    public lazy var newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    public lazy var abstractHeadLine: UILabel = {
       let label = UILabel()
        label.numberOfLines = 4
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Abstract headline"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupNewsImageViewConstraints()
        setupAbstractHeadlineConstraints()
    }
    
    private func setupNewsImageViewConstraints() {
        addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.40)
        ])
    }
    
    private func setupAbstractHeadlineConstraints() {
        addSubview(abstractHeadLine)
        abstractHeadLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            abstractHeadLine.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 8),
            abstractHeadLine.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: 8),
            abstractHeadLine.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: -8)
        ])
    }    

}
