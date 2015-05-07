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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playAudioWithVariableRate(2.0)
    }

    @IBAction func playFast(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    func playAudioWithVariableRate(rate: Float) {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(2500)
    }
    
    @IBAction func playDarth(sender: UIButton) {
        playAudioWithVariablePitch(-2500)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
    
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
    
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
    
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
    }

}
