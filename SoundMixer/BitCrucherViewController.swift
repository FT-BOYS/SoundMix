//
//  BitCrucherViewController.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/25.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class BitCrucherViewController: UIViewController {
    
    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var sld_bitDepth: AKPropertySlider!
    @IBOutlet weak var sld_sampleRate: AKPropertySlider!
    @IBOutlet weak var sld_volume: AKPropertySlider!
    @IBOutlet weak var sld_mix: AKPropertySlider!
    
    func changeSampleRate(value: Double){
        sP.updateSampleRate(value, whichTrack: .trackAll)
    }
    
    func changeMix(value: Double){
        sP.updateMix5_bitCrushMixer(value, whichTrack: .trackAll)
    }
    
    func changeBitDepth(value: Double){
        sP.updateBitDepth(value, whichTrack: .trackAll)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sld_bitDepth.minimum = 1
        sld_bitDepth.maximum = 24
        sld_sampleRate.maximum = 16000
        
        
        if let bitDepth = sP.getBitDepth(whichTrack: .trackAll) {
            sld_bitDepth.value = bitDepth
        }
        
        if let sampleRate = sP.getSampleRate(whichTrack: .trackAll) {
            sld_sampleRate.value = sampleRate
        }
        
        if let balance = sP.getMix5_bitCrushMixer(whichTrack: .trackAll) {
            sld_mix.value = balance
        }
        
        
        sld_bitDepth.callback = changeBitDepth
        sld_sampleRate.callback = changeSampleRate
        sld_mix.callback = changeMix
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
