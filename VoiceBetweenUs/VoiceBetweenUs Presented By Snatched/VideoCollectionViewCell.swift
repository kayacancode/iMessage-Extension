//
//  VideoCollectionViewCell.swift
//  VoiceBetweenUs
//
//  Created by C on 9/10/17.
//  Copyright © 2017 C. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var opacityView: UIView!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonUpload: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
