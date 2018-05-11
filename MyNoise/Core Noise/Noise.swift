//
//  Noise.swift
//  MyNoise
//
//  Created by Kevin Sullivan on 2/18/17.
//  Copyright © 2017 Kevin Sullivan. All rights reserved.
//

import Foundation
import UIKit
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

protocol NoiseDelegate {
    func noiseDidStart()
    func noiseDidStop()
    func noiseInterrupted()
}

/// Singleton used to manage noise rendering
class Noise: UIResponder {
    /// Singleton accessor
    public static let shared = Noise()
    
    // Private initializer for singleton - perfect time to seed our random number generator
    private override init() { srand48(🔥) }
    
    public var delegate: NoiseDelegate?
    
    private var audioUnit: AudioComponentInstance?
    /// - note: Use `change(to:)` to change the type of noise
    private(set) var type: NoiseType = .brown
    
    /// The most recent time Noise was toggled
    private var lastTimeToggled: TimeInterval = Date().timeIntervalSince1970
    
    public var isPlaying = false
    
    override var canBecomeFirstResponder: Bool { return true }
    
    /// Switches type of noise
    /// - parameter type: Desired noise type
    public class func change(to type: NoiseType) { Noise.shared.type = type }
    
    /// Starts outputting noise
    /// - returns: Status code for potential error
    @discardableResult public class func start() -> OSStatus {
        let result = Noise.shared.start()
        
        if result == noErr {
            log.debug("Started outputting noise successfully")
        } else {
            log.error("Failed to start outputting noise (\(result))")
        }
        
        return result
    
    }
    
    /// Toggles the current state (stops if playing, starts if not playing)
    @discardableResult public class func toggle() -> OSStatus { return Noise.shared.toggle() }
    
    @discardableResult private func toggle() -> OSStatus {
        if isPlaying {
            return stop()
        } else {
            return start()
        }
    }
    
    /// Stops outputting noise
    @discardableResult public class func stop() -> OSStatus { return Noise.shared.stop() }
    
    @discardableResult private func start() -> OSStatus {
        guard !isPlaying else {
            return kAudioComponentErr_NotPermitted
        }
        
        log.debug("Preparing audio unit")
        
        var result = prepareAudio()
        
        guard let audioUnit = audioUnit, result == noErr else {
            log.error("Failed to prepare audio unit (\(result))")
            return result
        }
        
        log.debug("Initializing audio unit")
        
        result = AudioUnitInitialize(audioUnit)
        
        guard result == noErr else {
            log.error("Failed to initialize audio unit (\(result))")
            return result
        }
        
        result = AudioOutputUnitStart(audioUnit)
        
        guard result == noErr else {
            log.error("Failed to start audio output (\(result))")
            return result
        }
        
        isPlaying = true
        lastTimeToggled = Date().timeIntervalSince1970
        delegate?.noiseDidStart()
        
        return result
    }

    @discardableResult private func stop() -> OSStatus {
        guard let audioUnit = audioUnit, isPlaying else {
            return kAudioComponentErr_NotPermitted
        }
        
        log.debug("Stopping audio")
        
        AudioOutputUnitStop(audioUnit)
        AudioUnitUninitialize(audioUnit)
        AudioComponentInstanceDispose(audioUnit)
        
        self.audioUnit = nil
        
        isPlaying = false
        lastTimeToggled = Date().timeIntervalSince1970
        delegate?.noiseDidStop()
        
        return noErr
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
        
        log.debug("Discovering output")
        
        guard let defaultOutput = AudioComponentFindNext(nil, &defaultOutputDescription) else {
            log.error("Could not find default output")
            return kAudioUnitErr_InstrumentTypeNotFound
        }
        
        log.debug("Creating new component using default output")
        
        var error = AudioComponentInstanceNew(defaultOutput, &audioUnit)
        
        guard error == noErr else {
            log.error("Could not create brownUnit (\(error))")
            return error
        }
        
        // Set up callback
        var input = AURenderCallbackStruct()
        input.inputProc = renderNoise
        input.inputProcRefCon = Unmanaged.passUnretained(self).toOpaque()
        let inputSize = uint(MemoryLayout.size(ofValue: input))
        
        log.debug("Configuring audio unit callback")
        
        error = AudioUnitSetProperty(audioUnit!,
                                     kAudioUnitProperty_SetRenderCallback,
                                     kAudioUnitScope_Input,
                                     0,
                                     &input,
                                     inputSize)
        
        guard error == noErr else {
            log.error("Could not configure callback (\(error))")
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
        
        log.debug("Setting stream properties for audio unit")
        
        error = AudioUnitSetProperty(audioUnit!,
                                     kAudioUnitProperty_StreamFormat,
                                     kAudioUnitScope_Input,
                                     0,
                                     &stream,
                                     streamSize)
        
        guard error == noErr else {
            log.error("Could not configure stream parameters (\(error))")
            return error
        }
        
        return noErr
    }
    
    class func handleInterruption() {
        log.debug("Audio session interupted")
        
        Noise.shared.delegate?.noiseInterrupted()
        
        if Noise.shared.isPlaying {
            log.debug("Stopping noise")
            Noise.stop()
        } else {
            log.debug("Nothing playing, no action needed")
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        // We only care about remote control events
        guard let event = event, event.type == .remoteControl else {
            return
        }
        
        switch event.subtype {
        case .remoteControlTogglePlayPause:
            toggle()
        default: break
        }
    }
}

/// Renders noise based on `Noise` state
public func renderNoise(inRefCon:UnsafeMutableRawPointer,
                        ioActionFlags:UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                        inTimeStamp:UnsafePointer<AudioTimeStamp>,
                        inBusNumber:UInt32,
                        inNumberFrames:UInt32,
                        ioData:UnsafeMutablePointer<AudioBufferList>?) -> OSStatus
{
    guard Noise.shared.isPlaying else { return noErr }
    
    let noise = Noise.generate(count: Int(inNumberFrames))
    let audioListPointer = UnsafeMutableAudioBufferListPointer(ioData)
    
    audioListPointer?[0].mDataByteSize = inNumberFrames * uint(MemoryLayout<Float>.size)
    audioListPointer?[0].mData = UnsafeMutableRawPointer(mutating: noise)
    
    return noErr
}
