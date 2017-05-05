import AudioKit

public class SMInstrument_1{
    public var instrument:AKSampler
    public var velocity:Int
    
    public init(Name:String){
        instrument = AKSampler()
        velocity = 80
        try? instrument.loadWav(Name)
        
    }
    
    //播放
    public func noteOn(num:UInt8){
        instrument.play(noteNumber:num,velocity:MIDIVelocity(velocity))
    }
    //关闭
    public func noteOff(num:UInt8){
        instrument.stop(noteNumber:num)
    }
    
   
    
}

public class SMInstrument_2{
    public var instrument:AKMorphingOscillator!
    public var velocity:Int
    public init(Name:Enum_SMInstrument){
        instrument = AKMorphingOscillator(waveformArray:
            [AKTable(.sine), AKTable(.triangle), AKTable(.sawtooth), AKTable(.square)])
        velocity = 80
        changeIns(Name)
    }
    
    //播放
    public func noteOn(num:UInt8){
        instrument.frequency = num.midiNoteToFrequency()
    }
    
    //关闭
    public func noteOff(num:UInt8){
        
    }
    
    public func start(){
        instrument.start()
    }
    
    public func stop(){
        instrument.stop()
    }
    
    public func changeIns(_ Name:Enum_SMInstrument){
        switch Name {
        case .ins1:
            instrument.index = 0
            break
        case .ins2:
            instrument.index = 1
            break
        case .ins3:
            instrument.index = 2
            break
        case .ins4:
            instrument.index = 3
            break
        default:
            break
            print("The instrument doesn't exist (at least now:P).")
        }

    }
}
