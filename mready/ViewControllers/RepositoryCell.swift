//
//  RepositoryCell.swift
//  mready
//
//  Created by Arnold Mitricã on 10.05.2021.
//

import UIKit

class RepositoryCell: UITableViewCell {
    static let reuseID = "repo"
    @IBOutlet var full_name: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(with viewModel:RepositoryCellViewModel){
        full_name.text = viewModel.full_name
    }
}
