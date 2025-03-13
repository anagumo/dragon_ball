//
//  TransformationTableViewCell.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 13/03/25.
//

import UIKit

final class TransformationTableViewCell: UITableViewCell {
    static let identifier = String(describing: TransformationTableViewCell.self)
    
    // MARK: UI Components
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var readMoreButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customizeButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with transformation: Transformation) {
        photoImageView.setImage(stringURL: transformation.photo)
        photoImageView.layer.cornerRadius = 8
        photoImageView.contentMode = .scaleAspectFill
        nameLabel.text = transformation.name
    }
    
    // MARK: UI Actions
    @IBAction func readMoreButtonTapped(_ sender: UIButton) {
        // TODO: Present Transformation Detail Modally
    }
}

extension TransformationTableViewCell {
    func customizeButtons() {
        var readMoreConfiguration = UIButton.Configuration.plain()
        readMoreConfiguration.attributedTitle = AttributedString(
            "Read More",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                .foregroundColor: UIColor.dbOrange
            ]))
        readMoreButton.configuration = readMoreConfiguration
    }
}
