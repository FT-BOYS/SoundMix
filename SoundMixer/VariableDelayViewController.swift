//
//  VariableDelayViewController.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/23.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class VariableDelayViewController: UIViewController {
    
    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var sld_time: AKPropertySlider!
    @IBOutlet weak var sld_feedback: AKPropertySlider!
    @IBOutlet weak var sld_mix: AKPropertySlider!
    @IBOutlet weak var sld_volume: AKPropertySlider!
    
    func changeTime(value: Double){
        sP.updateTime(value, whichTrack: .trackAll)
        print("Time = \(value)")
    }
    
    func changeFeedback(value: Double){
        sP.updateFeedback(value, whichTrack: .trackAll)
        print("Feedback = \(value)")
    }
    
    func changeMix(value: Double){
        sP.updateMix2_delayMixer(value, whichTrack: .trackAll)
        print("Mix = \(value)")
    }
    
    //is not needed!
    func changeVolume(value: Double){
//        sP.updateVolume(value, whichTrack: .trackAll)
        print("Volume = \(value)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VariableDelayViewController")
        
        if let time = sP.getTime(whichTrack:.trackAll) {
            sld_time.value = time
        }
        
        if let feedback = sP.getFeedback(whichTrack:.trackAll) {
            sld_feedback.value = feedback
        }
        
        if let balance = sP.getMix2_delayMixer(whichTrack: .trackAll) {
            sld_mix.value = balance
        }
        
        sld_time.callback = changeTime
        sld_feedback.callback = changeFeedback
        sld_mix.callback = changeMix
        sld_volume.callback = changeVolume
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
