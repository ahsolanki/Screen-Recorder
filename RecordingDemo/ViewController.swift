//
//  ViewController.swift
//  RecordingDemo
//
//  Created by Ankit Solanki on 28/04/16.
//  Copyright © 2016 Ankit Solanki. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnStartRecord(sender: AnyObject) {
        self .startRecording(sender as! UIButton)
    }
    
    @IBAction func btnStopRecord(sender: AnyObject) {
        self.stopRecording(sender as! UIButton)
    }
    func startRecording(sender: UIButton) {
        if RPScreenRecorder.sharedRecorder().available {
            RPScreenRecorder.sharedRecorder().startRecordingWithMicrophoneEnabled(true, handler: { (error: NSError?) -> Void in
                if error == nil { // Recording has started
                    sender.removeTarget(self, action: "startRecording:", forControlEvents: .TouchUpInside)
                    sender.addTarget(self, action: "stopRecording:", forControlEvents: .TouchUpInside)
                    sender.setTitle("Stop Recording", forState: .Normal)
                    sender.setTitleColor(UIColor.redColor(), forState: .Normal)
                } else {
                    // Handle error
                }
            })
        } else {
            // Display UI for recording being unavailable
        }
    }

    func stopRecording(sender: UIButton) {
        RPScreenRecorder.sharedRecorder().stopRecordingWithHandler { (previewController: RPPreviewViewController?, error: NSError?) -> Void in
            if previewController != nil {
                let alertController = UIAlertController(title: "Recording", message: "Do you wish to discard or view your gameplay recording?", preferredStyle: .Alert)
                
                let discardAction = UIAlertAction(title: "Discard", style: .Default) { (action: UIAlertAction) in
                    RPScreenRecorder.sharedRecorder().discardRecordingWithHandler({ () -> Void in
                        // Executed once recording has successfully been discarded
                    })
                }
                
                let viewAction = UIAlertAction(title: "View", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    self.presentViewController(previewController!, animated: true, completion: nil)
                })
                
                alertController.addAction(discardAction)
                alertController.addAction(viewAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                sender.removeTarget(self, action: "stopRecording:", forControlEvents: .TouchUpInside)
                sender.addTarget(self, action: "startRecording:", forControlEvents: .TouchUpInside)
                sender.setTitle("Start Recording", forState: .Normal)
                sender.setTitleColor(UIColor.blueColor(), forState: .Normal)
            } else {
                // Handle error
            }
        }
    }
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        
        print("Finished the preview")
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

