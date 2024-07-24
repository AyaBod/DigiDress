//
//  PhotoCollectionViewCell.swift
//  DigiDress2.2
//
//  Created by AYANNA BODAKE on 7/8/24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    private var selectionOverlay: UIView!

        override func awakeFromNib() {
            super.awakeFromNib()
            setupSelectionOverlay()
        }

        private func setupSelectionOverlay() {
            selectionOverlay = UIView(frame: contentView.bounds)
            selectionOverlay.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
            selectionOverlay.isHidden = true
            contentView.addSubview(selectionOverlay)
        }

        func setSelected(_ selected: Bool) {
            selectionOverlay.isHidden = !selected
        }
    }
   

    

