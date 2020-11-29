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
    //var name: String { get set }
}

class HitsInteractor: HitsBusinessLogic, HitsDataStore {
    var presenter: HitsPresentationLogic?
    var workerNetwork: HitsNetworkWorker?
    var workerCoreData: HitsCoreDataWorker?
    //var name: String = ""
    private let feedService = FeedService()

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
        workerCoreData?.fetchHits(block: { (hits, error) in
            if error == nil {
                let response = Hits.FetchHits.Response(hits: hits!)
                self.presenter?.presentHits(response: response)
                block()
            } else {
                // Alert the user of the problem fetching hits from Core Data
                //
            }
        })
    }

    private func grabFromNetwork(block: @escaping () -> Void) {
        workerNetwork?.fetchHits(block: { [weak self] (hitsDTO, error) in
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
