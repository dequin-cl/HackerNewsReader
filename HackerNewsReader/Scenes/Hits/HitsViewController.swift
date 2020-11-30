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
    func displayOlderHits(viewModel: Hits.FetchHits.ViewModel)
    func displaySelectedHitStory()
}

class HitsViewController: UITableViewController {
    var interactor: HitsBusinessLogic?
    var router: (NSObjectProtocol & HitsRoutingLogic & HitsDataPassing)?

    var hits: [Hits.HitViewModel] = []

    var theresNoMoreOlderHits: Bool = false
    lazy var spinnerForFooter: UIView = {
        let footerView = UIView(frame: CGRect(origin: .zero,
                                              size: CGSize(width: self.view.frame.size.width,
                                                           height: 100))
        )

        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        return footerView
    }()
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

        self.refreshControl?.addTarget(self,
                                       action: #selector(refresh),
                                       for: UIControl.Event.valueChanged
        )
        // Assures that we aren't testing
        guard ProcessInfo.processInfo.environment["XCTestSessionIdentifier"] == nil else { return }
        startGrab()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.tableFooterView = spinnerForFooter
    }

    // MARK: Do something

    func startGrab() {

        interactor?.grabHits()
    }

    @objc func refresh(sender: AnyObject) {

        interactor?.grabHits()
    }

    func displaySelectedHitStory() {
        router?.routeToStoryDetail(segue: nil)
    }
}

// MARK: - HitsDisplayLogic
extension HitsViewController: HitsDisplayLogic {

    func displayHits(viewModel: Hits.FetchHits.ViewModel) {

        hits = viewModel.hits

        DispatchQueue.main.async {

            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    func displayOlderHits(viewModel: Hits.FetchHits.ViewModel) {

        let countHits = hits.count
        let countViewModelHits = viewModel.hits.count
        hits = viewModel.hits

        DispatchQueue.main.async {

            if self.tableView.tableFooterView != nil {
                self.tableView.tableFooterView = nil

                self.theresNoMoreOlderHits = (countHits == countViewModelHits)
            }

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
        var cell: HitTableViewCell!

        cell = (tableView.dequeueReusableCell(withIdentifier: HitTableViewCell.identifier, for: indexPath) as! HitTableViewCell)

        cell.configure(with: hits[indexPath.row])

        return cell
    }
}

// MARK: - Delegate
extension HitsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = Hits.Show.Request(hit: hits[indexPath.row])
        interactor?.selectHit(request: request)
    }
}

extension HitsViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !hits.isEmpty else {
            return
        }

        let position = scrollView.contentOffset.y

        if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {

            guard let isFetchingOlderHits = router?.dataStore?.isFetchingOlderHits, !isFetchingOlderHits else {
                return
            }

            if !theresNoMoreOlderHits {
                self.tableView.tableFooterView = spinnerForFooter
            }

            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {  [self] in

                let request = Hits.FetchHits.Request(offset: hits.count)
                self.interactor?.grabOlderHits(request: request)
            }
        }
    }
}
