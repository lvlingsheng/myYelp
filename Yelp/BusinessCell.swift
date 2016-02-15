//
//  BusinessCell.swift
//  Yelp
//
//  Created by 吕凌晟 on 16/2/7.
//  Copyright © 2016年 Timothy Lee. All rights reserved.
//

import UIKit


class BusinessCell: UITableViewCell {

    
    @IBOutlet weak var ThumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ReviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cateLabel: UILabel!
    
    var business:Business!{
        didSet{
            nameLabel.text=business.name
            ThumbImageView.setImageWithURL(business.imageURL!)
            cateLabel.text=business.categories
            addressLabel.text=business.address
            ReviewCountLabel.text="\(business.reviewCount!) Reviews"
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ThumbImageView.layer.cornerRadius=3
        ThumbImageView.clipsToBounds=true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
