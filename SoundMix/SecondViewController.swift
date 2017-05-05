//
//  SecondViewController.swift
//  SoundMix
//
//  Created by 冯嘉晨 on 2017/4/19.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class SecondViewController: UIViewController{
    @IBAction func demo1Click(_ sender: Any) {
        sP.demo2_controlIns()
        updateUI()
    }
    @IBAction func demo2Click(_ sender: Any) {
        sP.demo3_controlIns()
        updateUI()
    }
    

    let sP = SongProcessor.sharedInstance
    
    @IBAction func bt_up1_play(_ sender: Any) {
        sP.amplitudeTrackOpen = true
    }
    @IBAction func bt_up2_pause(_ sender: Any) {
         sP.amplitudeTrackOpen = false
         sP.acceptAllFreq = false
         sP.track4_Instrument?.instrument.amplitude = 0.8
    }
    @IBAction func bt_up3_stop(_ sender: Any) {
         sP.acceptAllFreq = true
    }
    
    @IBOutlet weak var sld_up1_volume: AKPropertySlider!
    @IBOutlet weak var sld_up2_offset: AKPropertySlider!
    @IBOutlet weak var sld_up3_mix: AKPropertySlider!
    
    @IBAction func bt_middleUp1_instr1(_ sender: Any) {
        sP.changeInstrument(ins:.ins1)
    }
    @IBAction func bt_middleUp2_instr2(_ sender: Any) {
        sP.changeInstrument(ins:.ins2)
    }
    @IBAction func bt_middleUp3_instr3(_ sender: Any) {
        sP.changeInstrument(ins:.ins3)
    }
    @IBAction func bt_middleUp4_instr4(_ sender: Any) {
        sP.changeInstrument(ins:.ins4)
    }
    @IBAction func bt_middleUp5_instr5(_ sender: Any) {
    }
    
    @IBAction func bt_middle1_minus16(_ sender: Any) {
        sP.track4_Pitch = -24
    }
    @IBAction func bt_middle2_minus8(_ sender: Any) {
        sP.track4_Pitch = -12
    }
    @IBAction func bt_middle3_0(_ sender: Any) {
        sP.track4_Pitch = 0
    }
    @IBAction func bt_middle4_plus8(_ sender: Any) {
        sP.track4_Pitch = 12
    }
    @IBAction func bt_middle5_plus16(_ sender: Any) {
        sP.track4_Pitch = 24
    }

    @IBAction func bt_middle1_default(_ sender: Any) {
        sP.useDefaultFreqRange(.set1)
        updateUI()
    }
    @IBAction func bt_middle2_max(_ sender: Any) {
        sP.useDefaultFreqRange(.set2)
        updateUI()
    }
    @IBAction func bt_middle3_male(_ sender: Any) {
        sP.useDefaultFreqRange(.set3)
        updateUI()
    }
    @IBAction func bt_middle4_female(_ sender: Any) {
        sP.useDefaultFreqRange(.set4)
        updateUI()
    }
    @IBAction func bt_middle5_whistle(_ sender: Any) {
        sP.useDefaultFreqRange(.set5)
        updateUI()
    }
    @IBAction func bt_middle6_instrument(_ sender: Any) {
        sP.useDefaultFreqRange(.set6)
        updateUI()
    }
    
    @IBOutlet weak var sld_middle1_para1: AKPropertySlider!
    @IBOutlet weak var sld_middle2_para2: AKPropertySlider!
    
    @IBAction func bt_low1_holdOn(_ sender: Any) {
        sP.audioFilePlayer?.play()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SecondViewController")
        setBorderColor()
        initSlider()
        
        updateUI()
        
        
        sP.track4_Instrument?.start()
        sP.stopTrack(tracks: .track1,.track2,.track3)
        sP.startTrack(tracks: .track4)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSlider(){
        sld_up1_volume.callback = { value in self.sP.track0_MainMixer?.finalPlayerBooster?.volume = self.sld_up1_volume.value
        }
        
        sld_up2_offset.callback = { value in
            self.sP.track0_MainMixer?.pitchShifter?.shift = self.sld_up2_offset.value
        }
        // Mix from 0-1
        sld_up3_mix.callback = { value in self.sP.track0_MainMixer?.reverbMixer?.balance = self.sld_up3_mix.value}


    }
    
    func updateUI(){
        sld_up1_volume.value = (sP.track0_MainMixer?.finalPlayerBooster?.volume)!
        sld_up2_offset.value =  (sP.track0_MainMixer?.pitchShifter?.shift)!
        sld_up3_mix.value = (sP.track0_MainMixer?.reverbMixer?.balance)!
        
        sld_middle1_para1.value = sP.lowestFreq
        sld_middle2_para2.value = sP.highestFreq
    }
    
    func setBorderColor(){
        for ui: UIView in (self.view.subviews){
            ui.layer.borderColor = UIColor.white.cgColor;
        }
    }
}
