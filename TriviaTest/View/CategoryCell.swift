//
//  CategoryCell.swift
//  TriviaTest
//
//  Created by Anton Trofimenko on 10/03/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateViewBy(category: (catId: Int, catName: String, catColor: UIColor)) {
        categoryImage.image = UIImage(named: "cat\(category.catId)")
        categoryName.text = category.catName
        backgroundColor = category.catColor
    }

}
