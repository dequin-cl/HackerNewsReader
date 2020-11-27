//
//  Hits.swift
//  HackerNewsReader
//
//  Created by Iván on 27-11-20.
//

import Foundation

struct FeedDTO: Codable {
    let hitsPerPage: Int
    let hits: [HitDTO]
}

extension FeedDTO {
    init(data: Data) throws {
        self = try JSONDecoderWithFractionalSeconds().decode(FeedDTO.self, from: data)
    }
}
