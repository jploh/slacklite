//
//  AppDelegate.swift
//  SlackLite
//
//  Created by JP Loh on 01/05/2017.
//  Copyright © 2017 JP Loh. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
  func applicationWillFinishLaunching(_ notification: Notification) {
    NSAppleEventManager.shared().setEventHandler(
      self,
      andSelector: #selector(handleURLEvent(_: withReply: )),
      forEventClass: AEEventClass(kInternetEventClass),
      andEventID: AEEventID(kAEGetURL)
    )
  }
  
  func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
    if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue {
      if let url = URL(string: urlString), "slacklite" == url.scheme && "oauth2" == url.host {
        let urlcomps = NSURLComponents(string: url.absoluteString)
        //let oauthCode = urlcomps.queryItems.code.name
        var oauthCode = ""
        if let queryItems = urlcomps?.queryItems {
          for queryItem in queryItems {
            if queryItem.name == "code" {
              oauthCode = queryItem.value!
            }
          }
        }
        var SlackClientID: String = "", SlackSecret: String = ""
        if let configPath = Bundle.main.path(forResource: "Config", ofType: "plist") {
          let config = NSDictionary(contentsOfFile: configPath)
          if let SlackConfig = config?["Slack"] as? [String: Any] {
            SlackClientID = SlackConfig["ClientID"] as! String
            SlackSecret = SlackConfig["Secret"] as! String
          }
        }
        
        Alamofire.request("https://slack.com/api/oauth.access?client_id=" + SlackClientID + "&client_secret=" + SlackSecret + "&code=" + oauthCode).responseJSON { response in
          if let JSON = response.result.value as? [String: Any] {
            if let accessToken = JSON["access_token"] as? String {
              print("Access Token: \(accessToken)")
            }
          }
        }
      }
    }
  }

}

