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
}

protocol HitsDataStore {
    var hits: [Hits.HitPresentationModel] { get }
}

class HitsInteractor: HitsBusinessLogic, HitsDataStore {
    var presenter: HitsPresentationLogic?
    var workerNetwork: HitsNetworkWorker = HitsNetworkWorker()
    var workerCoreData: HitsCoreDataWorker = HitsCoreDataWorker()

    private let feedService = FeedService()

    var hits: [Hits.HitPresentationModel] = []

    func grabHits() {

        grabFromCoreData { [weak self] in
            self?.grabFromNetwork {
                // After grabing from network and save them to core data
                // we call the grab from core data again.
                self?.grabFromCoreData { }
            }
        }
    }

    private func grabFromCoreData(block: @escaping () -> Void) {
        workerCoreData.fetchHits(block: { [weak self] (presentationModelHits, error) in
            if error == nil {

                if let datasourceHits = presentationModelHits {
                    self?.hits = datasourceHits
                    let response = Hits.FetchHits.Response(hits: datasourceHits)
                    self?.presenter?.presentHits(response: response)
                }
                block()
            } else {
                // Alert the user of the problem fetching hits from Core Data
                //
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
