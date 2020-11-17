//
//  CustomCollectionViewCell.swift
//  To-Do
//
//  Created by Moazam Mir on 11/17/20.
//


import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static public let reuseID = "CustomCollectionViewCell"
    
    
    @IBOutlet weak var iconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let redView = UIView(frame: bounds)
        let image = UIImage(named: "book-1.jpg")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: redView.frame.width, height: redView.bounds.height)
      //  backgroundView?.addSubview(imageView)
        
     //   redView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        redView.addSubview(imageView)
        self.backgroundView = redView

        let blueView = UIView(frame: bounds)
        blueView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        blueView.alpha = 0.5
        self.selectedBackgroundView = blueView
    }
    
    func showIcon() {
        iconView.alpha = 1.0
    }
    
    func hideIcon() {
        iconView.alpha = 0.0
    }
}
