//
//  ZoomImageViewController.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/29/23.
//

import UIKit

class ZoomImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    private var image: UIImage
    
    init?(coder: NSCoder, image: UIImage) { // NSCoder is the class that archives via xml. Coming from storyboard, it is required
        self.image = image
        super.init(coder: coder) // used instead of (nib: nil, bundle: nil) because of the storyboard file
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5.0
        imageView.image = image
    }
}


extension ZoomImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
