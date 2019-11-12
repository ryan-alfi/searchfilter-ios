//
//  ProductCollectionViewCell.swift
//  SearchFilter
//
//  Created by Ari Fajrianda Alfi on 12/11/19.
//  Copyright © 2019 Ryan Alfi. All rights reserved.
//

import UIKit
import SDWebImage

struct ProductListCellData {
    let image: String
    let name: String
    let url: String
    let price: String
}

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    static let reuseIdentifier = "ProductCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.backgroundColor = .lightGray
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowRadius = 5.0
        
        let screenSize: CGRect = UIScreen.main.bounds
        if screenSize.width > 890.0 {
            heightConstraint.constant = 180.0
        }
    }

    func configureCell(with data: ProductListCellData) {
        productImageView.sd_setImage(with: URL(string: data.image), completed: nil)
        titleLabel.text = data.name
        priceLabel.text = data.price
    }
}
