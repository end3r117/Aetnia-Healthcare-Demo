//
//  AvatarPictureRandomizer.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


struct Avatar: View {
    
    
    var body: some View {
        ZStack {
            Circle()
        }
    }
}

struct AvatarPictureRandomizer {
    
    static let faceColors: [Color] = [Color(#colorLiteral(red: 0.9764705882, green: 0.9333333333, blue: 0.7215686275, alpha: 1)),Color(#colorLiteral(red: 0.9636437297, green: 0.9242001772, blue: 0.7632328272, alpha: 1)),Color(#colorLiteral(red: 0.9193914533, green: 0.7340729833, blue: 0.4250843525, alpha: 1)), Color(#colorLiteral(red: 0.6588235294, green: 0.537254902, blue: 0.3215686275, alpha: 1)), Color(#colorLiteral(red: 0.3137254902, green: 0.2784313725, blue: 0.2156862745, alpha: 1))]
    static let hairColors: [Color] = [Color(#colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1)), Color(#colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1)), Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),Color(#colorLiteral(red: 0.971729815, green: 0.8831914067, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)), Color(#colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1))]
    static let tieColors: [Color] = [Color(#colorLiteral(red: 1, green: 0.391269505, blue: 0.3030915856, alpha: 1)), .black, .blue, .purple, .primary]
    static let colarColor = Color.white
    static let shirtColor: [Color] = [.red, .green, .black, .white, .orange, .purple]
    static let backgroundCircleColor: [Color] = [.aetniaBlue, .purple, .green,Color(#colorLiteral(red: 0.6679418683, green: 0.9207292199, blue: 0.4711184502, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.6104864478, blue: 0.5146033764, alpha: 1))]
    
    enum Gender {
        case male, female
    }
    
    enum MaleAvatarComponents {
        case one_man_hair(Color), two_man_face(Color), three_man_face_shadow(Color), four_man_neck(Color), five_man_color(Color),
        six_man_tie(Color), seven_man_shirt(Color), eight_man_background(Color)
    }
    
    enum FemaleAvatarComponents {
        case one_woman_collar(Color), two_woman_jacket(Color), three_woman_shirt(Color), four_hair_top(Color), five_face_shadow(Color),
        six_hair_bottom(Color), seven_woman_background(Color)
    }
    
//    static func createAvatar(gender: Gender) -> Avatar {
//
//
//        return Avatar()
//    }
    
}
