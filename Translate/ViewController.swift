//
//  ViewController.swift
//  Translate
//
//  Created by David O'Leary on 6/11/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var buttonBeep : AVAudioPlayer?
    var secondBeep : AVAudioPlayer?
    var backgroundMusic : AVAudioPlayer?
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var startCount: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBAction func translate(sender: AnyObject) {
        
        buttonBeep?.volume = 0.2
        buttonBeep?.play()
        backgroundMusic?.volume = 0.1
        backgroundMusic?.play()
        
        
        var langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if(textField.text == "French"){
            langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        }
        else if(textField.text == "Turkish"){
            langStr = ("en|tr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        }
        else if(textField.text == "Irish"){
            langStr = ("en|ga").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        }
        else if(textField.text == "UAE"){
            langStr = ("en|ar").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        }
        
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)// Creating Http Request
       
        /*
        NSURLSession * session = [NSURLSession, sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:urlStr]
            completionHandler:^(NSData *data,
            NSURLResponse *response,
            NSError *error) {
            // handle response
            
            }] resume];
        */
        
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.frame = CGRectMake(0.0, 0.0, 35.0, 35.0);
        
        if(textField.text == "French"){
            indicator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0.8, alpha: 0.5)
        }
        else if(textField.text == "Turkish"){
            indicator.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.5)
        }
        else if(textField.text == "Irish"){
            indicator.backgroundColor = UIColor.init(red: 0, green: 0.8, blue: 0, alpha: 0.5)
        }
        else if(textField.text == "UAE"){
            indicator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        }

        indicator.layer.cornerRadius = 10.0;
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        var result = "<Translation Error>"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            
            indicator.stopAnimating()
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    if(jsonDict.valueForKey("responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.objectForKey("responseData") as! NSDictionary
                        
                        result = responseData.objectForKey("translatedText") as! String
                    }
                }
                self.translatedText.text = result
            }
        }
    }
    
    @IBAction func textToSpeech(sender: UIButton) {
        myUtterance = AVSpeechUtterance(string: translatedText.text)
        myUtterance.rate = 0.4
        synth.speakUtterance(myUtterance)
    }

    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {

        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.blueColor();
        textField.text = "French"
        
        
        super.viewDidLoad()
        
        
        if let buttonBeep = self.setupAudioPlayerWithFile("Translate", type:"wav") {
            self.buttonBeep = buttonBeep
        }
        if let secondBeep = self.setupAudioPlayerWithFile("SecondBeep", type:"wav") {
            self.secondBeep = secondBeep
        }
        if let backgroundMusic = self.setupAudioPlayerWithFile("peteLawrence", type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }

        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = ["French", "Turkish", "Irish", "UAE"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        textField.text = pickerData[row]
        
        if(row == 0)
        {
            self.view.backgroundColor = UIColor.blueColor();
        }
        else if(row == 1)
        {
            self.view.backgroundColor = UIColor.redColor();
        }
        else if(row == 2)
        {
            self.view.backgroundColor =  UIColor.greenColor();
        }
        else if(row == 3)
        {
            self.view.backgroundColor =  UIColor.whiteColor();
        }
        
        print(row)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true); super.touchesBegan(touches, withEvent: event)
    }
}
