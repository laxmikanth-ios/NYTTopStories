//
//  NewsFeedViewController.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 12/11/22.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    private let newsFeedView = NewsFeedView()
    

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
        fetchStories()
    }
    

    private func fetchStories(for section: String = "Technology") {
        NYTTopStoriesAPIClient.fetchTopStories(for: section) { result in
            switch result {
            case .failure(let appError):
                print("error fetching stories: \(appError)")
            case .success(let articles):
                print("found \(articles.count) articles")
            }
        }
    }
    
}

extension NewsFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath)
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
}
