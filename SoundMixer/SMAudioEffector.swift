//
//  SMAudioEffector.swift
//  SongProcessor
//
//  Created by OYZH on 2017/3/24.
//  Copyright © 2017年 AudioKit. All rights reserved.
//

import Foundation
import AudioKit

class SMAudioEffector{
    //Default Vars
    public var inputNode: AKNode?
    public var variableDelay: AKVariableDelay?
    public var delayMixer: AKDryWetMixer?
    public var moogLadder: AKMoogLadder?
    public var filterMixer: AKDryWetMixer?
    public var reverb: AKCostelloReverb?
    public var reverbMixer: AKDryWetMixer?
    public var pitchShifter: AKPitchShifter?
    public var pitchMixer: AKDryWetMixer?
    public var bitCrusher: AKBitCrusher?
    public var bitCrushMixer: AKDryWetMixer?
    ///This is the final output
    public var finalPlayerBooster: AKBooster?

    
    init(initNode:AKNode){
        inputNode = initNode
        startVariableDelay()
        startMoogLadder()
        startCostelloReverb()
        startPitchShifting()
        startBitCrushing()
        
        //Booster for Volume
        finalPlayerBooster = AKBooster(bitCrushMixer!, gain: 1.0)
    }
    
    func startVariableDelay() {
        variableDelay = AKVariableDelay(inputNode!)
        variableDelay?.rampTime = 0.2
        delayMixer = AKDryWetMixer(inputNode!, variableDelay!, balance: 0)
    }
    
    func startMoogLadder() {
        moogLadder = AKMoogLadder(delayMixer!)
        filterMixer = AKDryWetMixer(delayMixer!, moogLadder!, balance: 0)
        
    }
    
    func startCostelloReverb() {
        reverb = AKCostelloReverb(filterMixer!)
        reverbMixer = AKDryWetMixer(filterMixer!, reverb!, balance: 0)
    }
    
    func startPitchShifting() {
        pitchShifter = AKPitchShifter(reverbMixer!)
        pitchMixer = AKDryWetMixer(reverbMixer!, pitchShifter!, balance: 0)
    }
    func setDefaultPitchShifting(shift:Double=5.0, balance:Double=100){
        pitchShifter?.shift = shift
        pitchMixer?.balance = balance
    }
    
    func startBitCrushing() {
        bitCrusher = AKBitCrusher(pitchMixer!)
        bitCrusher?.bitDepth = 16
        bitCrusher?.sampleRate = 3333
        bitCrushMixer = AKDryWetMixer(pitchMixer!, bitCrusher!, balance: 0)
    }
}
