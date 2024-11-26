//
//  ViewController.swift
//  ALifeLabCompanionApp
//
//  Created by Yamazaki Mitsuyoshi on 2024/11/25.
//

import UIKit
@preconcurrency import WebKit

final class ViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(.init(url: .init(string: "https://mitsuyoshi-yamazaki.github.io/ALifeLab/pages/drawer.html?system.run=0&system.auto_download=0")!))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        webView.reload()
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.shouldPerformDownload {
            decisionHandler(.download)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
}

extension ViewController: WKDownloadDelegate {
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        let fileManager = FileManager.default
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let destinationURL = documentsURL.appendingPathComponent(suggestedFilename)
            print("save downloading file to \(suggestedFilename)")
            completionHandler(destinationURL)
        } else {
            print("unable to find save location")
            completionHandler(nil)
        }
    }

    func downloadDidFinish(_ download: WKDownload) {
        print("download finished: \(download)")
    }

    func download(_ download: WKDownload, didFailWithError error: any Error, resumeData: Data?) {
        print("download failed with error: \(error)")
    }
}
