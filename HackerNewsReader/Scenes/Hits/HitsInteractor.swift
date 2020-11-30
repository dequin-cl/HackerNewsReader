//
//  HitsInteractor.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

protocol HitsBusinessLogic {
    func grabHits()
    func grabOlderHits(request: Hits.FetchHits.Request)
}

protocol HitsDataStore {
    var hits: [Hits.HitPresentationModel] { get }
    var isFetchingOlderHits: Bool { get set }
}

class HitsInteractor: HitsBusinessLogic, HitsDataStore {
    var presenter: HitsPresentationLogic?
    var workerNetwork: HitsNetworkWorker = HitsNetworkWorker()
    var workerCoreData: HitsCoreDataWorker = HitsCoreDataWorker()

    private lazy var feedService: FeedService = { FeedService() }()

    var hits: [Hits.HitPresentationModel] = []
    var isFetchingOlderHits: Bool = false

    func grabHits() {

        grabFromCoreData { [weak self] in
            self?.grabFromNetwork {
                // After grabing from network and save them to core data
                // we call the grab from core data again.
                self?.grabFromCoreData { }
            }
        }
    }

    func grabOlderHits(request: Hits.FetchHits.Request) {
        guard !isFetchingOlderHits else {
            return
        }

        isFetchingOlderHits = true
        grabFromCoreData(offset: request.offset) {
            self.isFetchingOlderHits = false
        }
    }

    private func grabFromCoreData(offset: Int = 0, block: @escaping () -> Void = {}) {
        workerCoreData.fetchHits(offset: offset, block: { [weak self] (presentationModelHits, error) in
            if error == nil {

                if let datasourceHits = presentationModelHits {
                    if self != nil {
                        if offset == 0 {
                            self?.hits = datasourceHits
                        } else {
                            self?.hits.append(contentsOf: datasourceHits)
                        }

                        let response = Hits.FetchHits.Response(hits: self!.hits)
                        self?.presenter?.presentHits(response: response)
                    }
                }
                block()
            } else {
                // Alert the user of the problem fetching hits from Core Data
                //
                debugPrint("There's some problem")
            }
        })
    }

    private func grabFromNetwork(block: @escaping () -> Void) {
        workerNetwork.fetchHits(block: { [weak self] (hitsDTO, error) in
            if error == nil {
                self?.feedService.process(hitsDTO!) {
                    block()
                }
            } else {
                // Alert the user of the problem fetching hits from Network
                //
            }
        })
    }
}
