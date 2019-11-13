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

enum Gender: Int, Codable {
    case male = 0, female
}

struct Avatar: Codable, View, Equatable, Identifiable {
    static func == (lhs: Avatar, rhs: Avatar) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var gender: Gender
    var diameter: CGFloat
    var components: AvatarComponents

    var body: some View {
        (gender == .male) ? AnyView(Male(diameter: diameter, components: components)) : AnyView(Female(diameter: diameter, components: components))
    }
    
    private struct Female: View {
        var diameter: CGFloat
        var components: AvatarComponents
        
        var body: some View {
        Circle()
            .fill(components.backgroundColor.color())
            .frame(width: diameter, height: diameter)
            .overlay(
                ZStack {
                    Image(uiImage:#imageLiteral(resourceName: "6_hair_bottom"))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(components.hairColor.color())
                    Image(uiImage: #imageLiteral(resourceName: "5_face"))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(components.faceColor.color())
                    Image(uiImage:#imageLiteral(resourceName: "5_face_shadow"))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(components.faceShadow.color())
                    Image(uiImage: #imageLiteral(resourceName: "4_hair_top"))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(components.hairColor.color())
                    Image(uiImage:#imageLiteral(resourceName: "3_woman_shirt"))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(components.shirtColor.color())
                    Image(uiImage: #imageLiteral(resourceName: "2_woman_jacket"))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(components.accessoryColor.color())
                    Image(uiImage: #imageLiteral(resourceName: "1_woman_collar"))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(components.collarColor.color())
                }
        )
            .clipShape(Circle())
        }
    }
    
    private struct Male: View {
        var diameter: CGFloat
        var components: AvatarComponents
        
        var body: some View {
            Circle()
                .fill(components.backgroundColor.color())
                .frame(width: diameter, height: diameter)
                .overlay(
                    ZStack {
                        Image(uiImage:#imageLiteral(resourceName: "7_man_shirt"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.shirtColor.color())
                        Image(uiImage: #imageLiteral(resourceName: "6_man_tie"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.accessoryColor.color())
                        Image(uiImage:#imageLiteral(resourceName: "5_man_collar"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.collarColor.color())
                        Image(uiImage: #imageLiteral(resourceName: "3_man_face_shadow"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.faceShadow.color())
                        Image(uiImage:#imageLiteral(resourceName: "2_man_face"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.faceColor.color())
                        Image(uiImage: #imageLiteral(resourceName: "1_man_hair"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(components.hairColor.color())
                    }

            )
                .clipShape(Circle())
        }
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
        self.avatar = avatar
        self.diameter = avatar.diameter
    }

    public var body: some View {
        VStack {
            avatar
        }
    }
}

public enum AvatarMaker {
    static func makeMeAnAvatarPlease(gender: Gender, diameter: CGFloat = 100) -> Avatar {
        return AvatarPictureRandomizer.createAvatar(gender: gender, diameter: diameter)
    }
    static func resizeAvatar(_ avatar: Avatar, diameter: CGFloat) -> Avatar {
        return Avatar(id: avatar.id, gender: avatar.gender, diameter: diameter, components: avatar.components)
    }
    static func resizeAvatar(_ avatar: Binding<Avatar>, diameter: CGFloat) -> Avatar {
        return Avatar(id: avatar.id.wrappedValue, gender: avatar.wrappedValue.gender, diameter: diameter, components: avatar.wrappedValue.components)
    }
    static func resizeAvatar(_ avatar: Binding<Avatar?>, diameter: CGFloat) -> Avatar {
        return Avatar(id: avatar.wrappedValue!.id, gender: avatar.wrappedValue!.gender, diameter: diameter, components: avatar.wrappedValue!.components)
    }
}

struct AvatarComponents: Codable {
    
    var gender: Gender
    var backgroundColor: AvatarColor
    let faceShadow: AvatarColor
    var faceColor: AvatarColor
    var hairColor: AvatarColor
    var shirtColor: AvatarColor {
        willSet {
            if newValue == backgroundColor {
                var colors = AvatarColor.backgroundColors
                colors.removeAll(where: { $0 == newValue })
                backgroundColor = colors.randomElement()!
            }
        }
    }
    var collarColor: AvatarColor
    var accessoryColor: AvatarColor

    
    init(gender: Gender, hairColor: AvatarColor, faceColor: AvatarColor, collarColor: AvatarColor, accessoryColor: AvatarColor, shirtColor: AvatarColor, backgroundColor: AvatarColor) {
        self.gender = gender
        self.hairColor = hairColor
        self.faceColor = faceColor
        self.faceShadow = .faceShadow00
        self.collarColor = collarColor
        self.accessoryColor = accessoryColor
        self.shirtColor = shirtColor
        self.backgroundColor = backgroundColor
        
    }
   
}

enum AvatarColor: String, Codable {
    
    
    case face00, face01, face02, face03, face04
    case faceShadow00
    case hair00, hair01, hair02, hair03, hair04, hair05, hair06, hair07
    case accessory00, accessory01, accessory02, accessory03
    case collar00
    case shirt00, shirt01, shirt02, shirt03, shirt04, shirt05
    case jacket00, jacket01, jacket02
    case background00, background01, background02
    
    static let faceColors: [AvatarColor] = [.face00, .face01, .face02, .face03, .face04]
    static let faceShadow: [AvatarColor] = [.faceShadow00]
    static let hairColors: [AvatarColor] = [.hair00, .hair01, .hair02, .hair03, .hair04, .hair05, .hair06, .hair07]
    static let accessoryColors: [AvatarColor] = [.accessory00, .accessory01, .accessory02, .accessory03]
    static let collarColors: [AvatarColor] = [.collar00]
    static let shirtColors: [AvatarColor] = [.shirt00, .shirt01, .shirt02, .shirt03, .shirt04, .shirt05]
    static let jacketColors: [AvatarColor] = [.jacket00, .jacket01, .jacket02]
    static let backgroundColors: [AvatarColor] = [.background00, .background01, .background02]
    
    func uiColor() -> UIColor {
        return AvatarColor.colorDict[self]!
    }
    
    func color() -> Color {
        
        return Color(self.uiColor())
    }
    
    static let colorDict: [AvatarColor:UIColor] = [
        .face00 : #colorLiteral(red: 0.9764705882, green: 0.9333333333, blue: 0.7215686275, alpha: 1),
        .face01 : #colorLiteral(red: 0.9636437297, green: 0.9242001772, blue: 0.7632328272, alpha: 1),
        .face02 : #colorLiteral(red: 0.9193914533, green: 0.7340729833, blue: 0.4250843525, alpha: 1),
        .face03 : #colorLiteral(red: 0.6588235294, green: 0.537254902, blue: 0.3215686275, alpha: 1),
        .face04 : #colorLiteral(red: 0.3137254902, green: 0.2784313725, blue: 0.2156862745, alpha: 1),
        
        .faceShadow00 : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3),
        
        .hair00 : #colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1),
        .hair01 : #colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1),
        .hair02 : #colorLiteral(red: 0.143817842, green: 0.2658154964, blue: 0.3445550501, alpha: 1),
        .hair03 : #colorLiteral(red: 0.09355933219, green: 0.1345098317, blue: 0.1636455059, alpha: 1),
        .hair04 : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        .hair05 : #colorLiteral(red: 0.971729815, green: 0.8831914067, blue: 0, alpha: 1),
        .hair06 : #colorLiteral(red: 0.5136131644, green: 0.4159292281, blue: 0.2751397491, alpha: 1),
        .hair07 : #colorLiteral(red: 1, green: 0.5273808837, blue: 0.2115378976, alpha: 1),
        
        .accessory00 : #colorLiteral(red: 1, green: 0.391269505, blue: 0.3030915856, alpha: 1),
        .accessory01 : .black,
        .accessory02 : .blue,
        .accessory03 : .purple,
        
        .collar00 : .white,
        
        .shirt00 : .red,
        .shirt01 : #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
        .shirt02 : .black,
        .shirt03 : .white,
        .shirt04 : .orange,
        .shirt05 : .purple,
        
        .jacket00 : #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1),
        .jacket01 : #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),
        .jacket02 : #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1),
        
        .background00 : .aetniaBlue,
        .background01 : #colorLiteral(red: 0.6679418683, green: 0.9207292199, blue: 0.4711184502, alpha: 1),
        .background02 : #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
    ]
    
}

fileprivate enum AvatarPictureRandomizer {
    
    static public func createAvatar(gender: Gender, diameter: CGFloat) -> Avatar {
        let components = AvatarComponents(gender: gender, hairColor: AvatarColor.hairColors.randomElement()!, faceColor: AvatarColor.faceColors.randomElement()!, collarColor: AvatarColor.collarColors.randomElement()!, accessoryColor: AvatarColor.accessoryColors.randomElement()!, shirtColor: AvatarColor.shirtColors.randomElement()!, backgroundColor: AvatarColor.backgroundColors.randomElement()!)
        return Avatar(id: UUID(), gender: gender, diameter: diameter, components: components)
        
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
                components.backgroundColor.uiColor().setFill()
                context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
                
                //shirt
                #imageLiteral(resourceName: "7_man_shirt").withRenderingMode(.alwaysTemplate).withTintColor(components.shirtColor.uiColor()).draw(in: rect)
                //tie
                #imageLiteral(resourceName: "6_man_tie").withRenderingMode(.alwaysTemplate).withTintColor(components.accessoryColor.uiColor()).draw(in: rect)
                //collar
                #imageLiteral(resourceName: "5_man_collar").withRenderingMode(.alwaysTemplate).withTintColor(components.collarColor.uiColor()).draw(in: rect)
                //face shadow
                #imageLiteral(resourceName: "3_man_face_shadow").withRenderingMode(.alwaysTemplate).withTintColor(components.faceShadow.uiColor()).draw(in: rect)
                //face
                #imageLiteral(resourceName: "2_man_face").withRenderingMode(.alwaysTemplate).withTintColor(components.faceColor.uiColor()).draw(in: rect)
                //hair
                #imageLiteral(resourceName: "1_man_hair").withRenderingMode(.alwaysTemplate).withTintColor(components.hairColor.uiColor()).draw(in: rect)
            }
            case .female:
            return renderer.image { (context) in
                components.backgroundColor.uiColor().setFill()
                context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
                
                //hair bottom
                #imageLiteral(resourceName: "6_hair_bottom").withRenderingMode(.alwaysTemplate).withTintColor(components.hairColor.uiColor()).draw(in: rect)
                //face
                #imageLiteral(resourceName: "5_face").withRenderingMode(.alwaysTemplate).withTintColor(components.faceColor.uiColor()).draw(in: rect)
                //face shadow
                #imageLiteral(resourceName: "5_face_shadow").withRenderingMode(.alwaysTemplate).withTintColor(components.faceColor.uiColor()).draw(in: rect)
                //hair top
                #imageLiteral(resourceName: "4_hair_top").withRenderingMode(.alwaysTemplate).withTintColor(components.hairColor.uiColor()).draw(in: rect)
                //shirt
                #imageLiteral(resourceName: "3_woman_shirt").withRenderingMode(.alwaysTemplate).withTintColor(components.shirtColor.uiColor()).draw(in: rect)
                //jacket
                #imageLiteral(resourceName: "2_woman_jacket").withRenderingMode(.alwaysTemplate).withTintColor(components.accessoryColor.uiColor()).draw(in: rect)
                //collar
                #imageLiteral(resourceName: "1_woman_collar").withRenderingMode(.alwaysTemplate).withTintColor(components.collarColor.uiColor()).draw(in: rect)
            }
        }
        
        
        
        
    }
    
}
