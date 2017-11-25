//
//  ViewController.swift
//  TwitterKItExample
//
//  Created by shingo asato on 2017/11/25.
//  Copyright © 2017年 anz. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tweetIdTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // リフレッシュのためにログアウトしてる
        if let userId = Twitter.sharedInstance().sessionStore.session()?.userID {
            Twitter.sharedInstance().sessionStore.logOutUserID(userId)
        }

        // Twitter login
        Twitter.sharedInstance().logIn { (session, error) in
            if let session = session {
                print("user id: \(session.userID)")
            } else if let error = error {
                print(error)
            }
        }
    }

    @IBAction func tapTweet(_ sender: UIButton) {
        
        guard let session = Twitter.sharedInstance().sessionStore.session() else {
            print("session is nil")
            return
        }
        
        if let text = self.textField.text {
            let client = TWTRAPIClient(userID: session.userID)
            // ツイートする
            client.sendTweet(withText: text, completion: { (tweet, error) in
                if let tweet = tweet {
                    print(tweet.permalink)
                } else if let error = error {
                    print(error)
                }
            })
        }
        
    }
    
    @IBAction func tapGet(_ sender: UIButton) {
        guard let session = Twitter.sharedInstance().sessionStore.session() else {
            print("session is nil")
            return
        }
        
        if let tweetId = self.tweetIdTextField.text {
            print(session.userID)
            let client = TWTRAPIClient(userID: session.userID)
            
            // ツイート取得
            // アプリ連携解除しても鍵アカウントのツイート取得できるんだけど...？
            client.loadTweets(withIDs: [tweetId], completion: { (tweets, error) in
                if let tweets = tweets {
                    print(tweets[0].permalink)
                    print(tweets[0].text)
                } else if let error = error {
                    print(error)
                }
            })
            
//            client.loadTweet(withID: tweetId, completion: { (tweet, error) in
//                if let tweet = tweet {
//                    print(tweet.permalink)
//                    print(tweet.text)
//                } else if let error = error {
//                    print(error)
//                }
//            })
        }
    }
    
}

