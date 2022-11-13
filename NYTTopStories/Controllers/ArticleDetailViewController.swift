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

    
    public var article: Article?
    
    private let detailView = ArticleDetailView()
    
    
    public var dataPersistance: DataPersistence<Article>!

    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        updateUI()
        
        // adding  a UIBarButtonItem to the right side to the navigation bar title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(savedArticleButtonPressed(_:)))
    }
    
    private func updateUI() {
        guard let article = article else {
            fatalError("did not load an article")
        }
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
        guard let article = article else {
            return
        }
        do {
            // save to documents directory
            let itemHasBeenSaved = dataPersistance.hasItemBeenSaved(article)
            if itemHasBeenSaved == false {
                try dataPersistance.createItem(article)
            }else {
                print("Item has already saved in documents")
            }
        }catch {
            print("error saving article: \(error)")
        }
    }

}
