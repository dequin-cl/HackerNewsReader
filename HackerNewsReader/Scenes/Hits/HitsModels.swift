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
    case HitWithoutURL
    case CantNavigateTo
    case CantShowDetails
    case OK

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

    enum NoShow {
        struct Response {
            let title: Localizable
            let message: String
            let buttonTitle: Localizable
        }
        struct ViewModel {
            let title: String
            let message: String
            let buttonTitle: String
        }
    }

    enum Delete {
        struct Request {
            let hit: HitViewModel
            let row: Int
        }
        struct Response {
            let row: Int
        }
        struct ViewModel {
            let row: Int
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
