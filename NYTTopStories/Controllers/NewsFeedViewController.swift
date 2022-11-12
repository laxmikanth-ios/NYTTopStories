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
        newsFeedView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "articleCell")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        let itemHeight: CGFloat = maxSize.height * 0.30  // 30%
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
