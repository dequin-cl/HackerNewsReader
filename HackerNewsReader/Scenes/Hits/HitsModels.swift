//
//  HitsModels.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

enum HitsStrings: String, CaseIterable, Localizable {
    var tableName: String {
        return "Hits"
    }

    case Welcome
}

// swiftlint:disable nesting
enum Hits {
    // MARK: Use cases

    enum FetchHits {
        struct Request {
            let offset: Int
        }
        struct Response {
            let hits: [HitPresentationModel]
        }
        struct ViewModel {
            let hits: [HitViewModel]
        }
    }

    enum Show {
        struct Request {
            let hit: HitViewModel
        }
    }

    struct HitPresentationModel {
        let title: String
        let author: String
        let createdAt: Date
        let url: String
    }

    struct HitViewModel: Equatable {
        let title: String
        let subTitle: String
        let url: String
    }
}
// swiftlint:enable nesting
