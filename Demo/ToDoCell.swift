//
//  ToDoCell.swift
//  Demo
//
//  Created by Globallogic on 18/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

typealias ToDoCellDidTapButtonHandler = () -> ()

class ToDoCell: UITableViewCell {
  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    var didTapButtonHandler: ToDoCellDidTapButtonHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setupView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: View Methods
    private func setupView() {
        let imageNormal = UIImage(named: "button-done-normal")
        let imageSelected = UIImage(named: "button-done-selected")
        
        doneButton.setImage(imageNormal, for: .normal)
        doneButton.setImage(imageNormal, for: .disabled)
        doneButton.setImage(imageSelected, for: .selected)
        doneButton.setImage(imageSelected, for: .highlighted)
        doneButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
    }

    // MARK: Actions
    @objc func didTapButton(sender: AnyObject) {
        if let handler = didTapButtonHandler {
            handler()
        }
    }
}
