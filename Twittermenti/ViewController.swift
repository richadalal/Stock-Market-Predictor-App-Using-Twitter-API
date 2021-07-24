// Stock market predictor using the Twitter API

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = try! TweetSentimentClassifier(configuration: MLModelConfiguration())

    let swifter = Swifter(consumerKey: "LTReJyreyyuz4SWjVABuA1WKI", consumerSecret: "ajf107xfd6869heCG8Ptn8iztfFHBWPIxLkFGvsmoEwI7MKZcz")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchText = textField.text {
               
               swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended, success: {(results, metadata) in
                   
                   var tweets = [TweetSentimentClassifierInput]()
                   
                   for i in 0..<100 {
                       if let tweet = results[i]["full_text"].string {
                           let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                           tweets.append(tweetForClassification)
                       }
                   }
                   
                   do {
                       
                       let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                       
                       var sentimentScore = 0
                       
                       for pred in predictions {
                           let sentiment = pred.label
                           if sentiment == "Pos" {
                               sentimentScore += 1
                           } else if sentiment == "Neg" {
                               sentimentScore -= 1
                           }
                       }
                    
                                            
                        if sentimentScore > 20 {
                            self.sentimentLabel.text = "😍"
                        } else if sentimentScore > 10 {
                            self.sentimentLabel.text = "😀"
                        } else if sentimentScore > 0 {
                            self.sentimentLabel.text = "🙂"
                        } else if sentimentScore == 0 {
                            self.sentimentLabel.text = "😐"
                        } else if sentimentScore > -10 {
                            self.sentimentLabel.text = "😕"
                        } else if sentimentScore > -20 {
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
   
