//
//  HitTableViewCell.swift
//  HackerNewsReader
//
//  Created by Iván on 29-11-20.
//

import UIKit

class HitTableViewCell: UITableViewCell {
    static let identifier = String(describing: HitTableViewCell.self)

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelSubtitle: UILabel!

    func configure(with hit: Hits.HitViewModel) {
        labelTitle.text = hit.title
        labelSubtitle.text = hit.subTitle
    }
}
