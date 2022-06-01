import UIKit


// MARK: Protocols
protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get }
    var parkedTime: Int { get }
}


// MARK: Enums
enum VehicleType {
    case car
    case moto
    case miniBus
    case bus
    
    var fee: Int {
        switch self {
        case .car:
            return 20
        case .moto:
            return 15
        case .miniBus:
            return 25
        case .bus:
            return 30
        }
    }
}

enum AlkeParkingErrors: String, LocalizedError {
    
    case plateNotFound = "Sorry, the plate was not found in AlkeParking"
    case spaceNotAvailable = "Sorry, Alkeparking is full. Come back later"
    case duplicatedVehicle = "Sorry, the vehicle you are trying to park is already in AlkeParking."
    
    var errorDescription: String? {
        self.rawValue
    }
}


// MARK: Structs
struct Parking {
    
    var vehicles: Set<Vehicle> = []
    let maxCapacity: Int
    var statistics: (vehicles: Int, earnings: Int)
    
    mutating func checkInVehicle(_ vehicle: Vehicle, completion: (Result<Bool, AlkeParkingErrors>) -> ()) {
        guard vehicles.count < maxCapacity else {
            return completion(.failure(.spaceNotAvailable))
        }
        
        guard !vehicles.contains(vehicle) else {
            return completion(.failure(.duplicatedVehicle))
        }
        
        if vehicles.insert(vehicle).inserted {
            completion(.success(true))
        }
    }
    
    mutating func checkOutVehicle(plate: String, completion: (Result<Int, AlkeParkingErrors>) -> ()) {
        if let vehicle = vehicles.first(where: { $0.plate == plate }) {
            vehicles.remove(vehicle)
            let fee = calculateFee(type: vehicle.type, parkedTime: vehicle.parkedTime, hasDiscountCard: !(vehicle.discountCard?.isEmpty ?? false))
            addEarning(fee)
            completion(.success(fee))
        } else {
            completion(.failure(.plateNotFound))
        }
    }
    
    func calculateFee(type: VehicleType, parkedTime: Int, hasDiscountCard: Bool) -> Int {
        let startingTime = 120
        if parkedTime <= startingTime {
            if hasDiscountCard {
                let priceWithDiscount = Double(type.fee) * 0.85
                return Int(priceWithDiscount)
            } else {
                return type.fee
            }
        } else {
            let remainingTime = parkedTime - startingTime
            let remainingTimeDividend = ceil(Double(remainingTime) / 15)
            let totalFee = type.fee + Int((remainingTimeDividend * 5))
            if hasDiscountCard {
                let priceWithDiscount = Double((Double(totalFee) * 0.85)).rounded(.up)
                return Int(priceWithDiscount)
            } else {
                return totalFee
            }
        }
    }
    
    mutating func addEarning(_ earning: Int) {
        statistics.vehicles += 1
        statistics.earnings += earning
    }
    
    func listVehicles() {
        print("Listing the plates of cars parked in Alkeparking: ")
        for vehicle in vehicles {
            print(vehicle.plate)
        }
    }
    
    func getEarnings() {
        print("\(statistics.vehicles) vehicles have checked out and have earnings of $\(statistics.earnings)")
    }
    
    init(maxCapacity: Int = 4, statistics: (vehicles: Int, earnings: Int) = (0,0)) {
        self.maxCapacity = maxCapacity
        self.statistics = statistics
    }
    
}

struct Vehicle: Parkable, Hashable {
    
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    let discountCard: String?
    var parkedTime: Int {
        let mins = Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
        print("Minutes in Alkeparking: \(mins)")
        return mins
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

func createCustomDate(stringDate: String) -> Date {
    let parseDate: Date?
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    parseDate = dateFormatter.date(from: stringDate)
    if let parseDate = parseDate {
        return parseDate
    } else {
        return Date()
    }
}

// MARK: Tests
var alkeParking = Parking(maxCapacity: 4)


//Probar AlkeParking con Fecha personalizada (cambiar parametro "checkInTime" Date() por customDate)
let customDate = createCustomDate(stringDate: "2022-05-31T19:02:02+0000")


let car = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let moto = Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: customDate, discountCard: nil)
let miniBus = Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let bus = Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
let car2 = Vehicle(plate: "AA111CO", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003")

var vehiclesToPark: [Vehicle] = []

// Testing checkIn duplicated car.
vehiclesToPark.append(car)
vehiclesToPark.append(car)

vehiclesToPark.append(moto)
vehiclesToPark.append(miniBus)
vehiclesToPark.append(bus)
vehiclesToPark.append(car2)

for vehiculo in vehiclesToPark {
    alkeParking.checkInVehicle(vehiculo) { result in
        switch result {
        case .success(_):
            print("Welcome to AlkeParking!")
        case .failure(let errorMessage):
            print(errorMessage.localizedDescription)
        }
    }
}

alkeParking.checkOutVehicle(plate: moto.plate) { result in
    switch result {
    case .success(let totalFee):
        print("Your fee is $\(totalFee). Come back soon")
    case .failure(let errorMessage):
        print(errorMessage.localizedDescription)
    }
}
// Listing Total earnings
alkeParking.getEarnings()

// Listing Vehicles in AlkeParking
alkeParking.listVehicles()
