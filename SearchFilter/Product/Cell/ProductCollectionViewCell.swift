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
    let price: String
}

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.backgroundColor = .lightGray
    }

    func configureCell(with data: ProductListCellData) {
        productImageView.sd_setImage(with: URL(string: data.image), completed: nil)
        titleLabel.text = data.name
        priceLabel.text = data.price
    }
}
