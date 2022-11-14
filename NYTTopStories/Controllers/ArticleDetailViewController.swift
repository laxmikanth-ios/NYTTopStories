//
//  ArticleDetailViewController.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 13/11/22.
//

import UIKit
import ImageKit
import DataPersistence

class ArticleDetailViewController: UIViewController {

    // properties
    private let detailView = ArticleDetailView()

    private var article: Article
    
    
    
    private var dataPersistance: DataPersistence<Article>

    private var bookmarkBarButton: UIBarButtonItem!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    // initializers
    init(_ dataPersistance: DataPersistence<Article>, article: Article) {
        self.dataPersistance = dataPersistance
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder): has not been implemented")
    }
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        // adding  a UIBarButtonItem to the right side to the navigation bar title
        bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(savedArticleButtonPressed(_:)))
        navigationItem.rightBarButtonItem = bookmarkBarButton
        
        updateUI()

        // setup gesture
        detailView.newsImageView.isUserInteractionEnabled = true
        detailView.newsImageView.addGestureRecognizer(tapGesture)
    }
    
    private func updateUI() {
        updateBookmarkState(article)
        navigationItem.title = article.title
        detailView.abstractHeadLine.text = article.abstract
        detailView.newsImageView.getImage(with: article.getAricleImageURL(for: .superJumbo)) {[weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.detailView.newsImageView.image = UIImage(systemName: "exclamationmark-octogon")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.detailView.newsImageView.image = image
                }
            }
        }
        
    }
    
    @objc
    func savedArticleButtonPressed(_ sender: UIBarButtonItem) {
        if dataPersistance.hasItemBeenSaved(article) {
            if let index = try? dataPersistance.loadItems().firstIndex(of: article) {
                do {
                    try dataPersistance.deleteItem(at: index)
                } catch {
                    print("error deleting article: \(error)")
                }
            }
        } else {
            do {
                // save to documents directory
                try dataPersistance.createItem(article)
            } catch {
                print("error saving article: \(error)")
            }
        }
        
        // update bookmark state
        updateBookmarkState(article)
    }
    
    @objc
    func didTap(_ gesture:UITapGestureRecognizer) {
        print("image was tapped")
        let image = detailView.newsImageView.image ?? UIImage()
        
        // we need to get an instance of the ZoomImageViewController from storyboard
        let zoomImageStoryboard = UIStoryboard(name: "ZoomImage", bundle: nil)
        
        let zoomImageVC = zoomImageStoryboard.instantiateViewController(identifier: "ZoomImageViewController") { coder in // why we need coder object means we need to reconstruct our initializer
            return ZoomImageViewController(coder: coder, image)
        }
        present(zoomImageVC, animated: true)
    }
    
    private func updateBookmarkState(_ article: Article) {
        if dataPersistance.hasItemBeenSaved(article) {
          bookmarkBarButton.image = UIImage(systemName: "bookmark.fill")
        } else {
          bookmarkBarButton.image = UIImage(systemName: "bookmark")
        }
      }
}
