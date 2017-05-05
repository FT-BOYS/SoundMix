//
//  ThridViewController.swift
//  SoundMix
//
//  Created by 冯嘉晨 on 2017/4/22.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class ThridViewController: UIViewController{
    
    let sP = SongProcessor.sharedInstance
    
    func setupPlot() {
        //这里绑定AKNode
        if(!sP.loaded){
            sP.plot = AKNodeOutputPlot(sP.mic, frame: plt_up1_output.bounds)
            sP.plot.plotType = .rolling
            sP.plot.shouldFill = true
            sP.plot.shouldMirror = true
            sP.plot.color = UIColor.blue
        }
        
//        AudioKit.stop()
//        view_test.addSubview(sP.plot)
        plt_up1_output.addSubview(sP.plot)
//        AudioKit.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if(!sP.loaded){
//            sP.loaded = true
//            setupPlot()
//        }
        setupPlot()
        
    }
    
    @IBAction func bt_up1_play(_ sender: Any) {
    }
    @IBAction func bt_up2_pause(_ sender: Any) {
    }
    @IBAction func bt_up3_stop(_ sender: Any) {
    }
    
    @IBOutlet weak var view_test: UIView!
    @IBOutlet weak var plt_up1_output: EZAudioPlot!
    
    @IBOutlet weak var sld_middle1_volume: AKPropertySlider!
    @IBOutlet weak var sld_middle2_offset: AKPropertySlider!
    @IBOutlet weak var sld_middle3_mix: AKPropertySlider!
    
    @IBAction func bt_middle1_file(_ sender: Any) {
    }
    @IBAction func bt_middle2_share(_ sender: Any) {
    }
    @IBAction func bt_middle3_star(_ sender: Any) {
    }
    @IBAction func bt_low1_holdOn(_ sender: Any) {
    }
    
    func initSlider(){
        sld_middle1_volume.callback = { value in self.sP.track0_MainMixer?.finalPlayerBooster?.volume = self.sld_middle1_volume.value
        }
        
        sld_middle2_offset.callback = { value in
            self.sP.track0_MainMixer?.pitchShifter?.shift = self.sld_middle2_offset.value
        }
        // Mix from 0-1
        sld_middle3_mix.callback = { value in self.sP.track0_MainMixer?.reverbMixer?.balance = self.sld_middle3_mix.value}
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ThridViewController")
        setBorderColor()
        
        initSlider()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBorderColor(){
        for ui: UIView in (self.view.subviews){
            ui.layer.borderColor = UIColor.white.cgColor;
        }
    }
}
