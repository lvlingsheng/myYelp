//
//  SwitchCell.swift
//  Yelp
//
//  Created by 吕凌晟 on 16/2/10.
//  Copyright © 2016年 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate{
    optional func switchCell(switchCell:SwitchCell, didChangeValue value:Bool)
}

class SwitchCell: UITableViewCell {
    
    weak var delegate:SwitchCellDelegate?
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged(){
        if(delegate != nil){
            delegate?.switchCell!(self, didChangeValue: onSwitch.on)
        }
    }

}
