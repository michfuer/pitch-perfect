//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Fuerstnau on 9/18/15.
//  Copyright (c) 2015 Michael Fuerstnau. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
   
    var player: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the session.
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error:nil)
        
        // Configure our audio player.
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        player.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playback(sender: UIButton) {
        resetAudioEngine()
        
        switch sender.tag {
            // The slow button is tagged 0.
            case 0:
                player.rate = 0.5
            // The fast button is tagged 1.
            case 1:
                player.rate = 2
            default:
                player.rate = 1
        }
        
        player.play()
    }
   
    @IBAction func stopPlayback(sender: UIButton) {
        resetAudioEngine()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        resetAudioEngine()
        
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
    
    func resetAudioEngine() {
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        player.currentTime = 0
    }
    
    @IBAction func chimpmunkPlayback(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func vaderPlayback(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
}
