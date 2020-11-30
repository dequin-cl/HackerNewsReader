//
//  HitsPresenter.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

protocol HitsPresentationLogic {
    func presentHits(response: Hits.FetchHits.Response)
    func presentOlderHits(response: Hits.FetchHits.Response)
    func presentHit()
}

class HitsPresenter: HitsPresentationLogic {
    weak var viewController: HitsDisplayLogic?
    lazy var dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    func presentHits(response: Hits.FetchHits.Response) {

        var hitsVM: [Hits.HitViewModel] = []
        response.hits.forEach {
            let relativeDate = dateFormatter.localizedString(for: $0.createdAt, relativeTo: Date())

            let hitVM = Hits.HitViewModel(title: $0.title,
                                          subTitle: "\($0.author) - \(relativeDate)",
                                          url: $0.url)
            hitsVM.append(hitVM)
        }

        self.viewController?.displayHits(viewModel: Hits.FetchHits.ViewModel(hits: hitsVM))
    }

    func presentOlderHits(response: Hits.FetchHits.Response) {

        var hitsVM: [Hits.HitViewModel] = []
        response.hits.forEach {
            let relativeDate = dateFormatter.localizedString(for: $0.createdAt, relativeTo: Date())

            let hitVM = Hits.HitViewModel(title: $0.title,
                                          subTitle: "\($0.author) - \(relativeDate)",
                                          url: $0.url)
            hitsVM.append(hitVM)
        }

        self.viewController?.displayOlderHits(viewModel: Hits.FetchHits.ViewModel(hits: hitsVM))
    }

    func presentHit() {
        viewController?.displaySelectedHitStory()
    }

}
