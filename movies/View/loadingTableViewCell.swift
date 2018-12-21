//
//  loadingTableViewCell.swift
//  movies
//
//  Created by Ahmed Salah on 12/18/18.
//  Copyright © 2018 Ahmed Salah. All rights reserved.
//

import UIKit

class loadingTableViewCell: UITableViewCell {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func awakeFromNib() {
        loading.startAnimating()
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        if let spinner = loading{
            spinner.startAnimating()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
