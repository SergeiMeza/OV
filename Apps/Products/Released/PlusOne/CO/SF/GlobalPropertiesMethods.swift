//
//  GlobalPropertiesMethods.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import Foundation

var soundsLoaded: Bool = false {
didSet {
   if soundsLoaded {
      loadSounds()
      areSoundsActive = true
   } else {
      disposeSounds()
      areSoundsActive = false
   }
}
}

func loadSounds() {
   
   if let addURL = Bundle.main.url(forResource: "add", withExtension: "wav") {
      AudioServicesCreateSystemSoundID(addURL as CFURL, &addSound)
   }
   if let addURL = Bundle.main.url(forResource: "minus", withExtension: "wav") {
      AudioServicesCreateSystemSoundID(addURL as CFURL, &minusSound)
   }
   if let addURL = Bundle.main.url(forResource: "zero", withExtension: "wav") {
      AudioServicesCreateSystemSoundID(addURL as CFURL, &zeroSound)
   }
   if let addURL = Bundle.main.url(forResource: "tock", withExtension: "aiff") {
      AudioServicesCreateSystemSoundID(addURL as CFURL, &tockSound)
   }
}

func disposeSounds() {
   
   AudioServicesDisposeSystemSoundID(addSound)
   AudioServicesDisposeSystemSoundID(minusSound)
   AudioServicesDisposeSystemSoundID(zeroSound)
   AudioServicesDisposeSystemSoundID(tockSound)
}
