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

protocol Avatar {
    var gender: Gender { get }
}

enum Gender: Int {
    case male, female
}



fileprivate struct FemaleAvatar: View, Avatar {
    var gender: Gender = .female
    var radius: CGFloat
    var components: AvatarComponents
    
    
    var body: some View {
            Circle()
                .fill(components.circularBackground)
                .frame(width: radius, height: radius)
                .overlay(
                    ZStack {
                        Image(uiImage:#imageLiteral(resourceName: "6_hair_bottom"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.hairColor)
                        Image(uiImage: #imageLiteral(resourceName: "5_face"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.faceColor)
                        Image(uiImage:#imageLiteral(resourceName: "5_face_shadow"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.faceShadow)
                        Image(uiImage: #imageLiteral(resourceName: "4_hair_top"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.hairColor)
                        Image(uiImage:#imageLiteral(resourceName: "3_woman_shirt"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.shirtColor)
                        Image(uiImage: #imageLiteral(resourceName: "2_woman_jacket"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.femaleJacket)
                        Image(uiImage: #imageLiteral(resourceName: "1_woman_collar"))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(components.collarColor)
                    }
                    
            )
                .clipShape(Circle())
        
    }
}

fileprivate struct MaleAvatar: View, Avatar {
    var gender: Gender = .male
    var radius: CGFloat
    var components: AvatarComponents
    
    
    var body: some View {
            Circle()
                .fill(components.circularBackground)
                .frame(width: radius, height: radius)
                .overlay(
                    ZStack {
                        Image(uiImage:#imageLiteral(resourceName: "7_man_shirt"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.shirtColor)
                        Image(uiImage: #imageLiteral(resourceName: "6_man_tie"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.maleTie)
                        Image(uiImage:#imageLiteral(resourceName: "5_man_collar"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.collarColor)
                        Image(uiImage: #imageLiteral(resourceName: "3_man_face_shadow"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.faceShadow)
                        Image(uiImage:#imageLiteral(resourceName: "2_man_face"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.faceColor)
                        Image(uiImage: #imageLiteral(resourceName: "1_man_hair"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.hairColor)
                    }
                    
            )
                .clipShape(Circle())
        
    }
}

public struct AvatarView: View {
    private var avatar: Avatar
    
    init(gender: Gender, radius: CGFloat) {
        self.avatar = AvatarPictureRandomizer.createAvatar(gender: gender, radius: radius)
    }
    
    init(avatar: Avatar) {
        self.avatar = avatar
    }
    
    mutating func randomizeAvatar() {
        self.avatar = AvatarPictureRandomizer.createAvatar(gender: (avatar.gender == .male ? .female : .male), radius: 120)
    }
    
   
    public var body: some View {
        VStack {
            if avatar.gender == .male {
                avatar as! MaleAvatar
            }else {
                avatar as! FemaleAvatar
            }
        }
    }
}

public struct AvatarMaker {
    static func makeMeAnAvatarPlease(gender: Gender, radius: CGFloat = 100) -> Avatar {
        return AvatarPictureRandomizer.createAvatar(gender: gender, radius: radius)
    }
}

fileprivate struct AvatarComponents {
    var gender: Gender
    var circularBackground: Color
    let faceShadow = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3))
    var faceColor: Color
    var hairColor: Color
    var shirtColor: Color {
        willSet {
            if newValue == circularBackground {
                var colors = AvatarPictureRandomizer.backgroundCircleColors
                colors.removeAll(where: { $0 == newValue })
                circularBackground = colors.randomElement()!
            }
        }
    }
    var collarColor: Color
    
    var maleTie: Color?
    var femaleJacket: Color?
    
    func listComponents(){
        let collection = [String(describing: gender), String(describing: circularBackground), String(describing: faceColor), String(describing: hairColor), String(describing: maleTie), String(describing: collarColor), String(describing: femaleJacket), String(describing: shirtColor)]
        
print("""
Gender: \(collection[0])
Background Color: \(collection[1])
Face Color: \(collection[2])
Hair Color: \(collection[3])
Tie Color: \(collection[4])
Collar Color: \(collection[5])
Female Jacket Color: \(collection[6])
Shirt Color: \(collection[7])

"""
        )
    }
    
    init(hairColor: Color, faceColor: Color, collarColor: Color, maleTie: Color, shirtColor: Color, backgroundColor: Color) {
        self.gender = .male
        self.hairColor = hairColor
        self.faceColor = faceColor
        self.collarColor = collarColor
        self.maleTie = maleTie
        self.shirtColor = shirtColor
        self.circularBackground = backgroundColor
        
    }
    
    init(collarColor: Color, femaleJacket: Color, shirtColor: Color, hairColor: Color, faceColor: Color, backgroundColor: Color) {
        self.gender = .female
        self.collarColor = collarColor
        self.femaleJacket = femaleJacket
        self.shirtColor = shirtColor
        self.hairColor = hairColor
        self.faceColor = faceColor
        self.circularBackground = backgroundColor
        
    }
    
}

fileprivate struct AvatarPictureRandomizer {
    
    static let faceColors: [Color] = [Color(#colorLiteral(red: 0.9764705882, green: 0.9333333333, blue: 0.7215686275, alpha: 1)),Color(#colorLiteral(red: 0.9636437297, green: 0.9242001772, blue: 0.7632328272, alpha: 1)),Color(#colorLiteral(red: 0.9193914533, green: 0.7340729833, blue: 0.4250843525, alpha: 1)), Color(#colorLiteral(red: 0.6588235294, green: 0.537254902, blue: 0.3215686275, alpha: 1)), Color(#colorLiteral(red: 0.3137254902, green: 0.2784313725, blue: 0.2156862745, alpha: 1))]
    static let hairColors: [Color] = [Color(#colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1)), Color(#colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1)), Color(#colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1)), Color(#colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1)),Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),Color(#colorLiteral(red: 0.971729815, green: 0.8831914067, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.5136131644, green: 0.4159292281, blue: 0.2751397491, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5273808837, blue: 0.2115378976, alpha: 1))]
    static let tieColors: [Color] = [Color(#colorLiteral(red: 1, green: 0.391269505, blue: 0.3030915856, alpha: 1)), .black, .blue, .purple, .primary]
    static let collarColor = Color.white
    static let shirtColors: [Color] = [.red, Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), .black, .white, .orange, .purple]
    static let jacketColors: [Color] = [Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)), Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1))]
    static let backgroundCircleColors: [Color] = [.aetniaBlue, .blue, Color(#colorLiteral(red: 0.6679418683, green: 0.9207292199, blue: 0.4711184502, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]
    
    static public func createAvatar(gender: Gender, radius: CGFloat) -> Avatar {
        
        switch gender {
        case .male:
            let components = AvatarComponents(hairColor: hairColors.randomElement()!, faceColor: faceColors.randomElement()!, collarColor: collarColor, maleTie: tieColors.randomElement()!, shirtColor: shirtColors.randomElement()!, backgroundColor: backgroundCircleColors.randomElement()!)
            
            return MaleAvatar(radius: radius, components: components)
        case .female:
            let components = AvatarComponents(collarColor: collarColor, femaleJacket: jacketColors.randomElement()!, shirtColor: shirtColors.randomElement()!, hairColor: hairColors.randomElement()!, faceColor: faceColors.randomElement()!, backgroundColor: backgroundCircleColors.randomElement()!)
            
            return FemaleAvatar(radius: radius, components: components)
        }
    }
    
}
