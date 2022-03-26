//
//  CityCell.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 26/03/22.
//

import Foundation
import UIKit
import FNEasyBind

class CityCell: UITableViewCell, Reusable {
    static var reuseIdentifier: String = "CityCell"
    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    lazy var cityImageView: UIImageView = {
        let cityImageV = UIImageView()
        cityImageV.backgroundColor = .darkGray
        cityImageV.translatesAutoresizingMaskIntoConstraints = false
        cityImageV.contentMode = .scaleToFill
        cityImageV.clipsToBounds = true
        cityImageV.layer.cornerRadius = 10
        cityImageV.layer.masksToBounds = true
        return cityImageV
    }()

    lazy var cityTitle: UILabel = {
        let cityTitle = UILabel()
        cityTitle.translatesAutoresizingMaskIntoConstraints = false
        cityTitle.font = .preferredFont(forTextStyle: .title1)
        cityTitle.textColor = .white
        return cityTitle
    }()

    lazy var cityWeather: UILabel = {
        let cityWeather = UILabel()
        cityWeather.translatesAutoresizingMaskIntoConstraints = false
        cityWeather.font = .preferredFont(forTextStyle: .subheadline)
        cityWeather.textColor = .white
        return cityWeather
    }()

    private func setupViews() {
        self.contentView.addSubview(cityImageView)

        let labelsStack = UIStackView(arrangedSubviews: [cityTitle, cityWeather])
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(labelsStack)
        labelsStack.axis = .vertical
        labelsStack.alignment = .leading

        NSLayoutConstraint.activate([
            cityImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            cityImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            cityImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            cityImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),

            labelsStack.leadingAnchor.constraint(equalTo: self.contentView.readableContentGuide.leadingAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.readableContentGuide.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var model: CityViewModelProtocol? {
        didSet {
            self.cityTitle.text = model?.displayName

            model?.temperature
                .subscribe { [weak self] _, _ in
                    guard let self = self else {
                        return
                    }
                    self.cityWeather.text = self.model?.weatherConditions()
                    self.cityImageView.image = self.model?.skyline()
                }
                .disposed(by: &disposeBag)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
