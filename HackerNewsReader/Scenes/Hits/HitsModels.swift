//
//  HitsModels.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

// swiftlint:disable nesting
enum Hits {
    // MARK: Use cases

    enum FetchHits {
        struct Response {
            let hits: [HitPresentationModel]
        }
        struct ViewModel {
            let hits: [HitViewModel]
        }
    }

    struct HitPresentationModel {
        let title: String
        let author: String
        let createdAt: Date
        let url: String
    }

    struct HitViewModel {
        let title: String
        let subTitle: String
    }
}
// swiftlint:enable nesting
