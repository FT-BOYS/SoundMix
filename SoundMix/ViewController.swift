//
//  ViewController.swift
//  SoundMix
//
//  Created by 冯嘉晨 on 2017/4/15.
//  Copyright © 2017年 冯嘉晨. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {

    let sP = SongProcessor.sharedInstance
    
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView1: UIStackView!
    //Effective Btns
    @IBAction func bt_up1_play(_ sender: Any) {
        sP.releaeHoldOn(whichTrack: .trackAll)
    }
    @IBAction func bt_up2_pause(_ sender: Any) {
        sP.releaeHoldOn(whichTrack: .trackAll)
    }
    @IBAction func bt_up3_stop(_ sender: Any) {
        sP.releaeHoldOn(whichTrack: .trackAll)
    }
    
    @IBOutlet weak var sld_up1_volume: AKPropertySlider!
    @IBOutlet weak var sld_up2_offset: AKPropertySlider!
    @IBOutlet weak var sld_up3_mix: AKPropertySlider!
    @IBOutlet weak var sld_up4_delay: AKPropertySlider!
    
    @IBAction func bt_middle1_rich(_ sender: Any) {
        sP.useDefaultChorus(.set1)
        refreshUI()
    }
    @IBAction func bt_middle2_light(_ sender: Any) {
        sP.useDefaultChorus(.set2)
        refreshUI()
    }
    @IBAction func bt_middle3_default(_ sender: Any) {
        sP.useDefaultChorus(.set3)
        refreshUI()
    }
    
    @IBOutlet weak var sld_middle1_volume: AKPropertySlider!
    @IBOutlet weak var sld_middle2_volume: AKPropertySlider!
    @IBOutlet weak var sld_middle3_volume: AKPropertySlider!

    @IBAction func bt_middleLow1_plus(_ sender: Any) {
        let temp:Int = Int((lb_middleLow1_num.text! as NSString).intValue)+1
        lb_middleLow1_num.text = String(temp)

        sP.track1_Vocal?.pitchShifter?.shift += 1
    }
    @IBAction func bt_middleLow2_minus(_ sender: Any) {
        let temp:Int = Int((lb_middleLow1_num.text! as NSString).intValue)-1
        lb_middleLow1_num.text = String(temp)
        
        sP.track1_Vocal?.pitchShifter?.shift -= 1
    }
    @IBAction func bt_middleLow3_plus(_ sender: Any) {
        let temp:Int = Int((lb_middleLow2_num.text! as NSString).intValue)+1
        lb_middleLow2_num.text = String(temp)
        
        sP.track2_Vocal?.pitchShifter?.shift += 1
    }
    @IBAction func bt_middleLow4_minus(_ sender: Any) {
        let temp:Int = Int((lb_middleLow2_num.text! as NSString).intValue)-1
        lb_middleLow2_num.text = String(temp)
        
        sP.track2_Vocal?.pitchShifter?.shift -= 1
    }
    @IBAction func bt_middleLow5_plus(_ sender: Any) {
        let temp:Int = Int((lb_middleLow3_num.text! as NSString).intValue)+1
        lb_middleLow3_num.text = String(temp)
        
        sP.track3_Vocal?.pitchShifter?.shift += 1
    }
    @IBAction func bt_middleLow6_minus(_ sender: Any) {
        let temp:Int = Int((lb_middleLow3_num.text! as NSString).intValue)-1
        lb_middleLow3_num.text = String(temp)
        
        sP.track3_Vocal?.pitchShifter?.shift -= 1
    }
   

    @IBAction func bt_low1_holdOn(_ sender: Any) {
        print(sP.track0_MainMixer?.finalPlayerBooster?.volume)
    }

    
    @IBOutlet weak var lb_middleLow1_num: UILabel!
    @IBOutlet weak var lb_middleLow2_num: UILabel!
    @IBOutlet weak var lb_middleLow3_num: UILabel!
    
    
    func initSlider(){
        sld_middle1_volume.callback = { value in self.sP.setTrackVocalVolume(value: self.sld_middle1_volume.value, whichTrack: .track1) }
        sld_middle2_volume.callback = { value in self.sP.setTrackVocalVolume(value: self.sld_middle2_volume.value, whichTrack: .track2) }
        sld_middle3_volume.callback = { value in self.sP.setTrackVocalVolume(value: self.sld_middle3_volume.value, whichTrack: .track3) }
        
        //Main control
        sld_up1_volume.callback = { value in self.sP.track0_MainMixer?.finalPlayerBooster?.volume = self.sld_up1_volume.value}

        sld_up2_offset.callback = { value in
            self.sP.track0_MainMixer?.pitchShifter?.shift = self.sld_up2_offset.value
        }
        // Mix from 0-1
        sld_up3_mix.callback = { value in self.sP.track0_MainMixer?.reverbMixer?.balance = self.sld_up3_mix.value}

        sld_up4_delay.callback = { value in self.sP.track0_MainMixer?.variableDelay?.time = self.sld_up4_delay.value}
    }
    
    //fresh the UI
    func refreshUI(){
        sld_up1_volume.value = (sP.track0_MainMixer?.finalPlayerBooster?.volume)!
        sld_up2_offset.value = (sP.track0_MainMixer?.pitchShifter?.shift)!
        sld_up3_mix.value = (sP.track0_MainMixer?.reverbMixer?.balance)!
        sld_up4_delay.value = (sP.track0_MainMixer?.variableDelay?.time)!
        sld_middle1_volume.value = (sP.track1_Vocal?.finalPlayerBooster?.gain)!
        sld_middle2_volume.value = (sP.track2_Vocal?.finalPlayerBooster?.gain)!
        sld_middle3_volume.value = (sP.track3_Vocal?.finalPlayerBooster?.gain)!
        
        lb_middleLow1_num.text = String(Int((sP.track1_Vocal?.pitchShifter?.shift)!))
        lb_middleLow2_num.text = String(Int((sP.track2_Vocal?.pitchShifter?.shift)!))
        lb_middleLow3_num.text = String(Int((sP.track3_Vocal?.pitchShifter?.shift)!))
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSlider()
        
        sP.startTrack(tracks: .track1,.track2,.track3)
        sP.stopTrack(tracks: .track4)
        refreshUI()
        //Temp setting
        print("ViewController")
        setBorderColor()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    func setBorderColor(){
        for ui: UIView in (self.view.subviews){
            ui.layer.borderColor = UIColor.white.cgColor;
        }
        
        for ui: UIView in (stackView1.subviews){
            ui.layer.borderColor = UIColor.white.cgColor;
        }
        for ui: UIView in (stackView2.subviews){
            ui.layer.borderColor = UIColor.white.cgColor;
        }
        for ui: UIView in (stackView3.subviews){
            ui.layer.borderColor = UIColor.white.cgColor;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

