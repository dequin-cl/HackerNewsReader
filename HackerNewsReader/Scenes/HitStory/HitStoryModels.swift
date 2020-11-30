//
//  HitStoryModels.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

// swiftlint:disable nesting
enum HitStory {

    enum ShowStory {
        struct Request {
        }
        struct Response {
            let url: String
        }
        struct ViewModel {
            let url: String
        }
    }

    enum Scene {
        struct Response {
            let title: String?
            let titleImageName: String?
        }
        struct ViewModel {
            let title: String?
            let titleImageName: String?
        }
    }
}

// swiftlint:enable nesting
