//
//  Hit.swift
//  HackerNewsReader
//
//  Created by Iván on 27-11-20.
//

import Foundation

struct HitDTO: Codable {
    let author: String
    let storyTitle: String?
    let title: String?
    let createdAt: Date
    let objectID: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case storyTitle = "story_title"
        case author, title, objectID
    }
}

extension HitDTO {
    init(data: Data) throws {
        self = try JSONDecoderWithFractionalSeconds().decode(HitDTO.self, from: data)
    }
}

// MARK: - Encode/decode helpers

func JSONDecoderWithFractionalSeconds() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
    return decoder
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.iso8601withFractionalSeconds.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container,
                  debugDescription: "Invalid date: " + string)
        }
        return date
    }
}
