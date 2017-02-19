//
//  Noise.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Foundation
import AudioToolbox

public enum NoiseType {
    case white, brown
    
    fileprivate var generator: (Int) -> NoisePoints {
        switch self {
        case .white:
            return generateWhiteNoise
        case .brown:
            return generateBrownNoise
        }
    }
}

/// Singleton used to manage noise rendering
class Noise {
    /// Singleton accessor
    public static let shared = Noise()
    
    // Private initializer for singleton - perfect time to seed our random number generator
    private init() { srand48(🔥) }
    
    public var brownianFeedback: Float = 0
    public var brownianUpperBound: Float = 10
    public var brownianDamping: Float = 5
    
    private var audioUnit: AudioComponentInstance? = nil
    
    /// - note: Use `change(to:)` to change the type of noise
    private(set) var type: NoiseType = .brown
    
    public var isPlaying = false
    
    /// Switches type of noise
    /// - parameter type: Desired noise type
    public class func change(to type: NoiseType) { Noise.shared.type = type }
    
    /// Starts outputting noise
    /// - returns: Status code for potential error
    @discardableResult public class func start() -> OSStatus {
        let result = Noise.shared.start()
        
        if result == noErr {
            print("Started outputting noise successfully")
        } else {
            print("Failed to start outputting noise")
        }
        
        return result
    
    }
    
    /// Stops outputting noise
    public class func stop() { return Noise.shared.stop() }
    
    private func start() -> OSStatus {
        print("Preparing audio unit")
        
        var result = prepareAudio()
        
        guard let audioUnit = audioUnit, result == noErr else {
            print("Error: failed to prepare audio unit (\(result))")
            return result
        }
        
        print("Initializing audio unit")
        
        result = AudioUnitInitialize(audioUnit)
        
        guard result == noErr else {
            print("Error: failed to initialize audio unit (\(result))")
            return result
        }
        
        return AudioOutputUnitStart(audioUnit)
    }

    private func stop() {
        guard let audioUnit = audioUnit else {
            return
        }
        
        print("Stopping audio")
        
        AudioOutputUnitStop(audioUnit)
        AudioUnitUninitialize(audioUnit)
        AudioComponentInstanceDispose(audioUnit)
    }
    
    /**
     Generates the specified number of noise points
     
     - parameter count: The number of noise points to generate
     - parameter type: (Optional) The type of noise to generate
     - note: Type defaults to `Noise.shared.type`
    */
    fileprivate class func generate(count: Int, type: NoiseType = Noise.shared.type) -> NoisePoints {
        return type.generator(count)
    }
    
    /**
     Prepares our audio unit for initialization
     
     - returns: Status code indicating any error encountered or `noErr` if all is well
    */
    private func prepareAudio() -> OSStatus {
        audioUnit = nil
        
        // Prepare default audio output description for lookup
        var defaultOutputDescription = AudioComponentDescription()
        defaultOutputDescription.componentType = kAudioUnitType_Output
        defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO
        defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple
        defaultOutputDescription.componentFlags = 0
        defaultOutputDescription.componentFlagsMask = 0
        
        print("Discovering output")
        
        guard let defaultOutput = AudioComponentFindNext(nil, &defaultOutputDescription) else {
            print("Error: could not find default output")
            return kAudioUnitErr_InstrumentTypeNotFound
        }
        
        print("Creating new component using default output")
        
        var error = AudioComponentInstanceNew(defaultOutput, &audioUnit)
        
        guard error == noErr else {
            print("Error: could not create brownUnit (\(error))")
            return error
        }
        
        // Set up callback
        var input = AURenderCallbackStruct()
        input.inputProc = renderNoise
        input.inputProcRefCon = Unmanaged.passUnretained(self).toOpaque()
        let inputSize = uint(MemoryLayout.size(ofValue: input))
        
        print("Configuring audio unit callback")
        
        error = AudioUnitSetProperty(audioUnit!,
                                     kAudioUnitProperty_SetRenderCallback,
                                     kAudioUnitScope_Input,
                                     0,
                                     &input,
                                     inputSize)
        
        guard error == noErr else {
            print("Error: could not configure callback (\(error))")
            return error
        }
        
        // Configure audio stream parameters
        var stream = AudioStreamBasicDescription()
        stream.mSampleRate = 44100 // # samples / second
        stream.mFormatID = kAudioFormatLinearPCM
        stream.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved
        stream.mBytesPerPacket = 4
        stream.mBytesPerFrame = 4
        stream.mFramesPerPacket = 1
        stream.mChannelsPerFrame = 1
        stream.mBitsPerChannel = 32
        let streamSize = uint(MemoryLayout.size(ofValue: stream))
        
        print("Setting stream properties for audio unit")
        
        error = AudioUnitSetProperty(audioUnit!,
                                     kAudioUnitProperty_StreamFormat,
                                     kAudioUnitScope_Input,
                                     0,
                                     &stream,
                                     streamSize)
        
        guard error == noErr else {
            print("Error: could not configure stream parameters (\(error))")
            return error
        }
        
        return noErr
    }
}

/// Renders noise based on `Noise` state
public func renderNoise(inRefCon:UnsafeMutableRawPointer,
                        ioActionFlags:UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                        inTimeStamp:UnsafePointer<AudioTimeStamp>,
                        inBusNumber:UInt32,
                        inNumberFrames:UInt32,
                        ioData:UnsafeMutablePointer<AudioBufferList>?) -> OSStatus {
    
    let audioListPointer = UnsafeMutableAudioBufferListPointer(ioData)
    audioListPointer?[0].mDataByteSize = inNumberFrames * uint(MemoryLayout<Float>.size)
    
    let whiteNoise = Noise.generate(count: Int(inNumberFrames))
    audioListPointer?[0].mData = UnsafeMutableRawPointer(mutating: whiteNoise)
    
    return noErr
}
