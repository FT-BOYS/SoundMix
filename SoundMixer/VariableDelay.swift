//
//  VariableDelay.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/25.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class VariableDelay: UIViewController {
    
    @IBOutlet weak var sld_time: AKPropertySlider!
    
    @IBOutlet weak var sld_feedback: AKPropertySlider!
    
    @IBOutlet weak var sld_mix: AKPropertySlider!
    
    @IBOutlet weak var sld_volume: AKPropertySlider!
    
    let sP = SongProcessor.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VariableDelay")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
