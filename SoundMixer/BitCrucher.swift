//
//  BitCrucher.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/25.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class BitCrucher: UIViewController {
    
//    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var sld_bitDepth: AKPropertySlider!
    
    @IBOutlet weak var sld_sampleRate: AKPropertySlider!
    
    @IBOutlet weak var sld_volume: AKPropertySlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("BitCrucher")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
