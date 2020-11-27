//
//  Hits.swift
//  HackerNewsReader
//
//  Created by Iván on 27-11-20.
//

import Foundation

struct Feed: Codable {
    let hitsPerPage: Int
    let hits: [Hit]
}

extension Feed {
    init(data: Data) throws {
        self = try JSONDecoderWithFractionalSeconds().decode(Feed.self, from: data)
    }
}
