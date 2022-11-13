//
//  NewsFeedViewController.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 12/11/22.
//

import UIKit
import DataPersistence

class NewsFeedViewController: UIViewController {
    
    private let newsFeedView = NewsFeedView()
    
    // step 2: setting up the datapersistance and its delegate
    // since we  need an instance passed to the ArticleDetailViewController
    public var dataPersistance: DataPersistence<Article>!
    
    // data for our collection view
    private var newsArticles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.newsFeedView.collectionView.reloadData()
            }
        }
    }

    private var sectionName = "Technology"
    
    override func loadView() {
        view = newsFeedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground // white when dark mode is off , black when dark mode is on
    
        // Setting up Collection View Delegate and DataSource
        newsFeedView.collectionView.delegate = self
        newsFeedView.collectionView.dataSource = self
        
        // register a collection view cell
        newsFeedView.collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "articleCell")
        
        // setup searchbar
        newsFeedView.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchStories()
    }

    private func fetchStories(for section: String = "Technology") {
        
        // retreive section name from UserDefaults
        if let sectionName = UserDefaults.standard.string(forKey: UserKey.sectionName) {
            if sectionName != self.sectionName {
                // we are looking at a new section
                // make a new query
                queryAPI(for: sectionName)
                self.sectionName = sectionName
            }else {
                queryAPI(for: sectionName)
            }
        }else {
            // use the user defaults section name
            queryAPI(for: sectionName)
        }
        
   
    }
    
    private func queryAPI(for section: String) {
        NYTTopStoriesAPIClient.fetchTopStories(for: section) { [weak self] result in
            switch result {
            case .failure(let appError):
                print("error fetching stories: \(appError)")
            case .success(let articles):
                print("found \(articles.count) articles")
                self?.newsArticles = articles
            }
        }
    }
    
}

extension NewsFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? NewsCell else {
            fatalError("could not downcast to NewsCell")
        }
        let article = newsArticles[indexPath.row]
        cell.configureCell(with: article)
        cell.backgroundColor = .white
        return cell
    }
    
    
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    // return item size
    // item height ~ 30% of height of device
    // item width = 100% of width of device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.20  // 20%
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = newsArticles[indexPath.row]
        let articleDVC = ArticleDetailViewController()
        // TODO: after assesment we will be using initializers as dependency injection mechanism
        // like let articleDVC = ArticleDetailViewCOntroller(article)
        articleDVC.article = article
        // step 3: setting up the datapersistance and its delegate
        articleDVC.dataPersistance = dataPersistance
        navigationController?.pushViewController(articleDVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if newsFeedView.searchBar.isFirstResponder {
            newsFeedView.searchBar.resignFirstResponder()
        }
    }
}

extension NewsFeedViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            // if text is empty reload all articles
            fetchStories()
            return
        }
        
        // filter articles based on searchtext
        newsArticles = newsArticles.filter { $0.title.lowercased().contains(searchText.lowercased())}
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked: \(searchBar.searchTextField.text ?? "")")
    }
    
}
