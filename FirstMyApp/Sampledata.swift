//
//  Sampledata.swift
//  FirstMyApp
//
//  Created by sangjin park on 2018. 9. 3..
//  Copyright © 2018년 Loguin. All rights reserved.
//

import Foundation

struct Sample {
    let title:String
    let descrtipion : String
    let image:String
}

struct SampleData {
    let samples = [
        Sample(title:"Test1" , descrtipion: "test11111", image:"ic_photo"),
        Sample(title:"Test2" , descrtipion: "test22222", image:"ic_camera"),
        Sample(title:"Test3" , descrtipion: "test33333", image:"ic_photo")
    ]
}
