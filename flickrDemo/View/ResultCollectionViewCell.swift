//
//  ResultCollectionViewCell.swift
//  flickrDemo
//
//  Created by aaron on 2019/7/22.
//  Copyright © 2019 aaron. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgResult: UIImageView!
    
    @IBOutlet weak var txtResult: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    override func awakeFromNib() {
        super  .awakeFromNib()
        
    }
}

