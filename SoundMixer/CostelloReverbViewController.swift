//
//  CostelloReverbViewController.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/25.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class CostelloReverbViewController: UIViewController {
    
    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var sld_feedback: AKPropertySlider!
    @IBOutlet weak var sld_mix: AKPropertySlider!
    @IBOutlet weak var sld_volume: AKPropertySlider!
    
    func changeMix(value: Double){
        sP.updateMix3_reverbMixer(value, whichTrack: .trackAll)
    }
    

    
    func changeFeedback(value: Double){
        sP.updateFeedback3(value, whichTrack: .trackAll)
    }
    
    func changeVolume(value: Double){

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("CostelloReverbViewController")
        if let feedback = sP.getFeedback3(whichTrack: .trackAll) {
            sld_feedback.value = feedback
        }
        if let balance = sP.getMix3_reverbMixer(whichTrack: .trackAll) {
            sld_mix.value = balance
        }
        sld_feedback.callback = changeFeedback
        sld_mix.callback = changeMix
        sld_volume.callback = changeVolume
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
