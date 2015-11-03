//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    var buttonBeep : AVAudioPlayer?
    var secondBeep : AVAudioPlayer?
    var backgroundMusic : AVAudioPlayer?
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var startCount: UIButton!
    
    @IBAction func translate(sender: AnyObject) {
        
        buttonBeep?.volume = 0.2
        buttonBeep?.play()
        backgroundMusic?.volume = 0.1
        backgroundMusic?.play()
        
        
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let langStr2 = ("en|tr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let langStr3 = ("en|ga").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        let urlStr2:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr2!)
        let urlStr3:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr3!)
        
        let url = NSURL(string: urlStr)
        let url2 = NSURL(string: urlStr2)
        let url3 = NSURL(string: urlStr3)
        
            //       if(pickerView == 0){
            //            request = NSURLRequest(URL: url!}
            //        else if (row == 1{
            //            request = NSURLRequest(URL: url2!}
            //        else if (row == 2{
            //            request = NSURLRequest(URL: url3!)}
        
        let request = NSURLRequest(URL: url!)// Creating Http Request
        let request2 = NSURLRequest(URL: url2!)// Creating Http Request
        let request3 = NSURLRequest(URL: url3!)// Creating Http Request
        
        
        //var data = NSMutableData()var data = NSMutableData()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
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
    //var data = NSMutableData()
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.blueColor();
        
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
        
        //progressView.setProgress(0, animated: true)
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["French", "Turkish", "Irish"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.

        /*
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)

        let url = NSURL(string: urlStr)
        
        
        if(row == 0){
        let langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        }
        else if (row == 1){
        let langStr2 = ("en|tr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlStr2:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr2!)
        let url2 = NSURL(string: urlStr2)
        let request = NSURLRequest(URL: url2!)
        }
        else if (row == 2){
        let langStr3 = ("en|ga").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlStr3:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr3!)
        let url3 = NSURL(string: urlStr3)
        let request = NSURLRequest(URL: url3!)
        }
        
        let request = NSURLRequest(URL: url!)// Creating Http Request
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
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
        }*/
        
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
        
        print(row)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true); super.touchesBegan(touches, withEvent: event)
    }
}
