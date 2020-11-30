//
//  HitStoryInteractor.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import Foundation

protocol HitStoryBusinessLogic {
    func processHit()
}

protocol HitStoryDataStore {
    var hitURL: String { get set }
}

class HitStoryInteractor: HitStoryBusinessLogic, HitStoryDataStore {
    var presenter: HitStoryPresentationLogic?
    var worker: HitStoryWorker = HitStoryWorker()
    var hitURL: String = ""

    // MARK: Methods

    func processHit() {
        presenter?.presentURL(response: HitStory.ShowStory.Response(url: hitURL))

        if hitURL.starts(with: "https") {
            presenter?.presentTitle(response: HitStory.Scene.Response(title: nil, titleImageName: "lock"))
        } else {
            presenter?.presentTitle(response: HitStory.Scene.Response(title: HitStoryStrings.NotSecure, titleImageName: nil))

        }
    }
}
