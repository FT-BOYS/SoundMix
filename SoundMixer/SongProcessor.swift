//
//  SongProcessor.swift
//  SongProcessor
//
//  Created by Aurelius Prochazka on 6/22/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import UIKit
import AudioKit
import AVFoundation
import MediaPlayer

class SongProcessor {
    
    static let sharedInstance = SongProcessor()
    
    enum TrackId{
        case trackAll, track1, track2, track3, track4, track5, track6
    }
    var highestFreq = 4000.0
    var lowestAmp = 0.01
    
    //Default Vars
    var audioFile: AKAudioFile?
    var audioFilePlayer: AKAudioPlayer?
    var mic:AKMicrophone?
    var micMixer:AKMixer?
    
    //OYZH added
    //Tracks
    var track1_Vocal:SMAudioEffector?
    var track2_Vocal:SMAudioEffector?
    var track3_Vocal:SMAudioEffector?
    
    var track4_Instrument:SMAudioEffector?
    var track5_Instrument:SMAudioEffector?
    var track6_Instrument:SMAudioEffector?
    
    //instrument & audio componment
    var tracker:AKFrequencyTracker?
    var trackerMixer:AKMixer?
    var oscillator: AKOscillator?
    
    //Final output of SongProcessor
    var track0_MainMixer:SMAudioEffector?
    
    func freqToStandFreq( inputFreq:Double, midiDistance:Int = 0) -> Double{
        return
            (
                lroundf(
                    Float(inputFreq.frequencyToMIDINote())
                    ) + midiDistance)
                .midiNoteToFrequency()
    }
    
    //设置输入的音符八度
    var sumF = 0.0 , currentF = 500.0, loopTimes = 0, tmpFreq = 500.0, errorTime = 0
    var flag = true
    var resArr = [Double]()
    
    func freqRepeatFunc() {
        tmpFreq = (tracker?.frequency)!
        let tmpAmp = tracker?.amplitude
        //        print(self.tracker?.frequency,self.tracker?.amplitude,separator:" ")
        //因为mixer压了声音，这里需要还原
        if(  tmpFreq < highestFreq && tmpAmp!*100 > lowestAmp){
            
            //            print( tmpFreq,tmpAmp!,separator:" ")
            let rateOfChange = abs ( (currentF - tmpFreq )/currentF )
            //变化很小
            if( rateOfChange < 0.05 ){
                loopTimes += 1
                sumF += tmpFreq
                
                //                oscillator?.frequency =  (sumF)/(loopTimes)
                oscillator?.frequency = freqToStandFreq(inputFreq: tmpFreq)
                
                currentF = tmpFreq
            }
                //判断是否是巨大改变
            else if (rateOfChange > 1){
                currentF = tmpFreq
            }
                //变化恰到好处
            else{
                let res = ( (sumF)/(loopTimes) )
                print("Result:----------\(res)")
                resArr.append(res-2)
                print(resArr)
                sumF = tmpFreq
                loopTimes = 1
                currentF = tmpFreq
            }
            print("\(rateOfChange) = \(currentF) and \(tmpFreq)" )
            
        }
            //无效数据
        else{
            
        }
    }
    
    func playAll(){
        oscillator?.play()
    }
    
    func stopAll(){
        oscillator?.stop()
    }
    
    //Init mic first, and bundle the frequency tracker
    func initMic(){
        mic = AKMicrophone()
        micMixer = AKMixer(mic!)
        tracker = AKFrequencyTracker(micMixer!)
        micMixer?.volume = 0.01
        
        //Start monitor the input mic
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true){_ in
                self.freqRepeatFunc()
                //                print(self.tracker?.frequency,self.tracker?.amplitude,separator:" ")
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    //test init
    func testInit(){
        audioFile = try? AKAudioFile(readFileName: "mixloop.wav",
                                     baseDir: .resources)
        audioFilePlayer = try? AKAudioPlayer(file: audioFile!)
        audioFilePlayer?.looping = true
    }
    
    ///Desciption Init track default para
    func initPara(){
        track1_Vocal?.setDefaultPitchShifting(shift: -5, balance: 100)
        track2_Vocal?.setDefaultPitchShifting(shift: -12, balance: 100)
        
        
        
    }
    
    
    //Default func
    init() {
        //Create Instrument
        oscillator = AKOscillator(waveform: AKTable(.sine))
        
        //Init mic to capture the frequency
        initMic()
        // init the tracks and track0_MainMixer to play the audio
        track1_Vocal = SMAudioEffector(initNode: mic!)
        track2_Vocal = SMAudioEffector(initNode: mic!)
        track3_Vocal = SMAudioEffector(initNode: mic!)
        track4_Instrument = SMAudioEffector(initNode: oscillator!)
        track5_Instrument = SMAudioEffector(initNode: oscillator!)
        track6_Instrument = SMAudioEffector(initNode: oscillator!)
        
        let initMixer = AKMixer(tracker!,oscillator!,
                                (track1_Vocal?.finalPlayerBooster)!,
                                (track2_Vocal?.finalPlayerBooster)!,
                                (track3_Vocal?.finalPlayerBooster)!,
                                (track4_Instrument?.finalPlayerBooster)!,
                                (track5_Instrument?.finalPlayerBooster)!,
                                (track6_Instrument?.finalPlayerBooster)!
        )
        track0_MainMixer = SMAudioEffector(initNode: initMixer)
        
        //init para of tools in each track
        initPara()
        
        //any final test init
        testInit()
        
        //start AudioKit
        AudioKit.output = track0_MainMixer?.finalPlayerBooster
        AudioKit.start()
    }
    
    
    //Function for UI
    
    //Main control
    func updateMainVolume(_ value:Double){
        track0_MainMixer?.finalPlayerBooster?.gain = value
    }
    
    //Main
    
    /// start of stop all track(main)
    ///
    /// - Parameter nowVolume: 0 to 1; it's gain
    /// - Returns: ture->start false->stop
    func startOfStopMain(nowVolume:Double)->Bool{
        let dDmp = track0_MainMixer?.finalPlayerBooster?.gain ?? 0.0
        if( dDmp > 0.0){
            track0_MainMixer?.finalPlayerBooster?.gain = 0.0
            return false
        }
        else{
            track0_MainMixer?.finalPlayerBooster?.gain = nowVolume
            return true
        }
    }
    
    ///return which track~
    func returnTrack(trackId:TrackId) -> SMAudioEffector?{
        switch trackId {
        case .trackAll:
            return track0_MainMixer
        case .track1:
            return track1_Vocal
        case .track2:
            return track2_Vocal
        case .track3:
            return  track3_Vocal
        case .track4:
            return track4_Instrument
        case .track5:
            return track5_Instrument
        case .track6:
            return track6_Instrument
        }
    }
    
    ///Main Track
    func startOrStopTrack(nowVolume:Double, whichTrack:TrackId) -> Bool{
        let tmpTrack = returnTrack(trackId: whichTrack)
        let dDmp = tmpTrack?.finalPlayerBooster?.gain ?? 0.0
        if( dDmp > 0.0){
            tmpTrack?.finalPlayerBooster?.gain = 0.0
            return false
        }
        else{
            tmpTrack?.finalPlayerBooster?.gain = nowVolume
            return true
        }
    }
    
    ///The first effector - MoogLadderViewController
    func updateVolume(_ value:Double, whichTrack:TrackId){
        let tmpTrack = returnTrack(trackId: whichTrack)
        tmpTrack?.finalPlayerBooster?.gain = value
    }
    
    
    ///MoogLadderViewController
    func updateCutoffFrequncy(_ value: Double,whichTrack:TrackId) {
        let tmpTrack = returnTrack(trackId: whichTrack)
        tmpTrack?.moogLadder?.cutoffFrequency = value
    }
    
    ///MoogLadderViewController
    func updateResonance(_ value: Double,whichTrack:TrackId) {
        let tmpTrack = returnTrack(trackId: whichTrack)
        tmpTrack?.moogLadder?.resonance = value
    }
    
    ///MoogLadderViewController
    func updateMix_filterMixer(_ value: Double,whichTrack:TrackId) {
        let tmpTrack = returnTrack(trackId: whichTrack)
        tmpTrack?.filterMixer?.balance = value
    }
    
    ///Get MoogLadderViewController
    func getCutoffFrequncy(whichTrack:TrackId)->Double?{
        let tmpTrack = returnTrack(trackId: whichTrack)
        return tmpTrack?.moogLadder?.cutoffFrequency
    }
    
    ///Get MoogLadderViewController
    func getResonance(whichTrack:TrackId)->Double?{
        let tmpTrack = returnTrack(trackId: whichTrack)
        return tmpTrack?.moogLadder?.resonance
    }
    
    ///Get MoogLadderViewController
    func getMix_filterMixer(whichTrack:TrackId)->Double?{
        let tmpTrack = returnTrack(trackId: whichTrack)
        return tmpTrack?.filterMixer?.balance
    }
    
    
    /// The second effector - VariableDelayViewController
    ///
    /// - Parameters:
    ///   - value: value to pass in
    ///   - whichTrack: which track
    func updateTime(_ value: Double,whichTrack:TrackId) {
        returnTrack(trackId: whichTrack)?.variableDelay?.time = value
    }
    
    ///VariableDelayViewController
    func updateFeedback(_ value: Double,whichTrack:TrackId) {
        returnTrack(trackId: whichTrack)?.variableDelay?.feedback = value
    }
    
    ///VariableDelayViewController
    func updateMix2_delayMixer(_ value: Double,whichTrack:TrackId) {
        returnTrack(trackId: whichTrack)?.delayMixer?.balance = value
    }
    
    ///Get VariableDelayViewController
    func getTime(whichTrack:TrackId)->Double? {
        return returnTrack(trackId: whichTrack)?.variableDelay?.time
    }
    
    ///Get VariableDelayViewController
    func getFeedback(whichTrack:TrackId)->Double? {
        return returnTrack(trackId: whichTrack)?.variableDelay?.feedback
    }
    
    ///Get VariableDelayViewController
    func getMix2_delayMixer(whichTrack:TrackId)->Double? {
        return returnTrack(trackId: whichTrack)?.delayMixer?.balance
    }
    
    
    //The third effector - CostelloReverbViewController
    ///CostelloReverbViewController
    func updateFeedback3(_ value: Double,whichTrack:TrackId) {
        returnTrack(trackId: whichTrack)?.reverb?.feedback = value
    }
    ///CostelloReverbViewController
    func updateMix3_reverbMixer(_ value: Double,whichTrack:TrackId) {
        returnTrack(trackId: whichTrack)?.reverbMixer?.balance = value
    }
    
    ///Get CostelloReverbViewController
    func getFeedback3(whichTrack:TrackId)->Double?{
        return returnTrack(trackId: whichTrack)?.reverbMixer?.balance
    }
    
     ///Get CostelloReverbViewController
    func getMix3_reverbMixer(whichTrack:TrackId)->Double?{
        return returnTrack(trackId: whichTrack)?.reverb?.feedback
    }
    
    
    ///The 4 effector - PitchShifterViewController
    func updatePitch(_ value: Double,whichTrack:TrackId)  {
        returnTrack(trackId: whichTrack)?.pitchShifter?.shift = value
    }
    
    ///PitchShifterViewController
    func updateMix4_pitchMixer(_ value: Double,whichTrack:TrackId)  {
        returnTrack(trackId: whichTrack)?.pitchMixer?.balance = value
    }
    
    ///Get PitchShifterViewController
    func getPitch(whichTrack:TrackId)->Double?  {
        return returnTrack(trackId: whichTrack)?.pitchShifter?.shift
    }
    
    ///Get PitchShifterViewController
    func getMix4_pitchMixer(whichTrack:TrackId)->Double?  {
        return returnTrack(trackId: whichTrack)?.pitchMixer?.balance
    }
    
    
    
    ///The 5 effector - BitCrusherViewController
    func updateBitDepth(_ value: Double,whichTrack:TrackId)  {
        returnTrack(trackId: whichTrack)?.bitCrusher?.bitDepth = value
    }
    
    ///BitCrusherViewController
    func updateSampleRate(_ value: Double,whichTrack:TrackId)  {
        returnTrack(trackId: whichTrack)?.bitCrusher?.sampleRate = value
    }
    
    ///BitCrusherViewController
    func updateMix5_bitCrushMixer(_ value: Double,whichTrack:TrackId)  {
        returnTrack(trackId: whichTrack)?.bitCrushMixer?.balance = value
    }
    
    ///Get BitCrusherViewController
    func getBitDepth(whichTrack:TrackId)->Double?  {
        return returnTrack(trackId: whichTrack)?.bitCrusher?.bitDepth
    }
    
    ///Get BitCrusherViewController
    func getSampleRate(whichTrack:TrackId)->Double?  {
        return returnTrack(trackId: whichTrack)?.bitCrusher?.sampleRate
    }
    
    ///Get BitCrusherViewController
    func getMix5_bitCrushMixer(whichTrack:TrackId)->Double?  {
        return returnTrack(trackId: whichTrack)?.bitCrushMixer?.balance
    }
    
    
    
}
