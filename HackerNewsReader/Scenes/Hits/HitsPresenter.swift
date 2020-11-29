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
}

class HitsPresenter: HitsPresentationLogic {
    weak var viewController: HitsDisplayLogic?

    func presentHits(response: Hits.FetchHits.Response) {

        // On a typical process this could be formatted
        // ie: the published date
        viewController?.displayHits(viewModel: Hits.FetchHits.ViewModel(hits: response.hits))
    }
}
