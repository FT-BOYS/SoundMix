//
//  PitchShifter.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/25.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class PitchShifter: UIViewController {
    
    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var sld_picth: AKPropertySlider!
    
    @IBOutlet weak var sld_mix: AKPropertySlider!
    
    @IBOutlet weak var sld_volume: AKPropertySlider!
    
    func changeMix(value: Double){
        sP.updateMix4_pitchMixer(value, whichTrack: .track1)
    }
    func changePicth(value: Double){
        sP.updatePitch(value, whichTrack: .track1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sld_picth.callback = changePicth
        sld_mix.callback = changeMix
        
        print("PitchShifter")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
