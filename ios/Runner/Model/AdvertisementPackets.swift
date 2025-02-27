//
//  AdvertisimentPacket.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

// AdvertisementPackets.swift


class AdvertisementPacket {
    static let packageTypeActiveTime = 1
    static let packageTypeHistory = 2
    static let packageTypeExtentedHistory = 3
    static let packageTypeMEMS = 4
    
    let deviceId: Int
    let packageType: Int
    let subData: AdvertisementSubData
    
    init(deviceId: Int, packageType: Int, subData: AdvertisementSubData) {
        self.deviceId = deviceId
        self.packageType = packageType
        self.subData = subData
    }
}

// MARK: - Advertisement Sub Data
class AdvertisementSubData {
    func test() {
        print("dd")
    }
}

// MARK: - Active Time Package Data
class ActiveTimePackageData: AdvertisementSubData {
    var lastTemp3: Int //5 min before
    var lastTemp2: Int //3 min before
    var lastTemp1: Int //1 min before
    var currentTemp: Int
    var sequence: Int
    
    init(sequence: Int, currentTemp: Int, lastTemp1: Int, lastTemp2: Int, lastTemp3: Int) {
        self.sequence = sequence
        self.currentTemp = currentTemp
        self.lastTemp1 = lastTemp1
        self.lastTemp2 = lastTemp2
        self.lastTemp3 = lastTemp3
        super.init()
    }
}

// MARK: - History Package Data
class HistoryPackageData: AdvertisementSubData {
    var previousTemp5: Int // 15 - 25 Normal - Extented min before
    var previousTemp4: Int // 12 - 20 Normal - Extented min before
    var previousTemp3: Int // 9 - 15 Normal - Extented min before
    var previousTemp2: Int // 6 - 10 Normal - Extented min before
    var previousTemp1: Int // 3 - 5  Normal - Extented min before
    
    init(previousTemp5: Int, previousTemp4: Int, previousTemp3: Int, previousTemp2: Int, previousTemp1: Int) {
        self.previousTemp5 = previousTemp5
        self.previousTemp4 = previousTemp4
        self.previousTemp3 = previousTemp3
        self.previousTemp2 = previousTemp2
        self.previousTemp1 = previousTemp1
        super.init()
    }
}

// MARK: - Default Package Data
class DefaultPackageData: AdvertisementSubData {
    var currentTemp: Int
    var battery: Int
    
    init(currentTemp: Int, battery: Int) {
        self.currentTemp = currentTemp
        self.battery = battery
        super.init()
    }
}
