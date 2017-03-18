//
//  KTMHeaderCollectionViewCell.swift
//  KTMPageControl
//
//  Created by Kishore Thejasvi on 14/02/2017.
//  Copyright © 2017 Kishore Thejasvi. All rights reserved.
//

import UIKit

class KTMHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
    
    var highlightViewColor = UIColor.white
    var normalTextAlpha: CGFloat = 0.75
    
    var shouldSetHighlightViewColor = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shouldSetHighlightViewColor = true
    }
    
    func should(hightlightCell status: Bool) {
        if status {
            highlightView.isHidden = false
            textLabel.alpha = 1.0
        }
        else {
            highlightView.isHidden = true
            textLabel.alpha = normalTextAlpha
        }
        
        if shouldSetHighlightViewColor {
            shouldSetHighlightViewColor = false
            highlightView.backgroundColor = highlightViewColor
        }
    }
}
