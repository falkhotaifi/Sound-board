//
//  SoundViewController.swift
//  Sound board
//
//  Created by Faisal Alkhotaifi on 4/4/17.
//  Copyright © 2017 Faisal Alkhotaifi. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var RecrodOutlet: UIButton!
    @IBOutlet weak var PlayOutlet: UIButton!
    @IBOutlet weak var AddOutlet: UIButton!
    
    var audiorecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRecorder()
        PlayOutlet.isEnabled = false
        AddOutlet.isEnabled = false
    }
    
    func setupRecorder(){
        do {
        // Create an audio session 
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
        
        // Create URL for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
        
        // Create setting for the audio recorder
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
        
        // Create audioRecorder object
            audiorecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audiorecorder!.prepareToRecord()
        } catch let error as NSError{ print (error) }
    }
    
    @IBAction func RecordButton(_ sender: Any) {
        if audiorecorder!.isRecording{
            //Stop the recording
            audiorecorder?.stop()
            
            //Change the title to Record
            RecrodOutlet.setTitle("Record", for: .normal)
            
            //Enable the play button and the add button
            PlayOutlet.isEnabled = true
            AddOutlet.isEnabled = true
            
        }else{
            //Start recording 
            audiorecorder?.record()
            
            //Change the title to Stop
            RecrodOutlet.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func PlayButton(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
            /*if audioPlayer!.isPlaying{
                audioPlayer?.stop()
                PlayOutlet.setTitle("Play", for: .normal)
            }else{
                audioPlayer?.play()
                PlayOutlet.setTitle("Stop", for: .normal)
            }*/
        }catch{}
    }

    @IBAction func AddButton(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = textField.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
}
