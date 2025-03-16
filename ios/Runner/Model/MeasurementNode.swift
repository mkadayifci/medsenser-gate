
//
//  MeasuremntNode.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

// MeasurementNode.swift

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}

class MeasurementNode {
    let timestamp: Date
    let temperatureValue: Double
    
    // Whether this measurement has been synced to app layer
    var isSyncedWithAppLayer: Bool = false

    init(timestamp: Date, temperatureValue: Double) {
        self.timestamp = timestamp
        self.temperatureValue = temperatureValue
    }
    
    static func convertParcelableTemperature(_ parceleableTemperature: Int) -> Double {
        if parceleableTemperature == 1 {
            return Double.leastNormalMagnitude
        } else if parceleableTemperature == 255 {
            return Double.infinity
        } else {
            let temperature = (Double(parceleableTemperature) * 0.1) + 24.6

            return temperature.rounded(toPlaces: 1)
        }
    }
}



