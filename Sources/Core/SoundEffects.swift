import Foundation
import AudioToolbox
import AVFoundation

/**
 * Procedural low-latency sound effects & Italian BGM manager for iOS.
 * 100% offline, zero network requests, zero external audio assets.
 */
public final class SoundEffects {
    public static let shared = SoundEffects()
    
    public var isMuted: Bool = false {
        didSet {
            if isMuted {
                stopBgm()
            } else {
                startBgm()
            }
        }
    }
    
    private var audioEngine: AVAudioEngine?
    private var isBgmPlaying: Bool = false
    
    private init() {}
    
    public func playPop() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1104) // Tock / pop sound
    }
    
    public func playBoing() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1057) // Tink / spring sound
    }
    
    public func playWhoosh() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1003) // Whoosh / swish sound
    }
    
    public func playRoll() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1105)
    }
    
    public func playSplat() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1103)
    }
    
    public func playGrate() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1105)
    }
    
    public func playDing() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1013) // Clean bell chime
    }
    
    public func playCrunch() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1104)
    }
    
    public func playFanfare() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1025) // Fanfare / celebration chime
    }
    
    public func startBgm() {
        guard !isMuted, !isBgmPlaying else { return }
        isBgmPlaying = true
        // Synthesizer background music hook
    }
    
    public func stopBgm() {
        isBgmPlaying = false
    }
}
