//
//  UserAndDocGenerator.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

class DoctorsGenerator {
    
    static func populateDoctors() -> [DoctorModel] {
        return GetDoctorsOfType(PhysicianModel.self) + GetDoctorsOfType(DentistModel.self)
    }
    
//    static func getFakeUser(username: String) -> UserModel {
//        let doctor = PhysicianModel(acceptsHMO: true, firstName: "Nicholas", lastName: "Miller", address: getAddress()!, phoneNumber: getPhoneNumber())
//        let dentist = DentistModel(acceptsHMO: false, firstName: "Jessica", lastName: "Day", address: getAddress()!, phoneNumber: getPhoneNumber())
//        let coverage = CoverageInfo(PCPInsuranceType: .HMO, dentistInsuranceType: .PPO, primaryCarePhysician: doctor, primaryDentist: dentist, memberID: "82-4987529-155", groupNumber: "297831-A")
//        
//        let mf = Gender(rawValue: Int.random(in: 0...1))
//        switch mf {
//        case .female:
//            return UserModel(username: username, coverageInfo: coverage, firstName: "Jennifer", lastName: "Miller", address: getAddress()!, phoneNumber: getPhoneNumber(), profilePicture: nil, avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .female))
//        default:
//            return UserModel(username: username, coverageInfo: coverage, firstName: "Nicholas", lastName: "Miller", address: getAddress()!, phoneNumber: getPhoneNumber(), profilePicture: nil, avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .male))
//        }
//   
//    }
    
    private static func GetDoctorsOfType<T: DoctorModel>(_: T.Type) -> [T] {
        var arry = [T]()
        for _ in 0...50 {
            let name = randomName()
            let firstName = name.firstName
            let lastName = name.lastName
            guard let address = getAddress() else { return [] }
            let acceptsHMO = arc4random_uniform(2) == 0
            print(acceptsHMO)
            arry.append(T(acceptsHMO: acceptsHMO, firstName: firstName, lastName: lastName, address: address, phoneNumber: getPhoneNumber()))
            
        }
        
        print(arry)
        return arry
    }
    
    static func getPhoneNumber() -> PhoneNumber {
        return PhoneNumber(countryCode: 1, areaCode: Int(californiaAreaCodes[Int.random(in: 0..<californiaAreaCodes.count)])!, number: Int.random(in: 2000000...9999999))
    }
    
    static func randomName() -> (firstName: String, lastName: String) {
        let firstNamesNum = firstNames.count
        let lastNamesNum = lastNames.count
        
        let firstName = firstNames[Int(arc4random_uniform(UInt32(firstNamesNum)))]
        let lastName = lastNames[Int(arc4random_uniform(UInt32(lastNamesNum)))]
        
        return (firstName, lastName)
    }
    
    static func getAddress() -> Address? {
        guard let data = zipCodesCAJSON.data(using: .utf8) else { return nil }
        do {
            if let cityZipArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                let number = String(Int(arc4random_uniform(UInt32(99999))))
                let street = streetNames[Int(arc4random_uniform(UInt32(streetNames.count)))]
                let city = cityZipArray[Int.random(in: 0..<cityZipArray.count)]["city"] as? String
                let zip = cityZipArray[Int.random(in: 0..<cityZipArray.count)]["zip"] as? Int
                let state = "CA"
                
                return Address(number: number, street: street, apt: nil, city: city ?? "Santa Barbara", state: state, zip: String(zip ?? 91011), country: "USA")
                
                
            } else {
                print("bad json")
            }
            return nil
        }catch {
            return nil
        }
    }
    
    static let femaleNames = ["Lyssette","Macalah","Machala","Machayla","Machenzie","Mackensey","Mackinzee","Maday","Madchen","Madeley","Madelina","Madellyn","Madiha","Madisan","Madlynn","Madyn","Madysin","Maeci","Maeson","Magdelena","Magdelene","Mahalah","Mahkayla","Mahoganie","Maiana","Maigan","Maijah","Mailynn","Maisen","Maitri","Makaelyn","Makailee","Makalla","Makel","Makenah","Makenize","Makeyla","Makita","Malani","Malashia","Malayzia","Malee","Maleigh","Maley","Mallari","Mallarie","Malley","Mally","Malvika","Manaia","Manali","Mania","Manijah","Mannat","Manyah","Maple","Maraia","Marcayla","Marcelia","Marche","Maredith","Margalit","Margarett","Marianita","Mariapaula","Mariavictoria","Maribell","Maricel","Maricia","Marierose","Mariesa","Marigrace","Marijah","Marilisa","Marinah","Marisah","Marisel","Marjory","Marki","Markiya","Marleah","Nao","Narda","Naria","Nashea","Nashley","Nasrin","Nataiya","Natalieann","Natalina","Natalyia","Natane","Natasja","Natelie","Natilee","Natilie","Natya","Navada","Nayaly","Naysa","Nazifa","Nealie","Nedra","Neelam","Neesha","Nefertari","Nekeisha","Nelissa","Nelli","Neoma","Nermeen","Nery","Nesa","Nethania","Nethra","Neysha","Niambi","Nianna","Nica","Nickeya","Nijay","Nikera","Nikoleta","Niloufar","Ninamarie","Ninti","Nisreen","Nittaya","Niva","Niyla","Niyonna","Nkechi","Noe","Noga","Noheli","Noriah","Nouci","Nubian","Nupur","Nyajah","Nyani","Nyasiah","Nyelle","Nykeah","Nykiah","Nylea","Nyshia","Nysia","Nytasia","Nyteria","Odali","Odett","Odilia","Oluwatoyin","Omaira","Omunique","Ondrea","Onisha","Oonagh","Osheana","Otilia","Paden","Patrisia","Patrycia","Pattie","Paytyn","Pelin","Peter","Petrina","Phenix","Philena","Philicity","Emily","Hannah","Madison","Ashley","Sarah","Alexis","Samantha","Jessica","Elizabeth","Taylor","Lauren","Alyssa","Kayla","Abigail","Brianna","Olivia","Emma","Megan","Grace","Victoria","Rachel","Anna","Sydney","Destiny","Morgan","Jennifer","Jasmine","Haley","Julia","Kaitlyn","Nicole","Amanda","Katherine","Natalie","Hailey","Alexandra","Savannah","Chloe","Rebecca","Stephanie","Maria","Sophia","Mackenzie","Allison","Isabella","Amber","Mary","Danielle","Gabrielle","Jordan","Brooke","Michelle","Sierra","Katelyn","Andrea","Madeline","Sara","Kimberly","Courtney","Erin","Brittany","Vanessa","Jenna","Jacqueline","Caroline","Faith","Makayla","Bailey","Paige","Shelby","Melissa","Kaylee","Christina","Trinity","Mariah","Caitlin","Autumn","Marissa","Breanna","Angela","Catherine","Zoe","Briana","Jada","Laura","Claire","Alexa","Kelsey","Kathryn","Leslie","Alexandria","Sabrina","Mia","Isabel","Molly","Leah","Katie","Gabriella","Cheyenne","Cassandra","Tiffany","Erica","Lindsey","Kylie","Amy","Diana","Cassidy","Mikayla","Ariana","Margaret","Kelly","Miranda","Maya","Melanie","Audrey","Jade","Gabriela","Caitlyn","Angel","Jillian","Alicia","Jocelyn","Erika","Lily","Heather","Madelyn","Adriana","Arianna","Lillian","Kiara","Riley","Crystal","Mckenzie","Meghan","Skylar","Ana","Britney","Angelica","Kennedy","Chelsea","Daisy","Kristen","Veronica","Isabelle","Summer","Hope","Brittney","Lydia","Hayley","Evelyn","Bethany","Shannon","Michaela","Karen","Jamie","Daniela","Angelina","Kaitlin","Karina","Sophie","Sofia","Diamond","Payton","Cynthia","Alexia","Valerie","Monica","Peyton","Carly","Bianca","Hanna","Brenda","Rebekah","Alejandra","Mya","Avery","Brooklyn","Ashlyn","Lindsay","Ava","Desiree","Alondra","Camryn","Ariel","Naomi","Jordyn","Kendra","Mckenna","Holly","Julie","Kendall","Kara","Jasmin","Selena","Esmeralda","Amaya","Kylee","Maggie","Makenzie","Claudia","Kyra","Cameron","Karla","Kathleen","Abby","Delaney","Amelia","Casey","Serena","Savanna","Aaliyah","Giselle","Mallory","April","Raven","Adrianna","Christine","Kristina","Nina","Asia","Natalia","Valeria","Aubrey","Lauryn","Kate","Patricia","Jazmin","Rachael","Katelynn","Cierra","Alison","Macy","Nancy","Elena","Kyla","Katrina","Jazmine","Joanna","Tara","Gianna","Juliana","Fatima","Allyson","Gracie","Sadie","Guadalupe","Genesis","Yesenia","Julianna","Skyler","Tatiana","Alexus","Alana","Elise","Kirsten","Nadia","Sandra","Dominique","Ruby","Haylee","Jayla","Tori","Cindy","Sidney","Ella","Tessa","Carolina","Camille","Jaqueline","Whitney","Carmen","Vivian","Priscilla","Bridget","Celeste","Kiana","Makenna","Alissa","Madeleine","Miriam","Natasha","Ciara","Cecilia","Mercedes","Kassandra","Reagan","Aliyah","Josephine","Charlotte","Rylee","Shania","Kira","Meredith","Eva","Lisa","Dakota","Hallie","Anne","Rose","Liliana","Kristin","Deanna","Imani","Marisa","Kailey","Annie","Nia","Carolyn","Anastasia","Brenna","Dana","Shayla","Ashlee","Kassidy","Alaina","Rosa","Wendy","Logan","Tabitha","Paola","Callie","Addison","Lucy","Gillian","Clarissa","Destinee","Josie","Esther","Denise","Katlyn","Mariana","Bryanna","Emilee","Georgia","Deja","Kamryn","Ashleigh","Cristina","Baylee","Heaven","Ruth","Raquel","Monique","Teresa","Helen","Krystal","Tiana","Cassie","Kayleigh","Marina","Heidi","Ivy","Ashton","Clara","Meagan","Gina","Linda","Gloria","Jacquelyn","Ellie","Jenny","Renee","Daniella","Lizbeth","Anahi","Virginia","Gisselle","Kaitlynn","Julissa","Cheyanne","Lacey","Haleigh","Marie","Martha","Eleanor","Kierra","Tiara","Talia","Eliza"]

    static let maleNames =  ["Adam", "Alex", "Aaron", "Anthony", "Ben", "Carl", "Dan", "David", "Edward", "Fred", "Frank", "George", "Hal", "Hank", "Ike", "John", "Jack", "Joe", "Larry", "Monte", "Matthew", "Mark", "Nathan", "Otto", "Paul", "Peter", "Roger", "Roger", "Steve", "Thomas", "Tim", "Ty", "Victor", "Walter","Bran","Brandel","Brandonmichael","Branon","Brashawn","Breanna","Brelin","Brenson","Brentin","Brentt","Bretten","Briam","Briceson","Bridge","Brindon","Briyan","Brodyn","Broedy","Bronsen","Bronte","Bryann","Bryndon","Burley","Burnell","Caidan","Caidin","Caidon","Caidyn","Caison","Caitlin","Calaeb","Caliph","Callaway","Callie","Calvyn","Cambell","Cambron","Camdin","Camerson","Candler","Cannen","Capone","Cardale","Cardel","Careem","Carlan","Carlyle","Carron","Cashton","Cassady","Casyn","Cato","Caydin","Caylan","Caylen","Caymon","Caysey","Cejay","Celio","Celvin","Cephas","Cervantes","Chae","Chaka","Chalon","Chananya","Chanceler","Chane","Chanston","Charan","Charod","Charvis","Chaska","Chass","Chen","Cheney","Chett","Chevis","Chidiebere","Chinonso","Chrishun","Chrisopher","Chrisshawn","Christianjay","Christohper","Christopherjohn","Chucky","Chue","Chukwuebuka","Chukwuka","Chun","Chyler","Cid","Clayborn","Clem","Cleophus","Clete","Coben","Cobra","Colburn","Colon","Conagher","Conar","Concepcion","Conlin","Constantin","Constantinos","Cordarious","Cordelle","Cordin","Corinthians","Corleone","Cortell","Cortlin","Cotter","Cotton","Coulten","Courage","Courvoisier","Cray","Crimson","Cru","Cuinn","Curley","Cydney","Cymon","Czar","Daan","Daaron","Daebreon","Daegen","Daegon","Daejion","Daejohn","Daemeon","Daemion","Daemond","Daeqwon","Dagmawi","Dago","Dainon","Dair","Daison","Daivd","Dakwan","Dakwon","Dalis","Dalynn","Damante","Damariae","Damarko","Damarlo","Damarri","Dametri","Damione","Damiyon","Damyen","Danarius","Dandrea","Danieljr","Dannel","Danquan","Dantonio","Daouda","Daquandre","Dareion","Darelle","Daries","Dariusz","Darnay","Darquis","Darran","Darrias","Darryon","Darryus","Dartavious","Darus","Darvon","Daryle","Daryll","Dasaun","Dashaan","Dashad","Daud","Davae","Davantae","Davarious","Davelle","Davionn","Davionte","Davious","Davius","Davontre","Dayden","Dayjon","Dayn","Dayvonne","Dazhan","Deagan","Deajon","Deamontae","Deanglo","Dearis","Dearon","Deashawn","Deaudre","Deaundray","Decameron","Decorion","Dehaven","Deijon","Deionta","Deiontre","Deiveon","Deivi","Dejahn","Dejoun","Dekevious","Delmonte","Delray","Delron","Delshon","Delwyn","Demarcos","Demareon","Demarr","Demarus","Demas","Demeatrius","Demeterius","Demetreus","Demetrian","Demitrios","Demontra","Demontray","Demontrez","Deondric","Dequawn","Dereke","Derex","Derique","Dermarr","Dermot","Deronte","Derrione","Derryk","Dervon","Desiree","Detavion","Detavious","Detrich","Detron","Dettrick","Devarious","Deveion","Devell","Devione","Devlen","Devn","Devohn","Devontaye","Devontez","Devontrey","Dewain","Dex","Deyshawn","Dezhaun","Dheeraj","Dhilan","Dhiren","Diavian","Dierre","Dilen","Dillinger","Dima","Dimitrie","Dinh","Dionel","Divonte","Dmarion","Dmichael","Dmon","Doc","Doel","Domanique","Domique","Domnic","Donnavon","Donshay","Dontarious","Dontavion","Donterious","Dontrae","Dontrail","Dontravious","Dontrey","Doren","Dquarius","Drason","Drayke","Drekwon","Dshon","Dshun","Duilio","Duquan","Dusan","Dyani","Dyante","Dysean","Dyvion","Eain","Earle","Earon","Edbert","Eddieberto","Edge"]
    static let firstNames = femaleNames + maleNames
    static let lastNames = ["Anderson", "Ashwoon", "Aikin", "Bateman", "Bongard", "Bowers", "Boyd", "Cannon", "Cast", "Deitz", "Dewalt", "Ebner", "Frick", "Hancock", "Haworth", "Hesch", "Hoffman", "Kassing", "Knutson", "Lawless", "Lawicki", "Mccord", "McCormack", "Miller", "Myers", "Nugent", "Ortiz", "Orwig", "Ory", "Paiser", "Pak", "Pettigrew", "Quinn", "Quizoz", "Ramachandran", "Resnick", "Sagar", "Schickowski", "Schiebel", "Sellon", "Severson", "Shaffer", "Solberg", "Soloman", "Sonderling", "Soukup", "Soulis", "Stahl", "Sweeney", "Tandy", "Trebil", "Trusela", "Trussel", "Turco", "Uddin", "Uflan", "Ulrich", "Upson", "Vader", "Vail", "Valente", "Van Zandt", "Vanderpoel", "Ventotla", "Vogal", "Wagle", "Wagner", "Wakefield", "Weinstein", "Weiss", "Woo", "Yang", "Yates", "Yocum", "Zeaser", "Zeller", "Ziegler", "Bauer", "Baxster", "Casal", "Cataldi", "Caswell", "Celedon", "Chambers", "Chapman", "Christensen", "Darnell", "Davidson", "Davis", "DeLorenzo", "Dinkins", "Doran", "Dugelman", "Dugan", "Duffman", "Eastman", "Ferro", "Ferry", "Fletcher", "Fietzer", "Hylan", "Hydinger", "Illingsworth", "Ingram", "Irwin", "Jagtap", "Jenson", "Johnson", "Johnsen", "Jones", "Jurgenson", "Kalleg", "Kaskel", "Keller", "Leisinger", "LePage", "Lewis", "Linde", "Lulloff", "Maki", "Martin", "McGinnis", "Mills", "Moody", "Moore", "Napier", "Nelson", "Norquist", "Nuttle", "Olson", "Ostrander", "Reamer", "Reardon", "Reyes", "Rice", "Ripka", "Roberts", "Rogers", "Root", "Sandstrom", "Sawyer", "Schlicht", "Schmitt", "Schwager", "Schutz", "Schuster", "Tapia", "Thompson", "Tiernan", "Tisler"]
    static let californiaAreaCodes = ["209", "213", "279", "310", "323", "341", "408", "415", "424", "442", "510", "530", "559", "562", "619", "626", "628", "650", "657", "661", "669", "707", "714", "747", "760", "805", "818", "820", "831", "840", "858", "909", "916", "925", "949", "951"]
    static let streetNames = ["Main St.", "California Blvd", "Newport Ave",  "Beach Blvd", "Hollywood Ave","Park Place","Brookhurst St.", "Washington St.", "Martin Luther King Ave","Los Osos St.", "Rimhurst Place", "Doctor's Circle", "Whilmore Way", "State St.", "Business Circle", "Himom Wave"]
    static let zipCodesCAJSON: String = """
[
    {
        "zip": 90001,
        "city": "Los Angeles"
    },
    {
        "zip": 90003,
        "city": "Los Angeles"
    },
    {
        "zip": 90004,
        "city": "Los Angeles"
    },
    {
        "zip": 90006,
        "city": "Los Angeles"
    },
    {
        "zip": 90019,
        "city": "Los Angeles"
    },
    {
        "zip": 90022,
        "city": "Los Angeles"
    },
    {
        "zip": 90026,
        "city": "Los Angeles"
    },
    {
        "zip": 90034,
        "city": "Los Angeles"
    },
    {
        "zip": 90037,
        "city": "Los Angeles"
    },
    {
        "zip": 90042,
        "city": "Los Angeles"
    },
    {
        "zip": 90044,
        "city": "Los Angeles"
    },
    {
        "zip": 90063,
        "city": "Los Angeles"
    },
    {
        "zip": 90066,
        "city": "Los Angeles"
    },
    {
        "zip": 90221,
        "city": "Compton"
    },
    {
        "zip": 90250,
        "city": "Hawthorne"
    },
    {
        "zip": 90255,
        "city": "Huntington Park"
    },
    {
        "zip": 90262,
        "city": "Lynwood"
    },
    {
        "zip": 90280,
        "city": "South Gate"
    },
    {
        "zip": 90631,
        "city": "La Habra"
    },
    {
        "zip": 90640,
        "city": "Montebello"
    },
    {
        "zip": 90660,
        "city": "Pico Rivera"
    },
    {
        "zip": 90703,
        "city": "Cerritos"
    },
    {
        "zip": 90706,
        "city": "Bellflower"
    },
    {
        "zip": 90723,
        "city": "Paramount"
    },
    {
        "zip": 90731,
        "city": "San Pedro"
    },
    {
        "zip": 90744,
        "city": "Wilmington"
    },
    {
        "zip": 90745,
        "city": "Carson"
    },
    {
        "zip": 90805,
        "city": "Long Beach"
    },
    {
        "zip": 90813,
        "city": "Long Beach"
    },
    {
        "zip": 91331,
        "city": "Pacoima"
    },
    {
        "zip": 91335,
        "city": "Reseda"
    },
    {
        "zip": 91342,
        "city": "Sylmar"
    },
    {
        "zip": 91343,
        "city": "North Hills"
    },
    {
        "zip": 91351,
        "city": "Canyon Country"
    },
    {
        "zip": 91402,
        "city": "Panorama City"
    },
    {
        "zip": 91405,
        "city": "Van Nuys"
    },
    {
        "zip": 91406,
        "city": "Van Nuys"
    },
    {
        "zip": 91605,
        "city": "North Hollywood"
    },
    {
        "zip": 91702,
        "city": "Azusa"
    },
    {
        "zip": 91706,
        "city": "Baldwin Park"
    },
    {
        "zip": 91709,
        "city": "Chino Hills"
    },
    {
        "zip": 91710,
        "city": "Chino"
    },
    {
        "zip": 91730,
        "city": "Rancho Cucamonga"
    },
    {
        "zip": 91732,
        "city": "El Monte"
    },
    {
        "zip": 91744,
        "city": "La Puente"
    },
    {
        "zip": 91745,
        "city": "Hacienda Heights"
    },
    {
        "zip": 91761,
        "city": "Ontario"
    },
    {
        "zip": 91762,
        "city": "Ontario"
    },
    {
        "zip": 91766,
        "city": "Pomona"
    },
    {
        "zip": 91770,
        "city": "Rosemead"
    },
    {
        "zip": 91801,
        "city": "Alhambra"
    },
    {
        "zip": 91910,
        "city": "Chula Vista"
    },
    {
        "zip": 91911,
        "city": "Chula Vista"
    },
    {
        "zip": 91950,
        "city": "National City"
    },
    {
        "zip": 91977,
        "city": "Spring Valley"
    },
    {
        "zip": 92020,
        "city": "El Cajon"
    },
    {
        "zip": 92021,
        "city": "El Cajon"
    },
    {
        "zip": 92054,
        "city": "Oceanside"
    },
    {
        "zip": 92056,
        "city": "Oceanside"
    },
    {
        "zip": 92069,
        "city": "San Marcos"
    },
    {
        "zip": 92071,
        "city": "Santee"
    },
    {
        "zip": 92083,
        "city": "Vista"
    },
    {
        "zip": 92105,
        "city": "San Diego"
    },
    {
        "zip": 92114,
        "city": "San Diego"
    },
    {
        "zip": 92115,
        "city": "San Diego"
    },
    {
        "zip": 92117,
        "city": "San Diego"
    },
    {
        "zip": 92126,
        "city": "San Diego"
    },
    {
        "zip": 92154,
        "city": "San Diego"
    },
    {
        "zip": 92201,
        "city": "Indio"
    },
    {
        "zip": 92324,
        "city": "Colton"
    },
    {
        "zip": 92335,
        "city": "Fontana"
    },
    {
        "zip": 92336,
        "city": "Fontana"
    },
    {
        "zip": 92345,
        "city": "Hesperia"
    },
    {
        "zip": 92376,
        "city": "Rialto"
    },
    {
        "zip": 92392,
        "city": "Victorville"
    },
    {
        "zip": 92404,
        "city": "San Bernardino"
    },
    {
        "zip": 92503,
        "city": "Riverside"
    },
    {
        "zip": 92509,
        "city": "Riverside"
    },
    {
        "zip": 92553,
        "city": "Moreno Valley"
    },
    {
        "zip": 92627,
        "city": "Costa Mesa"
    },
    {
        "zip": 92630,
        "city": "Lake Forest"
    },
    {
        "zip": 92646,
        "city": "Huntington Beach"
    },
    {
        "zip": 92647,
        "city": "Huntington Beach"
    },
    {
        "zip": 92677,
        "city": "Laguna Niguel"
    },
    {
        "zip": 92683,
        "city": "Westminster"
    },
    {
        "zip": 92701,
        "city": "Santa Ana"
    },
    {
        "zip": 92703,
        "city": "Santa Ana"
    },
    {
        "zip": 92704,
        "city": "Santa Ana"
    },
    {
        "zip": 92707,
        "city": "Santa Ana"
    },
    {
        "zip": 92708,
        "city": "Fountain Valley"
    },
    {
        "zip": 92780,
        "city": "Tustin"
    },
    {
        "zip": 92801,
        "city": "Anaheim"
    },
    {
        "zip": 92804,
        "city": "Anaheim"
    },
    {
        "zip": 92805,
        "city": "Anaheim"
    },
    {
        "zip": 92840,
        "city": "Garden Grove"
    },
    {
        "zip": 92882,
        "city": "Corona"
    },
    {
        "zip": 93030,
        "city": "Oxnard"
    },
    {
        "zip": 93033,
        "city": "Oxnard"
    },
    {
        "zip": 93065,
        "city": "Simi Valley"
    },
    {
        "zip": 93230,
        "city": "Hanford"
    },
    {
        "zip": 93257,
        "city": "Porterville"
    },
    {
        "zip": 93274,
        "city": "Tulare"
    },
    {
        "zip": 93306,
        "city": "Bakersfield"
    },
    {
        "zip": 93307,
        "city": "Bakersfield"
    },
    {
        "zip": 93309,
        "city": "Bakersfield"
    },
    {
        "zip": 93436,
        "city": "Lompoc"
    },
    {
        "zip": 93535,
        "city": "Lancaster"
    },
    {
        "zip": 93550,
        "city": "Palmdale"
    },
    {
        "zip": 93722,
        "city": "Fresno"
    },
    {
        "zip": 93727,
        "city": "Fresno"
    },
    {
        "zip": 93905,
        "city": "Salinas"
    },
    {
        "zip": 93906,
        "city": "Salinas"
    },
    {
        "zip": 94015,
        "city": "Daly City"
    },
    {
        "zip": 94080,
        "city": "South San Francisco"
    },
    {
        "zip": 94086,
        "city": "Sunnyvale"
    },
    {
        "zip": 94087,
        "city": "Sunnyvale"
    },
    {
        "zip": 94109,
        "city": "San Francisco"
    },
    {
        "zip": 94110,
        "city": "San Francisco"
    },
    {
        "zip": 94112,
        "city": "San Francisco"
    },
    {
        "zip": 94122,
        "city": "San Francisco"
    },
    {
        "zip": 94501,
        "city": "Alameda"
    },
    {
        "zip": 94509,
        "city": "Antioch"
    },
    {
        "zip": 94533,
        "city": "Fairfield"
    },
    {
        "zip": 94536,
        "city": "Fremont"
    },
    {
        "zip": 94538,
        "city": "Fremont"
    },
    {
        "zip": 94541,
        "city": "Hayward"
    },
    {
        "zip": 94544,
        "city": "Hayward"
    },
    {
        "zip": 94550,
        "city": "Livermore"
    },
    {
        "zip": 94558,
        "city": "Napa"
    },
    {
        "zip": 94565,
        "city": "Pittsburg"
    },
    {
        "zip": 94587,
        "city": "Union City"
    },
    {
        "zip": 94591,
        "city": "Vallejo"
    },
    {
        "zip": 94601,
        "city": "Oakland"
    },
    {
        "zip": 94806,
        "city": "San Pablo"
    },
    {
        "zip": 95014,
        "city": "Cupertino"
    },
    {
        "zip": 95035,
        "city": "Milpitas"
    },
    {
        "zip": 95051,
        "city": "Santa Clara"
    },
    {
        "zip": 95076,
        "city": "Watsonville"
    },
    {
        "zip": 95111,
        "city": "San Jose"
    },
    {
        "zip": 95112,
        "city": "San Jose"
    },
    {
        "zip": 95116,
        "city": "San Jose"
    },
    {
        "zip": 95122,
        "city": "San Jose"
    },
    {
        "zip": 95123,
        "city": "San Jose"
    },
    {
        "zip": 95127,
        "city": "San Jose"
    },
    {
        "zip": 95340,
        "city": "Merced"
    },
    {
        "zip": 95350,
        "city": "Modesto"
    },
    {
        "zip": 95376,
        "city": "Tracy"
    },
    {
        "zip": 95608,
        "city": "Carmichael"
    },
    {
        "zip": 95616,
        "city": "Davis"
    },
    {
        "zip": 95630,
        "city": "Folsom"
    },
    {
        "zip": 95687,
        "city": "Vacaville"
    },
    {
        "zip": 95823,
        "city": "Sacramento"
    },
    {
        "zip": 95828,
        "city": "Sacramento"
    }
]
"""
    
}
