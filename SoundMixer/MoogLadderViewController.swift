//
//  MoogLadderViewController.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/25.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class MoogLadderViewController: UIViewController {
    
    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var sld_volume: AKPropertySlider!
    
    @IBOutlet weak var sld_mix: AKPropertySlider!
    @IBOutlet weak var sld_resonance: AKPropertySlider!
    @IBOutlet weak var sld_cutoffFrequency: AKPropertySlider!
    
    func changeCutoffFrequency(value: Double){
        sP.updateCutoffFrequncy(value, whichTrack: .trackAll)
//        print("CutoffFrequency = \(value)")
    }
    
    func changeResonance(value: Double){
        sP.updateResonance(value, whichTrack: .trackAll)
//        print("Resonance = \(value)")
    }
    
    func changeMix(value: Double){
        sP.updateMix_filterMixer(value, whichTrack: .trackAll)
        print("Mix = \(value)")
    }
    
    func changeVolume(value: Double){
        print("Volume = \(value)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MoogLadderViewController")
        
        sld_cutoffFrequency.minimum = 12.0
        sld_cutoffFrequency.maximum = 10000.0
        
        if let freq = sP.getCutoffFrequncy(whichTrack: .trackAll) {
            sld_cutoffFrequency.value = freq
        }
        
        if let res = sP.getResonance(whichTrack: .trackAll) {
            sld_resonance.value = res
        }
        
        if let balance = sP.getMix_filterMixer(whichTrack: .trackAll) {
            sld_mix.value = balance
        }
        
        sld_cutoffFrequency.callback = changeCutoffFrequency
        sld_resonance.callback = changeResonance
        sld_mix.callback = changeMix
//        sld_volume.callback = changeVolume
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
