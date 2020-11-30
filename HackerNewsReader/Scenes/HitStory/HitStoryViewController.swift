//
//  HitStoryViewController.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

import UIKit
import WebKit

protocol HitStoryDisplayLogic: AnyObject {
    func loadURL(viewModel: HitStory.ShowStory.ViewModel)
    func setSceneTitle(viewModel: HitStory.Scene.ViewModel)
}

class HitStoryViewController: UIViewController, HitStoryDisplayLogic, WKNavigationDelegate {
    var interactor: HitStoryBusinessLogic?
    var router: (NSObjectProtocol & HitStoryRoutingLogic & HitStoryDataPassing)?

    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var webView: WKWebView!

    // MARK: Object lifecycle

    override  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        let interactor = HitStoryInteractor()
        let presenter = HitStoryPresenter()
        let router = HitStoryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override  func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        showProgressBar(animated: true)
        processHit()
    }

    func setupWebView() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true

        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "estimatedProgress" {
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)

            if webView.estimatedProgress > 0.98 {
               hideProgressBar(animated: true)
            }
        }
    }

    func showProgressBar(animated: Bool) {
        let duration = animated ? 0.6: 0.0

        UIView.animate(withDuration: duration) {
            self.progressBar.alpha = 1.0
        }
    }

    func hideProgressBar(animated: Bool) {
        let duration = animated ? 0.6: 0.0

        UIView.animate(withDuration: duration) {
            self.progressBar.alpha = 0.0
        }
    }

    // MARK: Methods
    func setSceneTitle(viewModel: HitStory.Scene.ViewModel) {

        if let imageName = viewModel.titleImageName {
            let imageView = UIImageView(image: UIImage(systemName: imageName))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            navigationItem.titleView = imageView
        } else {
            title = viewModel.title!
        }
    }

    func processHit() {
        interactor?.processHit()
    }

    func loadURL(viewModel: HitStory.ShowStory.ViewModel) {
        guard let url = URL(string: viewModel.url) else { return }

        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad

        webView.load(request)

    }

}
