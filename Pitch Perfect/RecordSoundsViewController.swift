//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Fuerstnau on 9/16/15.
//  Copyright (c) 2015 Michael Fuerstnau. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingText: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
        recordingText.text = "Tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {       
        recordingText.text = "recording"
        stopButton.hidden = false
        recordButton.enabled = false
        
        if let dirPathArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as? [String]{
            let dirPath = dirPathArray[0]
            
            let recordingName = "pitch_perfect_audio.wav"
            var pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            // Setup the audio session.
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryRecord, error:nil)
            // Initialize and prepare the recorder.
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        } else {
            println("Unable to locate directory.")
        }
    }
    
    @IBAction func stopRecord(sender: UIButton) {
        // Stop the recorder.
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // Save the recorded audio.
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

