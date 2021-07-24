// Stock market predictor using the Twitter API

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let checkSentiment = try! TweetSentimentClassifier(configuration: MLModelConfiguration())

    let swifterFramework = Swifter(consumerKey: "insert_key", consumerSecret: "insert_secret")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchText = textField.text {
               
               swifterFramework.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended, success: {(results, metadata) in
                   
                   var tweets = [TweetSentimentClassifierInput]()
                   
                   for i in 0..<100 {
                       if let tweet = results[i]["full_text"].string {
                           let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                           tweets.append(tweetForClassification)
                       }
                   }
                   
                   do {
                       
                       let predictions = try self.checkSentiment.predictions(inputs: tweets)
                       
                       var checkValue = 0
                       
                       for pred in predictions {
                           let sentiment = pred.label
                           if sentiment == "Pos" {
                               checkValue += 1
                           } else if sentiment == "Neg" {
                               checkValue -= 1
                           }
                       }
                    
                                            
                        if checkValue > 20 {
                            self.sentimentLabel.text = "😍"
                        } else if checkValue > 10 {
                            self.sentimentLabel.text = "😀"
                        } else if checkValue > 0 {
                            self.sentimentLabel.text = "🙂"
                        } else if checkValue == 0 {
                            self.sentimentLabel.text = "😐"
                        } else if checkValue > -10 {
                            self.sentimentLabel.text = "😕"
                        } else if checkValue > -20 {
                            self.sentimentLabel.text = "😡"
                        } else {
                            self.sentimentLabel.text = "🤮"
                        }
             
                   } catch {
                       print("There was en error with making a prediction, \(error)")
                   }
                   
               }) { (error) in
                   print("There was an error with the Twitter API Request, \(error)")
                   }
   
        }
    
    }
}
   
