//
//  recordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jiapeng Chen on 2015-05-06.
//  Copyright (c) 2015 John Chen. All rights reserved.
//

import UIKit
import AVFoundation

class recordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //executed when view is going to appear
    override func viewWillAppear(animated: Bool) {
        //hide stop button
        stopButton.hidden = true
        //enable record button
        recordButton.enabled = true
    }
    
    //executed when the record button is pressed
    @IBAction func recordAudio(sender: UIButton) {
        //disable record button
        recordButton.enabled = false
        //show text
        recordingInProgress.text = "Recording"
        stopButton.hidden = false
        //start recording users' voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //generate file name for the recording
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //initialize and prepare recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        //delegate AVAudioRecorder in order to use audioRecorderDidFinishRecording function
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //executed after recording has been finished
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //use flag to indicate if it's successful
        if(flag) {
            //Do this if recording is successful
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
            //Do this if recording is unsuccessful
            println("Recording was not successful")
            recordingInProgress.text = "Tap to Record"
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    //pass recording file to playSoundsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:playSoundsViewController = segue.destinationViewController as playSoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    //executed when the stop button is pressed
    @IBAction func stopRecord(sender: UIButton) {
        //change text of UILabel
        recordingInProgress.text = "Tap to Record"
        //stop recording users' voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

