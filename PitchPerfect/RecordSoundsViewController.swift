//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Mukul Sharma on 10/3/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
	
	// MARK: Outlets
	
	@IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var recordingButton: UIButton!
	@IBOutlet weak var stopRecordingBtn: UIButton!
	
	var audioRecorder: AVAudioRecorder!
	
	// MARK: View Lifecycle methods
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		prepareUI(label: "Tap to Record", isRecording: false)
	}
	
	// MARK: Action handlers
	
	@IBAction func recordAudio(_ sender: AnyObject) {

		prepareUI(label: "Recording in Progress", isRecording: true)
		
		// Create file path, where recorded audio will be stored
		let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
		let recordingName = "recordedVoice.wav"
		let pathArray = [dirPath, recordingName]
		let filePath = NSURL.fileURL(withPathComponents: pathArray)
		
		print(filePath)
		
		// Create Audio session to start recording
		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
		
		try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
		audioRecorder.delegate = self
		audioRecorder.isMeteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}
	
	@IBAction func stopRecording(_ sender: AnyObject) {
		
		prepareUI(label: "Tap to Record", isRecording: false)

		// Stop audio recording
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
	}
	
	// MARK: AVAudioRecorderDelegate methods
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

		if (flag) {
			performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
		}
		else {
			print("Saving of recorded file failed")
		}
	}

	// MARK: Segue methods
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if (segue.identifier == "stopRecording") {
			let playSoundsVC = segue.destination as! PlaySoundsViewController
			let recordedAudioURL = sender as! NSURL
			playSoundsVC.recordedAudioURL = recordedAudioURL
		}
	}
	
	// MARK: UI Update utility methods
	
	func prepareUI(label:String, isRecording:Bool) {
		recordingLabel.text = label
		recordingButton.isEnabled = !isRecording
		stopRecordingBtn.isEnabled = isRecording
	}
}

