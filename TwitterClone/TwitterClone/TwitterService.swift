//
//  TwitterService.swift
//  TwitterClone
//
//  Created by Kristen Kozmary on 8/4/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

import Foundation
import Accounts
import Social


class TwitterService {
  //singleton
  static let sharedService = TwitterService()
  var account: ACAccount?
  private init() {}
  class func tweetsFromHomeTimeline(completionHandler : (String?, [Tweet]?) -> (Void)) {
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!, parameters: nil)
    request.account = self.sharedService.account
    request.performRequestWithHandler { (data, response, error) -> Void in
      if let error = error {
        completionHandler("could not connect to server", nil)
      } else {
        println(response.statusCode)
        switch response.statusCode {
        case 200...299:
          let tweets = TweetJSONParser.tweetsFromJSONData(data)
          completionHandler(nil,tweets)
        case 400...499:
          completionHandler("Our fault", nil)
        case 500...599:
          completionHandler("Server's fault", nil)
        default:
          completionHandler("Something went wrong", nil)
        }
      }
    }
  }
  
  class func tweetsFromUserTimeline(userID: String, completionHandler : (String?, [Tweet]?) -> (Void)) {
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=" + ("\(userID)"))!, parameters: nil)
    request.account = self.sharedService.account
    request.performRequestWithHandler { (data, response, error) -> Void in
      if let error = error {
        completionHandler("could not connect to server", nil)
      } else {
        println(response.statusCode)
        switch response.statusCode {
        case 200...299:
          let tweets = TweetJSONParser.tweetsFromJSONData(data)
          completionHandler(nil, tweets)
        case 400...499:
          completionHandler("Our fault", nil)
        case 500...599:
          completionHandler("Server's fault", nil)
        default:
          completionHandler("Something went wrong", nil)
        }
      }
    }
  }
}
