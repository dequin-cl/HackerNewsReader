//
//  HitStoryViewControllerTests.swift
//  HackerNewsReader
//
//  Created on 30-11-20.
//  Copyright © 2020 @dequin_cl All rights reserved.
//

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable force_cast
// swiftlint:disable identifier_name
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length

@testable import HackerNewsReader
import WebKit
import XCTest

class HitStoryViewControllerTests: XCTestCase {
    // MARK: Subject under test
    var sut: HitStoryViewController!
    var spyInteractor: HitStoryBusinessLogicSpy!
    var spyRouter: HitStoryRoutingLogicSpy!
    var window: UIWindow!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        window = UIWindow()
        setupHitStoryViewController()
    }

    override  func tearDown() {
        spyInteractor = nil
        spyRouter = nil
        sut = nil
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupHitStoryViewController() {

        sut = HitStoryViewController.instantiate(from: .HitStory)

        spyInteractor = HitStoryBusinessLogicSpy()
        sut.interactor = spyInteractor

        spyRouter = HitStoryRoutingLogicSpy()
        sut.router = spyRouter

        sut.preloadView()
    }

    // MARK: Tests

     func testShouldDoSomethingWhenViewIsLoaded() {
        // Given
        let mockWebView = WebViewMock()
        sut.webView = mockWebView
        // When
        sut.setupWebView()
        // Then
        let vc = sut.webView.navigationDelegate as! UIViewController
        XCTAssertEqual(vc, sut, "The VC should be the navigation delegate")
        XCTAssertEqual(mockWebView.observer, sut, "The VC should be the oberver")
        XCTAssertEqual(mockWebView.keyPath, "estimatedProgress", "The VC should be the observer for the estimater progress")

    }

    func testObserveValueChangesProgressBarWhenKeyIsProgress() {
        /// Given
        let keyPath = "estimatedProgress"
        let progressMock = ProgressViewMock()
        sut.progressBar = progressMock
        let mockWebView = WebViewMock()

        sut.webView = mockWebView
        /// When
        sut.observeValue(forKeyPath: keyPath, of: nil, change: nil, context: nil)
        /// Then
        XCTAssertEqual(progressMock.progressMocked, Float(mockWebView.estimatedProgress), "The VC should advance the UIProgressView in the same progress as the WebView")
    }

    func testLoadURL() {
        /// Given
        let mockWebView = WebViewMock()
        sut.webView = mockWebView
        let vm = HitStory.ShowStory.ViewModel(url: "testURL")
        /// When
        sut.loadURL(viewModel: vm)
        /// Then
        XCTAssertEqual(mockWebView.url?.absoluteString, "testURL", "The VC should use the URL from the Hit that is in the DataStore")
    }
}

class WebViewFullProgressMock: WKWebView {

    override var estimatedProgress: Double {
        return 1
    }
}

class WebViewMock: WKWebView {
    var observer: NSObject?
    var keyPath: String?

    override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {

        self.observer = observer
        self.keyPath = keyPath
    }

    override var estimatedProgress: Double {
        return 0.4
    }
}

class ProgressViewMock: UIProgressView {
    var progressMocked: Float?
    var animatedMocked: Bool?
    override func setProgress(_ progress: Float, animated: Bool) {
        self.progressMocked = progress
        self.animatedMocked = animated
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
