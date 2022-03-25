//
//  CityCell.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 26/03/22.
//

import Foundation
import UIKit

class CityCell: UITableViewCell, Reusable {
    static var reuseIdentifier: String = "CityCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var model: CityViewModel? {
        didSet {
            self.textLabel?.text = model?.displayName
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
