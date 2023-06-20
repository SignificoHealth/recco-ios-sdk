//
//  File.swift
//  
//
//  Created by Adrián R on 20/6/23.
//

import Foundation
import SFEntities

private enum UnitSystem {
    case imperialUS
    case imperialGB
    case metric
}

extension Locale {
    fileprivate func getUnitSystem() -> UnitSystem {
        switch regionCode {
        case "US":
            return .imperialUS
        case "GB", "MM", "LR":
            return .imperialGB
        default:
            return .metric
        }
    }
}

extension Double {
    func feetToCm() -> Double {
        return (self * 12 * 25.4) / 10
    }
    
    func inchesToCm() -> Double {
        return (self * 25.4) / 10
    }
    
    func metersToCm() -> Double {
        return self * 100
    }
    
    func poundsToKg() -> Double {
        return (self * 453.59237) / 1000
    }
    
    func stonesToKg() -> Double {
        return (self * 14 * 453.59237) / 1000
    }
}

func displayAnswer(_ double: Double, format: NumericQuestionFormat) -> (String, String?) {
    switch format {
    case .humanHeight:
        return ("\(double)", "")
    case .humanWeight:
        return ("\(double)", "")
    case .integer:
        return ("\(Int(double))", nil)
    case .decimal:
        return ("\(double)", nil)
    }
}

func formatAnswer(_ first: String, second: String?, format: NumericQuestionFormat) -> Double? {
    switch format {
    case .humanHeight:
        return 0
    case .humanWeight:
        return 0
    case .integer:
        return Double(first)
    case .decimal:
        return Double(first)
    }
}
