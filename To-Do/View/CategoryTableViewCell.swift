//
//  CategoryTableViewCell.swift
//  To-Do
//
//  Created by Moazam Mir on 11/10/20.
//

import UIKit
import SwipeCellKit
class CategoryTableViewCell: UITableViewCell  {
    
  
    

    @IBOutlet weak var categoryLabel: UILabel!
        @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var itemsCompletedLabel: UILabel!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var preferredImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = containerView.frame.height / 5
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        iconImageView.image = UIImage(named: "money.jpg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  

    
}
