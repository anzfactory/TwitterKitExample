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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Twitter login
        Twitter.sharedInstance().logIn { (session, error) in
            if let session = session {
                // Session保存
                Twitter.sharedInstance().sessionStore.save(session, completion: { (session, error) in
                    if let error = error {
                        print(error)
                    } else if let session = session {
                        print("save session \(session.authToken) \(session.authTokenSecret)")
                    }
                })
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
            client.sendTweet(withText: text, completion: { (tweet, error) in
                if let tweet = tweet {
                    print(tweet.permalink)
                } else if let error = error {
                    print(error)
                }
            })
        }
        
    }
    
}

