//
//  ZoomImageViewController.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 14/11/22.
//

import UIKit

class ZoomImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var image: UIImage // fully encapsulated property
    
    
    // Its comming from storyboard use coder: NSCoder
    // Its comming from programatically dont use  coder: NSCoder
    init?(coder: NSCoder, _ image: UIImage) {
        self.image = image
        super.init(coder: coder) // By Using storyboard use super.init(coder:coder)
        
    }
    
    // If we are using custom initializer use required init?(coder: NSCoder)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5.0 // 1.0 by default
    }
    
}

extension ZoomImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
