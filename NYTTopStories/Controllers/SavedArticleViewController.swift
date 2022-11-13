//
//  SavedArticleViewController.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 12/11/22.
//

import UIKit
import DataPersistence

class SavedArticleViewController: UIViewController {

    // step 4: setting up the datapersistance and its delegate
    public var dataPersistance: DataPersistence<Article>!
    
    
    private let savedArticleView = SavedArticlesView()
    
    private var savedArticles  = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.savedArticleView.collectionView.reloadData()
            }
            if savedArticles.isEmpty == true {
                // setup our  view on the collection view backgroudview
                savedArticleView.collectionView.backgroundView = EmptyView(title: "Saved Articles", message: "There are currently no saved articles. Start browsing by tapping on the News icon.")
            }else {
                savedArticleView.collectionView.backgroundView = nil
            }
        }
    }
    
    
    override func loadView() {
        view = savedArticleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchSavedArticles()
        
        // setting up collectionview
        savedArticleView.collectionView.dataSource = self
        savedArticleView.collectionView.delegate = self
        
        // register collectionview cell
        savedArticleView.collectionView.register(SavedArticleCell.self, forCellWithReuseIdentifier: "savedArticleCell")
    }
    

    private func fetchSavedArticles() {
        do {
            savedArticles = try dataPersistance.loadItems()
        } catch {
            print("error saving articles: \(error)")
        }
    }

}

// setp 5: setting up the datapersistance and its delegate
// confirming to the DataPersistanceDelegate
extension SavedArticleViewController: DataPersistenceDelegate {
    
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        fetchSavedArticles()
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        print("Item was deleted")
        fetchSavedArticles()
    }
}

extension SavedArticleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedArticleCell", for: indexPath) as? SavedArticleCell else {
            fatalError("could not downcast to Saved Article Cell")
        }
        
        cell.backgroundColor = .white
        let savedArticle = savedArticles[indexPath.row]
        cell.configureCell(for: savedArticle)
        // step 1: registering as the delegate object
        cell.delegate = self
        return cell
    }
}

extension SavedArticleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let spacingBetweenItems: CGFloat = 10
        let numberOfItems: CGFloat = 2
        let totalSpacing: CGFloat = (2 * spacingBetweenItems) + (numberOfItems - 1) * spacingBetweenItems
        let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
        let itemHeight: CGFloat = maxSize.height * 0.30  // 30%
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // programatically a segue
        let article = savedArticles[indexPath.row]
        let detailVC = ArticleDetailViewController()
        // TODO: using initializer as opposed to injecting indivif=dual properties
        detailVC.article = article
        detailVC.dataPersistance = dataPersistance
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// step 2: Confirming SavedArticleCellDelegate
extension SavedArticleViewController: SavedArticleCellDelegate {
    func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article) {
        print("didSelectMoreButton: \(article.title)")
        
        // create an action sheet
        // cancel action
        // delete action
        // post MVP shareAction
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertAction in
            // TODO: write a delete helper function
            self.deleteArticle(article)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
        
    }
    
    private func deleteArticle(_ article: Article) {
        guard let index = savedArticles.firstIndex(of: article) else {
            return
        }
        do {
            // deletes from document directory
            try dataPersistance.deleteItem(at: index)
        }catch {
            print("error deleting article: \(error)")
        }
    }
}
