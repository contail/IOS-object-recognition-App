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
        Sample(title:"Photo object Dection" , descrtipion: "불러온 이미지의 사물 분석", image:"ic_photo"),
        Sample(title:"Real Time Object Dection" , descrtipion: "실시간 사물 분석", image:"ic_camera"),
        Sample(title:"Facial Analysis" , descrtipion: "사람의 얼굴,나이,감정 분석", image:"ic_photo")
    ]
}
