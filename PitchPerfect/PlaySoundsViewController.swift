//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Mukul Sharma on 10/3/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
	
	// MARK: Outlets
	
	@IBOutlet weak var snailButton: UIButton!
	@IBOutlet weak var chipmunkButton: UIButton!
	@IBOutlet weak var rabbitButton: UIButton!
	@IBOutlet weak var vaderButton: UIButton!
	@IBOutlet weak var echoButton: UIButton!
	@IBOutlet weak var reverbButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!

	var recordedAudioURL: NSURL!
	var audioFile : AVAudioFile!
	var audioEngine : AVAudioEngine!
	var audioPlayerNode : AVAudioPlayerNode!
	var stopTimer : Timer!
	
	enum ButtonType : Int { case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb }
	
	// MARK: View Lifecycle methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupAudio()
    }
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		if (UIDevice.current.orientation.isLandscape) {
			// Fix the squishing of button images in landscape mode on small screen devices
			changeContentModeForButtons(contentMode: UIViewContentMode.scaleAspectFit)
		} else {
			// Revert to original image rendering mode in portrait mode
			changeContentModeForButtons(contentMode: UIViewContentMode.scaleToFill)
		}
	}
	
	func changeContentModeForButtons(contentMode : UIViewContentMode) {
		snailButton.imageView?.contentMode = contentMode
		rabbitButton.imageView?.contentMode = contentMode
		chipmunkButton.imageView?.contentMode = contentMode
		vaderButton.imageView?.contentMode = contentMode
		echoButton.imageView?.contentMode = contentMode
		reverbButton.imageView?.contentMode = contentMode
		stopButton.imageView?.contentMode = contentMode
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureUI(playState: .NotPlaying)
	}
	
	// MARK: Action handlers 
	
	@IBAction func playSoundForButton(_ sender: UIButton) {

		switch(ButtonType(rawValue: sender.tag)!) {
		case .Slow:
			playSound(rate: 0.5)
		case .Fast:
			playSound(rate: 1.5)
		case .Chipmunk:
			playSound(pitch: 1000)
		case .Vader:
			playSound(pitch: -1000)
		case .Echo:
			playSound(echo: true)
		case .Reverb:
			playSound(reverb: true)
		}
		
		configureUI(playState: .Playing)
	}
	
	@IBAction func stopButtonPressed(_ sender: AnyObject) {
		stopAudio()
	}
}
