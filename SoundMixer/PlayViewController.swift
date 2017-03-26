//
//  PlayViewController.swift
//  SoundMixer
//
//  Created by 冯嘉晨 on 2017/3/23.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit

class PlayViewController: UIViewController {
    
    let sP = SongProcessor.sharedInstance
    
    @IBAction func ac_startOrEnd(_ sender: Any) {
        print("Start Button Click")
    }
    
    @IBAction func ac_playMix(_ sender: Any) {
         print("Play Mix Button Click")
    }
    
    @IBAction func ac_soloGuitar(_ sender: Any) {
         print("Solo Guitar Button Click")
    }
    
    @IBAction func ac_soleBass(_ sender: Any) {
         print("Solo Bass Button Click")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PlayViewController")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
