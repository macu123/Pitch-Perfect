//
//  playSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jiapeng Chen on 2015-05-06.
//  Copyright (c) 2015 John Chen. All rights reserved.
//

import UIKit
import AVFoundation

class playSoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    //executed after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        //create audioPlayer object and enable changing rate
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        //create audioEngine and AVAudioFile object
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //play sounds at slow rate
    @IBAction func playSlow(sender: UIButton) {
        playAudioWithVariableRate(2.0)
    }
    
    //play sounds at fast rate
    @IBAction func playFast(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }

    func playAudioWithVariableRate(rate: Float) {
        //stop and reset audioEngine to fix the bug
        audioEngine.stop()
        audioEngine.reset()
        
        //must stop audioPlayer before begins to play everytime
        audioPlayer.stop()
        audioPlayer.rate = rate
        //set it to the beginning of the audio whenever it begins to play
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    //play sounds at high pitch
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(2500)
    }
    
    //play sounds at low pitch
    @IBAction func playDarth(sender: UIButton) {
        playAudioWithVariablePitch(-2500)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        //stop and reset audioEngine whenever it begins to play
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //create audioPlayerNote and attach it to audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        //create changePitchEffect node and attach it to audioEngine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        //audioPlayerNode --> changePitchEffect Node --> outputNode
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
    
        audioPlayerNode.play()
    }
    
    //executed afer the stop button is pressed
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
    }

}
