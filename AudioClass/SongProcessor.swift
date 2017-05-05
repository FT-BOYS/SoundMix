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


public class SongProcessor {
    
    static let sharedInstance = SongProcessor()
    //load once
    var loaded = false
    var plot:AKNodeOutputPlot!
    //Default Vars
    var audioFile: AKAudioFile!
    var audioFilePlayer: AKAudioPlayer!
    var mic:AKMicrophone!
    var micMixer:AKMixer!
    var initMixer:AKMixer!
    //OYZH added
    //Tracks
    ///Normal vocal
    var track1_Vocal:SMVocal!
    var track2_Vocal:SMVocal!
    var track3_Vocal:SMVocal!
    var track4_Instrument:SMInstrument_2!
    
    //audio componment
    var tracker:AKFrequencyTracker!
    
    //Final output of SongProcessor
    var track0_MainMixer:SMAudioEffector!
    
    enum TrackId{
        case trackAll, track1, track2, track3, track4, track5, track6
    }
    //paras for control
    var highestFreq = 4000.0, lowestFreq = 100.0
    var track1_Pitch = 0, track2_Pitch = 0, track3_Pitch = 0, vocal_Pitch = 0.0, track4_Pitch = 0
    var lowestAmp = 0.01
    var amplitudeTrackOpen = false, acceptAllFreq = false
    
    //Adjust Tone compulsoryly
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    func getClosestFreq(frequency:Float){
        var minDistance: Float = 10_000.0
        var index = 0
        
        for i in 0..<noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[i]) - frequency)
            if distance < minDistance {
                index = i
                minDistance = distance
            }
        }
//        let octave = Int(log2f(Float(tracker.frequency) / frequency))
//        noteNameWithSharpsLabel.text = "\(noteNamesWithSharps[index])\(octave)"
//        noteNameWithFlatsLabel.text = "\(noteNamesWithFlats[index])\(octave)"
    }
    

    
    private func freqToStandFreq( inputFreq:Double, midiDistance:Int = 0) -> Double{
        return
            (
                lroundf(
                    Float(inputFreq.frequencyToMIDINote())
                    ) + midiDistance)
                .midiNoteToFrequency()
    }
    
    //设置输入的音符八度
    var printFlag = false
    var lastMidiNote = 0.0
    var currentF = 0.00
    var tmpFreq = 0.00
    var useLessData = 0
    var tmpTimes = 0, sumOfTimeFreq = 0.0
    var tmpAmp = 0.0
    let repeatTimes = 1
    private func freqRepeatFunc()
    {
        tmpFreq = (tracker?.frequency)!
        tmpAmp = (tracker?.amplitude)! * 100//The real amplitude
        if(amplitudeTrackOpen){
            // Double the volume
            track4_Instrument?.instrument.amplitude = tmpAmp*2
        }

        if(  tmpFreq < highestFreq  && tmpFreq > lowestFreq && tmpAmp > 0.1 ){
            //Get repeatTimes data
            tmpTimes = (tmpTimes + 1) % repeatTimes
            sumOfTimeFreq += tmpFreq
            if(tmpTimes == repeatTimes - 1){
                tmpFreq = sumOfTimeFreq / repeatTimes
                tmpTimes = 0
                sumOfTimeFreq = 0
                
                let rateOfChange = abs ( (currentF - tmpFreq )/currentF )
                //little change
                if( rateOfChange < 0.02 ){
                    //note on because it's another note
                    if(tmpAmp  < 0.01){
                        noteOffEvent(lastMidiNote)
                        noteOnEvent(tmpFreq.frequencyToMIDINote())
                        lastMidiNote = tmpFreq.frequencyToMIDINote()
                        currentF = tmpFreq
                    }
                    
                    if(printFlag){
                        print(1)
                    }
                }
                    //Whether is significant change
                else if (rateOfChange > 0.7){
                    useLessData += 1
                    if(useLessData > 5){
                        useLessData = 0
                        resetCurrentFreq()
//                        print("reset current frequency")
                    }
                    if(printFlag){
                        print(2)
                    }
                }
                    //Appropriate change rate
                else{
                    currentF = tmpFreq

                    noteOffEvent(lastMidiNote)
                    noteOnEvent(tmpFreq.frequencyToMIDINote())
                    lastMidiNote = tmpFreq.frequencyToMIDINote()
                    
                    currentF = tmpFreq
                    if(printFlag){
                        print(3)
                    }
                }
                
                
            }
                //Useless Data, set threshold to release data
            else{
                useLessData += 1
                if(useLessData > 30){
                    useLessData = 0
                    resetCurrentFreq()
                }
                if(printFlag){
                    print(4)
                }
            }
        }
        else{
//            print("Invalid frequency")
        }
//        print("The final result: tmpFrequency:\(tmpFreq) & tmpAmplitude:\(String(describing: tmpAmp))")
    }
    
    
    private func freqRepeatFunc_AcceptAll()
    {
        tmpFreq = (tracker?.frequency)!
        tmpFreq = freqToStandFreq(inputFreq: tmpFreq)
        tmpAmp = (tracker?.amplitude)! * 100//The real amplitude
        if(amplitudeTrackOpen){
            // Double the volume
            track4_Instrument?.instrument.amplitude = tmpAmp*2
        }
        //tmpAmp = volume * 0.01 = 0.1
        if(tmpAmp > 0.1 && tmpFreq < highestFreq  && tmpFreq > lowestFreq){
            noteOffEvent(lastMidiNote)
            noteOnEvent(tmpFreq.frequencyToMIDINote())
            lastMidiNote = tmpFreq.frequencyToMIDINote()
            currentF = tmpFreq
        }
//        print("The final result: tmpFrequency:\(tmpFreq) & tmpAmplitude:\(String(describing: tmpAmp))")
    }

    
    private func noteOnEvent(_ note: Double){
        if(note < 5000 && note > 0){
            noteOnEvent(note:Int(note + track4_Pitch))
        }
        
    }
    private func noteOffEvent(_ note: Double){
        if(note < 5000 && note > 0){
            noteOffEvent(note:Int(note + track4_Pitch))
        }
    }
    
    private func noteOnEvent(note: Int){
        track4_Instrument?.noteOn(num: UInt8(note))
    }
    
    private func noteOffEvent(note: Int){
        track4_Instrument?.noteOff(num: UInt8(note))
    }

    func resetCurrentFreq(){
        currentF = (tracker?.frequency)!
    }
    
    func changeInstrument(ins:Enum_SMInstrument){
        track4_Instrument?.changeIns(ins)
    }
    
    //Init mic first, and bundle the frequency tracker
    func initMic(){
        mic = AKMicrophone()
        micMixer = AKMixer(mic!)
        tracker = AKFrequencyTracker(micMixer!)
        micMixer?.volume = 0.01
        
        //Start monitor the input mic
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true){_ in
                if(self.acceptAllFreq){
                    self.freqRepeatFunc_AcceptAll()
                }else{
                    self.freqRepeatFunc()
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    //test init
    func testInit(){
        audioFile = try? AKAudioFile(readFileName: "testAcc.mp3",
                                     baseDir: .resources)
        audioFilePlayer = try? AKAudioPlayer(file: audioFile!)
        audioFilePlayer?.looping = false
    }
    
    ///Desciption Init track default para
    func initPara(){
//        track2_Vocal?.pitchShifter?.shift = 0
//        track3_Vocal?.pitchShifter?.shift = 0
    }
    
    
    //Default func
    init() {
        //Init mic to capture the frequency
        initMic()
        // init the tracks and track0_MainMixer to play the audio
        track1_Vocal = SMVocal(initNode: mic!)
        track2_Vocal = SMVocal(initNode: mic!)
        track3_Vocal = SMVocal(initNode: mic!)
        track4_Instrument = SMInstrument_2(Name: .ins1)
    
        
        initMixer = AKMixer(tracker!,
                                track1_Vocal?.finalPlayerBooster,
                                track2_Vocal?.finalPlayerBooster,
                                track3_Vocal?.finalPlayerBooster,
                                track4_Instrument?.instrument,
            audioFilePlayer
        )
        track0_MainMixer = SMAudioEffector(initNode: initMixer!)
        
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
    func setMainVolume(_ value:Double){
        track0_MainMixer?.finalPlayerBooster?.volume = value
    }
    
    func setTrackVocalPitch(value:Double, whichTrack:TrackId){
        switch whichTrack {
        case .track1:
            track1_Vocal?.pitchShifter?.shift = value
        case .track2:
            track2_Vocal?.pitchShifter?.shift = value
        case .track3:
            track3_Vocal?.pitchShifter?.shift = value
        default:
            break
        }
    }
    
    func setAllVocalPitch(value:Double){
         track1_Vocal?.pitchShifter?.shift = value
         track2_Vocal?.pitchShifter?.shift = value
         track3_Vocal?.pitchShifter?.shift = value
    }
    
    func setTrackVocalVolume(value:Double, whichTrack:TrackId){
        (returnTrack(trackId:whichTrack) as! AKBooster ).gain = value
    }
    
    
    //Demo function
    
    func demo2_controlIns(){
        changeInstrument(ins: .ins3)
        track0_MainMixer?.reverbMixer?.balance = 0.8
        lowestFreq = 700
        highestFreq = 3000
        amplitudeTrackOpen = true
        acceptAllFreq = true
        track4_Pitch = -12
    }
    
    func demo3_controlIns(){
        changeInstrument(ins: .ins2)
        track0_MainMixer?.reverbMixer?.balance = 0.8
        track0_MainMixer?.finalPlayerBooster?.volume = 0.8
        lowestFreq = 60
        highestFreq = 300
        amplitudeTrackOpen = true
        acceptAllFreq = false
        track4_Pitch = 12
    }
    
    
    /// Set Delay of all the vocal tracks
    ///
    /// - Parameter value: 1.00 seconds
    func setAllVocalDelay(value:Double){
    }
    
    
    /// Stop tracks individually
    ///
    /// - Parameter tracks: which track to stop
    func stopTrack(tracks:TrackId...){
        for id in tracks{
            switch id {
            case .track1:
                track1_Vocal?.stop()
            case .track2:
                track2_Vocal?.stop()
            case .track3:
                track3_Vocal?.stop()
            case .track4:
                track4_Instrument?.stop()
            case .track5:
                break
            default:
                break
            }
        }
    }
    
    /// Start tracks individually
    ///
    /// - Parameter tracks: which track to start
    func startTrack(tracks:TrackId...){
        for id in tracks{
            switch id {
            case .track1:
                track1_Vocal?.start()
            case .track2:
                track2_Vocal?.start()
            case .track3:
                track3_Vocal?.start()
            case .track4:
                track4_Instrument?.start()
            case .track5:
                break
            default:
                break
            }
        }
    }
    
    
    //Main
    
    /// start of stop all track(main)
    ///
    /// - Parameter nowVolume: 0 to 1; it's gain
    /// - Returns: ture->start false->stop
    func startOfStopMain(nowVolume:Double)->Bool{
        let dDmp = track0_MainMixer?.finalPlayerBooster?.volume ?? 0.0
        if( dDmp > 0.0){
            track0_MainMixer?.finalPlayerBooster?.volume = 0.0
            return false
        }
        else{
            track0_MainMixer?.finalPlayerBooster?.volume = nowVolume
            return true
        }
    }
    
    ///return which track~
    func returnTrack(trackId:TrackId) -> AKNode?{
        switch trackId {
        case .trackAll:
            return track0_MainMixer?.finalPlayerBooster
        case .track1:
            return track1_Vocal?.finalPlayerBooster
        case .track2:
            return track2_Vocal?.finalPlayerBooster
        case .track3:
            return  track3_Vocal?.finalPlayerBooster
        case .track4:
            return track4_Instrument?.instrument
        default:
            return track0_MainMixer?.finalPlayerBooster
        }
    }
    
    ///Main Track
    func holdOn(nowVolume:Double = 1.0, whichTrack:TrackId) {
        track0_MainMixer?.start()
    }
    
    func holdHoldOn(nowVolume:Double = 1.0,whichTrack:TrackId){

    }
    
    func releaeHoldOn(whichTrack:TrackId){
        switch whichTrack {
        case .trackAll:
            track0_MainMixer?.stop()
        default:
            break
        }
        
        
    }
    
    //default setting for instrument
    func useDefaultFreqRange(_ value: Enum_SMFrequency){
        switch value {
        case .set1://默认
            lowestFreq = 50
            highestFreq = 3000
        case .set2://最大
            lowestFreq = 50
            highestFreq = 3000
        case .set3://男生
            lowestFreq = 60
            highestFreq = 350
        case .set4://女生
            lowestFreq = 150
            highestFreq = 650
        case .set5://口哨
            lowestFreq = 700
            highestFreq = 3000
        case .set6://乐器
            lowestFreq = 190
            highestFreq = 1500
        default: break
            
        }
    }
    func useDefaultChorus(_ value: Enum_ChrusSetting){
        switch value {
        case .set1:
            track1_Vocal?.pitchShifter?.shift = -5
            track2_Vocal?.pitchShifter?.shift = -12
            track3_Vocal?.pitchShifter?.shift = 0
        case .set2:
            track1_Vocal?.pitchShifter?.shift = 12
            track2_Vocal?.pitchShifter?.shift = -12
            track3_Vocal?.pitchShifter?.shift = 0
        case .set3:
            track1_Vocal?.pitchShifter?.shift = 0
            track2_Vocal?.pitchShifter?.shift = 0
            track3_Vocal?.pitchShifter?.shift = 0
        default: break
            
        }
    }
    
    
    //Effectors of Main track
    
    ///The first effector - MoogLadderViewController
    func updateVolume(_ value:Double){
        track0_MainMixer?.finalPlayerBooster?.volume = value;
    }
    
    ///MoogLadderViewController
    func updateCutoffFrequncy(_ value: Double) {
        track0_MainMixer?.moogLadder?.cutoffFrequency = value;
    }
    
    ///MoogLadderViewController
    func updateResonance(_ value: Double) {
        track0_MainMixer?.moogLadder?.resonance = value
    }
    
    ///MoogLadderViewController
    func updateMix_filterMixer(_ value: Double) {
        track0_MainMixer?.filterMixer?.balance = value
    }
    
    ///Get MoogLadderViewController
    func getCutoffFrequncy()->Double?{
        return track0_MainMixer?.moogLadder?.cutoffFrequency
    }
    
    ///Get MoogLadderViewController
    func getResonance()->Double?{
        return track0_MainMixer?.moogLadder?.resonance
    }
    
    ///Get MoogLadderViewController
    func getMix_filterMixer()->Double?{
        return track0_MainMixer?.filterMixer?.balance
    }
    
    
    /// The second effector - VariableDelayViewController
    ///
    /// - Parameters:
    ///   - value: value to pass in
    ///   - whichTrack: which track
    func updateTime(_ value: Double) {
       track0_MainMixer?.variableDelay?.time = value
    }
    
    ///VariableDelayViewController
    func updateFeedback(_ value: Double) {
        track0_MainMixer?.variableDelay?.feedback = value
    }
    
    ///VariableDelayViewController
    func updateMix2_delayMixer(_ value: Double) {
        track0_MainMixer?.delayMixer?.balance = value
    }
    
    ///Get VariableDelayViewController
    func getTime()->Double? {
       return track0_MainMixer?.variableDelay?.time
    }
    
    ///Get VariableDelayViewController
    func getFeedback()->Double? {
        return track0_MainMixer?.variableDelay?.feedback
    }
    
    ///Get VariableDelayViewController
    func getMix2_delayMixer()->Double? {
        return track0_MainMixer?.delayMixer?.balance
    }
    
    
    //The third effector - CostelloReverbViewController
    ///CostelloReverbViewController
    func updateFeedback3(_ value: Double) {
        track0_MainMixer?.reverb?.feedback = value
    }
    ///CostelloReverbViewController
    func updateMix3_reverbMixer(_ value: Double) {
        track0_MainMixer?.reverbMixer?.balance = value
    }
    
    ///Get CostelloReverbViewController
    func getFeedback3()->Double?{
       return track0_MainMixer?.reverbMixer?.balance
    }
    
     ///Get CostelloReverbViewController
    func getMix3_reverbMixer()->Double?{
        return track0_MainMixer?.reverb?.feedback
    }
    
    
    ///The 4 effector - PitchShifterViewController
    func updatePitch(_ value: Double)  {
        track0_MainMixer?.pitchShifter?.shift = value
    }
    
    ///PitchShifterViewController
    func updateMix4_pitchMixer(_ value: Double)  {
       track0_MainMixer?.pitchMixer?.balance = value
    }
    
    ///Get PitchShifterViewController
    func getPitch()->Double?  {
       return track0_MainMixer?.pitchShifter?.shift
    }
    
    ///Get PitchShifterViewController
    func getMix4_pitchMixer()->Double?  {
        return track0_MainMixer?.pitchMixer?.balance
    }
    
    
    
    ///The 5 effector - BitCrusherViewController
    func updateBitDepth(_ value: Double)  {
       track0_MainMixer?.bitCrusher?.bitDepth = value
    }
    
    ///BitCrusherViewController
    func updateSampleRate(_ value: Double)  {
        track0_MainMixer?.bitCrusher?.sampleRate = value
    }
    
    ///BitCrusherViewController
    func updateMix5_bitCrushMixer(_ value: Double)  {
        track0_MainMixer?.bitCrushMixer?.balance = value
    }
    
    ///Get BitCrusherViewController
    func getBitDepth(_ value: Double)->Double?  {
       return track0_MainMixer?.bitCrusher?.bitDepth
    }
    
    ///Get BitCrusherViewController
    func getSampleRate(_ value: Double)->Double?  {
      return track0_MainMixer?.bitCrusher?.sampleRate
    }
    
    ///Get BitCrusherViewController
    func getMix5_bitCrushMixer(_ value: Double)->Double?  {
       return track0_MainMixer?.bitCrushMixer?.balance
    }
    
    
    
}
