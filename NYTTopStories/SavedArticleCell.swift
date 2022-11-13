//
//  SavedArticleCell.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 13/11/22.
//

import UIKit
import ImageKit

// AnyObject - it will works only for classes not for value types
// step 1: creating custom protocol
protocol SavedArticleCellDelegate: AnyObject {
    func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article)
}

class SavedArticleCell: UICollectionViewCell {
    
    // step 2: custom protocol
    
    weak var delegate: SavedArticleCellDelegate?
    
    // to keep track of the current cells article
    private var currentArticle: Article!
    
    // more button
    // article title
    // news image
    
    public lazy var moreButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    public lazy var articleTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "Article Title"
        label.numberOfLines = 4
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var longGestureRecognizer: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(didLongPress(_:)))
        return gesture
    }()
    
    public lazy var newsImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "photo")
        iv.clipsToBounds = true
        iv.alpha = 0
        return iv
        
    }()
    
    private var isShowingImage = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupMoreButtonConstraints()
        setupArticleTitleConstraints()
        addGestureRecognizer(longGestureRecognizer) // a view by itself listens to long presses and its enabled by default
        setupNewsImageViewConstraints()
    }
    
    @objc private func moreButtonTapped(_ sender: UIButton) {
      //  print("button was pressed for current article \(currentArticle.title)")
        delegate?.didSelectMoreButton(self, article: currentArticle)
    }
    
    @objc private func didLongPress(_ gesture:UILongPressGestureRecognizer) {
        guard let cureentArticle = currentArticle else {
            return
        }
        if gesture.state == .began || gesture.state == .changed {
           // print("long pressed")
            
            return
        }
        isShowingImage.toggle() // if it is true -> false  //if it isfalse -> true
        
        newsImageView.getImage(with: currentArticle.getAricleImageURL(for: .threeByTwoSmallAt2X)) {[weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(systemName: "exclamationmark-octogon")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.newsImageView.image = image
                    self?.animate()
                }
            }
        }
    }
    
    private func animate() {
        let duration: Double = 1.0 // seconds
        
        if isShowingImage {
            UIView.transition(with: self, duration: duration, options: [.transitionFlipFromRight], animations: {
                self.newsImageView.alpha = 1.0
                self.articleTitle.alpha = 0.0
            }, completion: nil)
        }else {
            UIView.transition(with: self, duration: duration, options: [.transitionFlipFromLeft], animations: {
                self.newsImageView.alpha = 0.0
                self.articleTitle.alpha = 1.0
            }, completion: nil)
        }
    }
    private func setupMoreButtonConstraints() {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: topAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 44),
            moreButton.widthAnchor.constraint(equalTo: moreButton.heightAnchor)
        ])
    }
    
    private func setupArticleTitleConstraints() {
        addSubview(articleTitle)
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            articleTitle.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
            articleTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupNewsImageViewConstraints() {
        addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configureCell(for savedArticle:Article) {
        currentArticle = savedArticle // associated the cell with its article
        articleTitle.text = savedArticle.title
    }
}

