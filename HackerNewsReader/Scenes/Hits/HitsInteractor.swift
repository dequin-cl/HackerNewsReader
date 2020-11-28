//
//  HitsInteractor.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

protocol HitsBusinessLogic {
}

protocol HitsDataStore {
    //var name: String { get set }
}

class HitsInteractor: HitsBusinessLogic, HitsDataStore {
    var presenter: HitsPresentationLogic?
    var worker: HitsWorker?
    //var name: String = ""

}
