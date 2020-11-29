//
//  HitsViewController.swift
//  HackerNewsReader
//
//  Created on 28-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit

protocol HitsDisplayLogic: class {
    func displayHits(viewModel: Hits.FetchHits.ViewModel)
}

class HitsViewController: UITableViewController {
    var interactor: HitsBusinessLogic?
    var router: (NSObjectProtocol & HitsRoutingLogic & HitsDataPassing)?

    var hits: [Hits.HitViewModel] = []
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = HitsInteractor()
        let presenter = HitsPresenter()
        let router = HitsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        startGrab()
    }

    // MARK: Do something

    func startGrab() {
        // Assures that we aren't testing
//        guard ProcessInfo.processInfo.environment["XCTestSessionIdentifier"] == nil else { return }

        interactor?.grabHits()
    }

    //@IBOutlet weak var nameTextField: UITextField!
}

// MARK: - HitsDisplayLogic
extension HitsViewController: HitsDisplayLogic {

    func displayHits(viewModel: Hits.FetchHits.ViewModel) {
        hits = viewModel.hits
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - DataSource
extension HitsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!

        cell = tableView.dequeueReusableCell(withIdentifier: "hit", for: indexPath)

        cell.textLabel?.text = hits[indexPath.row].title
        cell.detailTextLabel?.text = hits[indexPath.row].subTitle

        return cell
    }
}
