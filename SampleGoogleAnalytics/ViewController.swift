//
//  ViewController.swift
//  SampleGoogleAnalytics
//
//  Created by nagisa-kosuge on 2017/10/12.
//  Copyright © 2017年 RyoKosuge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // GAITrackedViewControllerのtrackerは`GAI.sharedInstance().defaultTracker`が使用されます
        // 独自のものを使う場合は指定する必要があります
        // self.tracker = self.tracker()

        // スクリーン名の指定
        // viewDidAppearのタイミングで送信されるので、それまでにセットしておく
        // screenNameがnilの場合は送信されない
        // self.screenName = "トップ"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

private let tapCountKey = "customDimensionTapCount"

extension ViewController {

    @IBAction func tapButton(_ button: UIButton) {
        sendEvent(category: "TOP", action: "タップ", label: "ボタン")
        let tapCount = UserDefaults.standard.integer(forKey: tapCountKey) + 1
        UserDefaults.standard.set(tapCount, forKey: tapCountKey)
    }

    func sendEvent(category: String, action: String, label: String) {
        let tracker = self.tracker()
        let params = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: nil).build() as! [AnyHashable: Any]
        tracker?.send(params)
    }

}

extension ViewController {

    func sendScreen() {
        let tracker = self.tracker()
        tracker?.set(kGAIScreenName, value: "トップ")
        let params = GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable: Any]
        tracker?.send(params)
    }

}

extension ViewController {

    func tracker() -> GAITracker? {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.allowIDFACollection = true
        let tapCount = UserDefaults.standard.integer(forKey: tapCountKey)
        let field = GAIFields.customDimension(for: 1)
        tracker?.set(field, value: "\(tapCount)")
        return tracker
    }

}
