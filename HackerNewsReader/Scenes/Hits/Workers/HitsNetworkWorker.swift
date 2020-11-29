//
//  HitsNetworkWorker.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

public struct Configuration {
    private init() {}

    struct API {
        private init() {}

        // https://hn.algolia.com/api
        static let byDate =  "https://hn.algolia.com/api/v1/search_by_date?query=ios"
    }
}

class HitsNetworkWorker {
    func fetchHits(session: URLSession = URLSession(configuration: .default),
                   block: @escaping ([HitDTO]?, Error?) -> Void) {

        guard let url = URL(string: Configuration.API.byDate) else {
            fatalError("Should be able to instantiate an URL from the API endpoint")
        }

        let task = session.dataTask(with: url) { (data, _, error) in
            if error == nil {
                if let safeData = data {
                    do {
                        let results = try FeedDTO(data: safeData)
                        block(results.hits, nil)
                    } catch {
                        print(error)
                        block(nil, error)
                    }
                }
            } else {
                block(nil, error)
            }
        }
        task.resume()

    }
}
