//
//  ViewController.swift
//  SlackLite
//
//  Created by JP Loh on 01/05/2017.
//  Copyright © 2017 JP Loh. All rights reserved.
//

import Cocoa
import SlackKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
  
  
  @IBAction func startOAuth(_ sender: NSButton) {
    var SlackClientID: String = "", SlackSecret: String = ""
    if let configPath = Bundle.main.path(forResource: "Config", ofType: "plist") {
      let config = NSDictionary(contentsOfFile: configPath)
      if let SlackConfig = config?["Slack"] as? [String: Any] {
        SlackClientID = SlackConfig["ClientID"] as! String
        SlackSecret = SlackConfig["Secret"] as! String
      }
    }
    if let url = URL(string: "https://slack.com/oauth/authorize?client_id=2925578328.176274714081&scope=client"), NSWorkspace.shared().open(url) {
      //print("default browser was successfully opened")
    }
    
  }


}

