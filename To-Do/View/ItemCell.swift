//
//  ItemCell.swift
//  To-Do
//
//  Created by Moazam Mir on 11/12/20.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var itemTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        containerView.layer.cornerRadius = containerView.frame.height / 5
        // Configure the view for the selected state
    }
    
}
