//
//  TransformationTableViewCell.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 13/03/25.
//

import UIKit

protocol TransformationTableViewCellProtocol: AnyObject {
    func readButtonTapped(transformation: Transformation)
}

final class TransformationTableViewCell: UITableViewCell {
    static let identifier = String(describing: TransformationTableViewCell.self)
    
    // MARK: UI Components
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var readMoreButton: UIButton!
    
    private var transformation: Transformation?
    weak var transformationTableViewCellDelegate: TransformationTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeButtons()
    }
    
    func configure(with transformation: Transformation) {
        self.transformation = transformation
        photoImageView.layer.backgroundColor = UIColor.systemGray6.cgColor
        photoImageView.setImage(stringURL: transformation.photo)
        photoImageView.layer.cornerRadius = 8
        photoImageView.contentMode = .scaleAspectFill
        nameLabel.text = transformation.name
    }
    
    // MARK: UI Actions
    @IBAction func readButtonTapped(_ sender: UIButton) {
        guard let transformation else {
            return
        }
        transformationTableViewCellDelegate?.readButtonTapped(transformation: transformation)
    }
}

// MARK: UI Customization
extension TransformationTableViewCell {
    func customizeButtons() {
        var readMoreConfiguration = UIButton.Configuration.filled()
        readMoreConfiguration.cornerStyle = .capsule
        readMoreConfiguration.baseBackgroundColor = .dbOrange
        readMoreConfiguration.image = UIImage(systemName: "book.closed.circle.fill")
        readMoreConfiguration.imagePlacement = .leading
        readMoreConfiguration.imagePadding = 4
        readMoreConfiguration.baseForegroundColor = .dbBlack
        readMoreConfiguration.attributedTitle = AttributedString(
            "Read",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                .foregroundColor: UIColor.dbBlack
            ]))
        readMoreButton.configuration = readMoreConfiguration
    }
}
