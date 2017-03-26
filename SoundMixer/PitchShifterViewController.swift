//
//  PitchShifterViewController.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/25.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit
class PitchShifterViewController: UIViewController {
    
    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var sld_picth: AKPropertySlider!
    @IBOutlet weak var sld_mix: AKPropertySlider!
    @IBOutlet weak var sld_volume: AKPropertySlider!
    
    func changeMix(value: Double){
        sP.updateMix4_pitchMixer(value, whichTrack: .trackAll)
        //print("Mix = \(value)")
    }
    func changePicth(value: Double){
        sP.updatePitch(value, whichTrack: .trackAll)
        print("Picth = \(value)")
    }
    
    func changeVolume(value: Double){
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PitchShifterViewController")
        
        sld_picth.minimum = -24
        sld_picth.maximum = 24
        
        if let pitch = sP.getPitch(whichTrack: .trackAll) {
            sld_picth.value = pitch
        }
        if let balance = sP.getMix4_pitchMixer(whichTrack: .trackAll) {
            sld_mix.value = balance
        }
        
        sld_picth.callback = changePicth
        sld_mix.callback = changeMix
        sld_volume.callback = changeVolume
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
