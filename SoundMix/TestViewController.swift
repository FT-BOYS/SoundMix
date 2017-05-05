//
//  TestViewController.swift
//  SoundMix
//
//  Created by OYZH on 2017/5/4.
//  Copyright © 2017年 欧阳植昊. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class TestViewController: UIViewController{
    
    let sP = SongProcessor.sharedInstance
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBOutlet weak var sld1_: AKPropertySlider!
    
    @IBOutlet weak var sld2_: AKPropertySlider!
    
    @IBOutlet weak var sld3_: AKPropertySlider!
    
    func initSlider(){
        sld1_.callback = { value in self.sP.track0_MainMixer?.moogLadder?.resonance = self.sld1_.value
        }
        
        sld2_.callback = { value in
            self.sP.track0_MainMixer?.pitchShifter?.shift = self.sld2_.value
        }
        

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TestViewController")
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
