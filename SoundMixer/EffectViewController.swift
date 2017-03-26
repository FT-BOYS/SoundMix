    //
//  EffectViewController.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/23.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit
class EffectViewController: UIViewController {
    
    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var sld_totalVolume: AKPropertySlider!
    
    func changeTotalVolume(value : Double){
        sP.updateMainVolume(value)
        print("Total Volume = \(value)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EffectViewController")
        sld_totalVolume.callback = changeTotalVolume
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
