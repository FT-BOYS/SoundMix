//
//  SMAudioEffector.swift
//  SongProcessor
//
//  Created by OYZH on 2017/3/24.
//  Copyright © 2017年 AudioKit. All rights reserved.
//

import Foundation
import AudioKit

public class SMVocal{
    //Default Vars
    public var inputNode: AKNode?
    fileprivate var lastKnownGain: Double = 1.0
    
    
    public var pitchShifter: AKPitchShifter?
    
    ///This is the final output
    public var finalPlayerBooster: AKBooster?
    
    init(initNode:AKNode){
        inputNode = initNode
        startPitchShifting()
        //Booster for Volume
        finalPlayerBooster = AKBooster(pitchShifter, gain: 0.5)
    }
    
    func startPitchShifting() {
        pitchShifter = AKPitchShifter(inputNode!)
    }
    
    func setDefaultPitchShifting(shift:Double=5.0){
        pitchShifter?.shift = shift
    }
    
    
    // MARK: - Control
    
    /// Function to start, play, or activate the node, all do the same thing
    open func start() {
        finalPlayerBooster?.gain = lastKnownGain
        
    }
    
    /// Function to stop or bypass the node, both are equivalent
    open func stop() {
        lastKnownGain = (finalPlayerBooster?.gain)!
        finalPlayerBooster?.gain = 0
    }
}
