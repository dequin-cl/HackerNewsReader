//
//  HitStoryPresenter.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

protocol HitStoryPresentationLogic {
    func presentURL(response: HitStory.ShowStory.Response)
}

class HitStoryPresenter: HitStoryPresentationLogic {
    weak  var viewController: HitStoryDisplayLogic?

    // MARK: Methods

    func presentURL(response: HitStory.ShowStory.Response) {
        viewController?.loadURL(viewModel: HitStory.ShowStory.ViewModel(url: response.url))
    }
}
