//
//  TrackViewController.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/25.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit

class TrackViewController: UIViewController {
    
    let sP = SongProcessor.sharedInstance

    @IBAction func switch_StartOrStop1(_ sender: Any) {
        sP.startOrStopTrack(nowVolume: 1.0, whichTrack: .track1)

    }
    
    @IBAction func switch_StartOrStop2(_ sender: Any) {
        sP.startOrStopTrack(nowVolume: 1.0, whichTrack: .track2)
    }

    @IBAction func switch_StartOrStop3(_ sender: Any) {
        sP.startOrStopTrack(nowVolume: 1.0, whichTrack: .track3)
    }
    
    
    @IBAction func switch_StartOrStop4(_ sender: Any) {
        sP.startOrStopTrack(nowVolume: 1.0, whichTrack: .track4)
    }
    
    @IBAction func switch_StartOrStop5(_ sender: Any) {
        sP.startOrStopTrack(nowVolume: 1.0, whichTrack: .track5)
    }
    
    @IBAction func switch_StartOrStopAll(_ sender: Any) {
            sP.startOrStopTrack(nowVolume: 1.0, whichTrack: .trackAll)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TrackViewController")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
