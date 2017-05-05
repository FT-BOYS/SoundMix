//
//  SMAudioEffector.swift
//  SongProcessor
//
//  Created by OYZH on 2017/3/24.
//  Copyright © 2017年 AudioKit. All rights reserved.
//

import Foundation
import AudioKit

public class SMAudioEffector{
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
    public var finalPlayerBooster: AKMixer?
    
    fileprivate var lastKnownGain: Double = 1.0

    
    init(initNode:AKNode){
        inputNode = initNode
        startVariableDelay()
        startMoogLadder()
        startCostelloReverb()
        startPitchShifting()
        startBitCrushing()
        
        //Booster for Volume
        finalPlayerBooster = AKMixer(bitCrushMixer!)
    }
    
    func startVariableDelay() {
        variableDelay = AKVariableDelay(inputNode!)
        variableDelay?.rampTime = 0
        variableDelay?.time = 0
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
    
    /// Function to start, play, or activate the node, all do the same thing
    open func start() {
        finalPlayerBooster?.volume = lastKnownGain
        
    }
    
    /// Function to stop or bypass the node, both are equivalent
    open func stop() {
        lastKnownGain = (finalPlayerBooster?.volume)!
        finalPlayerBooster?.volume = 0
    }
}
