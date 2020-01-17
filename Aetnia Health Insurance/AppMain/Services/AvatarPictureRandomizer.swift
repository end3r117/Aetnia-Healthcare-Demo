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
    var id: UUID { get }
    var gender: Gender { get }
    var components: AvatarComponents { get set }
    
}

enum Gender: Int {
    case male, female
}

fileprivate struct FemaleAvatar: View, Avatar {
    
    var id = UUID()
    var gender: Gender = .female
    var diameter: CGFloat
    var components: AvatarComponents
    
    
    var body: some View {
            Circle()
                .fill(components.circularBackground)
                .frame(width: diameter, height: diameter)
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
                            .foregroundColor(components.accessoryColor)
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
    var id = UUID()
    var gender: Gender = .male
    var diameter: CGFloat
    var components: AvatarComponents
    
    
    var body: some View {
            Circle()
                .fill(components.circularBackground)
                .frame(width: diameter, height: diameter)
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
                            .foregroundColor(components.accessoryColor)
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

public struct AvatarView: View, Equatable, Identifiable {
    public static func == (lhs: AvatarView, rhs: AvatarView) -> Bool {
        lhs.avatar.id == rhs.avatar.id
    }
    
    public var id = UUID()
    var avatar: Avatar
    private var diameter: CGFloat
    
    init(gender: Gender, diameter: CGFloat) {
        self.diameter = diameter
        self.avatar = AvatarPictureRandomizer.createAvatar(gender: gender, diameter: diameter)
    }
    
    init(avatar: Avatar) {
        if avatar.gender == .male {
            let av = avatar as! MaleAvatar
            self.diameter = av.diameter
        }else {
            let av = avatar as! FemaleAvatar
            self.diameter = av.diameter
        }
        self.avatar = avatar
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

public enum AvatarMaker {
    static func makeMeAnAvatarPlease(gender: Gender, diameter: CGFloat = 100) -> Avatar {
        return AvatarPictureRandomizer.createAvatar(gender: gender, diameter: diameter)
    }
    
    static func resizeAvatar(_ avatar: Avatar, diameter: CGFloat) -> Avatar {
        switch avatar.gender {
        case .female:
            let av = avatar as! FemaleAvatar
            return FemaleAvatar(diameter: diameter, components: av.components)
        case .male:
            let av = avatar as! MaleAvatar
            return MaleAvatar(diameter: diameter, components: av.components)
        }
    }
    
    static func resizeAvatar(_ avatar: Binding<Avatar>, diameter: CGFloat) -> Avatar {
        switch avatar.wrappedValue.gender {
        case .female:
            let av = avatar.wrappedValue as! FemaleAvatar
            return FemaleAvatar(diameter: diameter, components: av.components)
        default:
            let av = avatar.wrappedValue as! MaleAvatar
            return MaleAvatar(diameter: diameter, components: av.components)
        }
    }
    
    static func resizeAvatar(_ avatar: Binding<Avatar?>, diameter: CGFloat) -> Avatar {
        switch avatar.wrappedValue?.gender {
        case .female:
            let av = avatar.wrappedValue as! FemaleAvatar
            return FemaleAvatar(diameter: diameter, components: av.components)
        default:
            let av = avatar.wrappedValue as! MaleAvatar
            return MaleAvatar(diameter: diameter, components: av.components)
        }
    }
}

struct AvatarComponents {
    
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
    var accessoryColor: Color?

    
    init(gender: Gender, hairColor: Color, faceColor: Color, collarColor: Color, accessoryColor: Color, shirtColor: Color, backgroundColor: Color) {
        self.gender = gender
        self.hairColor = hairColor
        self.faceColor = faceColor
        self.collarColor = collarColor
        self.accessoryColor = accessoryColor
        self.shirtColor = shirtColor
        self.circularBackground = backgroundColor
        
    }
   
}

fileprivate let colorDict: [Color:UIColor] = [
    Color(#colorLiteral(red: 0.9764705882, green: 0.9333333333, blue: 0.7215686275, alpha: 1)) : #colorLiteral(red: 0.9764705882, green: 0.9333333333, blue: 0.7215686275, alpha: 1),
    Color(#colorLiteral(red: 0.9636437297, green: 0.9242001772, blue: 0.7632328272, alpha: 1)) : #colorLiteral(red: 0.9636437297, green: 0.9242001772, blue: 0.7632328272, alpha: 1),
    Color(#colorLiteral(red: 0.9193914533, green: 0.7340729833, blue: 0.4250843525, alpha: 1)) : #colorLiteral(red: 0.9193914533, green: 0.7340729833, blue: 0.4250843525, alpha: 1),
    Color(#colorLiteral(red: 0.6588235294, green: 0.537254902, blue: 0.3215686275, alpha: 1)) : #colorLiteral(red: 0.6588235294, green: 0.537254902, blue: 0.3215686275, alpha: 1),
    Color(#colorLiteral(red: 0.3137254902, green: 0.2784313725, blue: 0.2156862745, alpha: 1)) : #colorLiteral(red: 0.3137254902, green: 0.2784313725, blue: 0.2156862745, alpha: 1),
    
    Color(#colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1)) : #colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1),
    Color(#colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1)) : #colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1),
    Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
    Color(#colorLiteral(red: 0.971729815, green: 0.8831914067, blue: 0, alpha: 1)) : #colorLiteral(red: 0.971729815, green: 0.8831914067, blue: 0, alpha: 1),
    Color(#colorLiteral(red: 0.5136131644, green: 0.4159292281, blue: 0.2751397491, alpha: 1)) : #colorLiteral(red: 0.5136131644, green: 0.4159292281, blue: 0.2751397491, alpha: 1),
    Color(#colorLiteral(red: 1, green: 0.5273808837, blue: 0.2115378976, alpha: 1)) : #colorLiteral(red: 1, green: 0.5273808837, blue: 0.2115378976, alpha: 1),
    
    Color(#colorLiteral(red: 1, green: 0.391269505, blue: 0.3030915856, alpha: 1)) : #colorLiteral(red: 1, green: 0.391269505, blue: 0.3030915856, alpha: 1),
    .black : .black,
    .blue : .blue,
    .purple : .purple,
    
    .white : .white,
    
    .red : .red,
    Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)) : #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
    .orange : .orange,
    
    Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)) : #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1),
    Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)) : #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),
    Color(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)) : #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1),
    
    .aetniaBlue : .aetniaBlue,
    Color(#colorLiteral(red: 0.6679418683, green: 0.9207292199, blue: 0.4711184502, alpha: 1)) : #colorLiteral(red: 0.6679418683, green: 0.9207292199, blue: 0.4711184502, alpha: 1),
    Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)) : #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
    
    //faceShadow
    Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
]

fileprivate enum AvatarPictureRandomizer {
    
    static let faceColors: [Color] = [Color(#colorLiteral(red: 0.9764705882, green: 0.9333333333, blue: 0.7215686275, alpha: 1)),Color(#colorLiteral(red: 0.9636437297, green: 0.9242001772, blue: 0.7632328272, alpha: 1)),Color(#colorLiteral(red: 0.9193914533, green: 0.7340729833, blue: 0.4250843525, alpha: 1)), Color(#colorLiteral(red: 0.6588235294, green: 0.537254902, blue: 0.3215686275, alpha: 1)), Color(#colorLiteral(red: 0.3137254902, green: 0.2784313725, blue: 0.2156862745, alpha: 1))]
    static let hairColors: [Color] = [Color(#colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1)), Color(#colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1)), Color(#colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1)), Color(#colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1)),Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),Color(#colorLiteral(red: 0.971729815, green: 0.8831914067, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.5136131644, green: 0.4159292281, blue: 0.2751397491, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5273808837, blue: 0.2115378976, alpha: 1))]
    static let tieColors: [Color] = [Color(#colorLiteral(red: 1, green: 0.391269505, blue: 0.3030915856, alpha: 1)), .black, .blue, .purple]
    static let collarColor = Color.white
    static let shirtColors: [Color] = [.red, Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), .black, .white, .orange, .purple]
    static let jacketColors: [Color] = [Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)), Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1))]
    static let backgroundCircleColors: [Color] = [.aetniaBlue, .blue, Color(#colorLiteral(red: 0.6679418683, green: 0.9207292199, blue: 0.4711184502, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]
    
    static public func createAvatar(gender: Gender, diameter: CGFloat) -> Avatar {
        
        switch gender {
        case .male:
            let components = AvatarComponents(gender: .male, hairColor: hairColors.randomElement()!, faceColor: faceColors.randomElement()!, collarColor: collarColor, accessoryColor: tieColors.randomElement()!, shirtColor: shirtColors.randomElement()!, backgroundColor: backgroundCircleColors.randomElement()!)
            
            return MaleAvatar(diameter: diameter, components: components)
        case .female:
            let components = AvatarComponents(gender: .female, hairColor: hairColors.randomElement()!, faceColor: faceColors.randomElement()!, collarColor: collarColor, accessoryColor: jacketColors.randomElement()!, shirtColor: shirtColors.randomElement()!, backgroundColor: backgroundCircleColors.randomElement()!)
            
            return FemaleAvatar(diameter: diameter, components: components)
        }
    }
    
}


extension AvatarView {
    
    func getUIImage() -> UIImage {
        let size = CGSize(width: diameter, height: diameter)
        let rect = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size)
        let components = avatar.components
        switch avatar.gender {
        case .male:
            return renderer.image { (context) in
                colorDict[components.circularBackground]!.setFill()
                context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
                
                //shirt
                #imageLiteral(resourceName: "7_man_shirt").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.shirtColor]!).draw(in: rect)
                //tie
                #imageLiteral(resourceName: "6_man_tie").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.accessoryColor!]!).draw(in: rect)
                //collar
                #imageLiteral(resourceName: "5_man_collar").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.collarColor]!).draw(in: rect)
                //face shadow
                #imageLiteral(resourceName: "3_man_face_shadow").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.faceShadow]!).draw(in: rect)
                //face
                #imageLiteral(resourceName: "2_man_face").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.faceColor]!).draw(in: rect)
                //hair
                #imageLiteral(resourceName: "1_man_hair").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.hairColor]!).draw(in: rect)
            }
            case .female:
            return renderer.image { (context) in
                colorDict[components.circularBackground]!.setFill()
                context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
                
                //hair bottom
                #imageLiteral(resourceName: "6_hair_bottom").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.hairColor]!).draw(in: rect)
                //face
                #imageLiteral(resourceName: "5_face").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.faceColor]!).draw(in: rect)
                //face shadow
                #imageLiteral(resourceName: "5_face_shadow").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.faceColor]!).draw(in: rect)
                //hair top
                #imageLiteral(resourceName: "4_hair_top").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.hairColor]!).draw(in: rect)
                //shirt
                #imageLiteral(resourceName: "3_woman_shirt").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.shirtColor]!).draw(in: rect)
                //jacket
                #imageLiteral(resourceName: "2_woman_jacket").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.accessoryColor!]!).draw(in: rect)
                //collar
                #imageLiteral(resourceName: "1_woman_collar").withRenderingMode(.alwaysTemplate).withTintColor(colorDict[components.collarColor]!).draw(in: rect)
            }
        }
        
        
        
        
    }
    
}
