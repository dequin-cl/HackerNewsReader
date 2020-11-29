//
//  HitTableViewCellTests.swift
//  HackerNewsReaderTests
//
//  Created by Iván on 29-11-20.
//

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable force_cast
// swiftlint:disable identifier_name
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length

@testable import HackerNewsReader

import XCTest

class HitTableViewCellTests: XCTestCase {

    func testConfiguration() {
        /// Given
        let controller = HitsViewController.instantiate(from: .Hits)
        let actualCell = controller.tableView.dequeueReusableCell(withIdentifier: HitTableViewCell.identifier, for: IndexPath(row: 0, section: 0)) as! HitTableViewCell
        let hitVM = Hits.HitViewModel(title: "Test", subTitle: "Sub Test")
        /// When
        actualCell.configure(with: hitVM)
        /// Then
        XCTAssertEqual(actualCell.labelTitle.text, hitVM.title)
        XCTAssertEqual(actualCell.labelSubtitle.text, hitVM.subTitle)
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
