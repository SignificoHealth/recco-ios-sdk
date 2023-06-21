//
//  File.swift
//  
//
//  Created by Adrián R on 20/6/23.
//

import Foundation
import SFEntities

public struct MetricVolume {
    public let ml: Int
    
    public init(ml: Int) {
        self.ml = ml
    }
    
    public var liters: Double {
        Double(ml / 1000)
    }
    
    public var imperial: ImperialVolume {
        ImperialVolume(self)
    }
}

public struct MetricWeight {
    public let grams: Int
    
    public init(grams: Int) {
        self.grams = grams
    }
    
    public var kg: Double {
        Double(grams) / 1000
    }
    
    public var imperial: ImperialWeight {
        ImperialWeight(self)
    }
    
    public var display: (String, String?) {
        return (String(kg), nil)
    }
}

public struct MetricDistance {
    public let cm: Int
    
    public init(cm: Int) {
        self.cm = cm
    }

    public init(m: Double) {
        self.cm = Int(m * 100)
    }
    
    public var m: Double {
        Double(cm / 100)
    }
    
    public var km: Double {
        m * 0.001
    }
    
    public var imperial: ImperialDistance {
        ImperialDistance(self)
    }
    
    public var display: (String, String?) {
        return (String(cm), nil)
    }
}

public struct ImperialWeight {
    public let metrictWeight: MetricWeight
    
    public init(_ metric: MetricWeight) {
        self.metrictWeight = metric
    }
    
    public init(lbs: Double) {
        self.metrictWeight = .init(grams: Int(lbs.lbsToGrams))
    }
    
    public init(stones: Double) {
        self.metrictWeight = .init(grams: Int(stones * 6350))
    }
    
    public var lbs: Double {
        Double(metrictWeight.grams) * 0.002205
    }
    
    public var stones: Double {
        Double(metrictWeight.grams) * 0.000157473
    }
    
    public var displayUS: (String, String?) {
        return (String(lbs), nil)
    }
    
    public var displayGB: (String, String?) {
        return (String(stones), nil)
    }
}

public struct ImperialDistance {
    public let metricDistance: MetricDistance
    
    public init(_ metric: MetricDistance) {
        self.metricDistance = metric
    }
    
    public init(miles: Double) {
        self.metricDistance = .init(cm: Int(miles.milesToCm))
    }
    
    public init(feet: Double) {
        self.metricDistance = .init(cm: Int(feet.feetToCm))
    }
    
    public init(inches: Double) {
        self.metricDistance = .init(cm: Int(inches.inchesToCm))
    }
    
    public init(feet: Double, inches: Double) {
        self.metricDistance = .init(cm: Int(inches.inchesToCm) + Int(feet.feetToCm))
    }
    
    public var inches: Double {
        Double(metricDistance.cm) * 0.393701
    }
    
    public var feet: Double {
        metricDistance.m * 3.28084
    }
    
    public var miles: Double {
        metricDistance.km * 0.621371
    }
    
    public var feetAndInches: (Int, Int) {
        let roundedInches = inches.rounded(.up)
        return (Int(roundedInches / 12), Int(roundedInches.truncatingRemainder(dividingBy: 12)))
    }
    
    public var display: (String, String) {
        return (String(feetAndInches.0), String(feetAndInches.1))
    }
}

public struct ImperialVolume {
    public let metricVolume: MetricVolume
    
    public init(_ metric: MetricVolume) {
        self.metricVolume = metric
    }
    
    public init(floz: Double) {
        self.metricVolume = .init(ml: Int(floz.flozToMl))
    }
 
    public var floz: Double {
        Double(metricVolume.ml) * 0.033814
    }
}

fileprivate extension Double {
    var flozToMl: Double {
        self * 29.5735
    }
    
    var inchesToCm: Double {
        self * 2.54
    }
    
    var feetToCm: Double {
        self * 30.48
    }
    
    var milesToCm: Double {
        self * 160934
    }
    
    var lbsToGrams: Double {
        self * 453.59237
    }
}


func displayAnswer(_ double: Double, locale: Locale, format: NumericQuestionFormat) -> (String, String?) {
    switch (Locale.current.getUnitSystem(), format) {
    case (.metric, .humanHeight):
        return MetricDistance(cm: Int(double)).display
    case (.imperialGB, .humanHeight), (.imperialUS, .humanHeight):
        return MetricDistance(cm: Int(double)).imperial.display
    case (.metric, .humanWeight):
        return MetricWeight(grams: Int(double * 1000)).display
    case (.imperialGB, .humanWeight):
        return MetricWeight(grams: Int(double * 1000)).imperial.displayGB
    case (.imperialUS, .humanWeight):
        return MetricWeight(grams: Int(double * 1000)).imperial.displayUS
    case (_, .integer):
        return ("\(Int(double))", nil)
    case (_, .decimal):
        return ("\(double)", nil)
    }
}

func formatAnswer(_ first: String, second: String?, format: NumericQuestionFormat, locale: Locale) -> Double? {
    let number1 = first.numberLocalized(locale)?.doubleValue
    let number2 = second?.numberLocalized(locale)?.doubleValue

    guard let number1 else { return nil }
    
    switch (locale.getUnitSystem(), format) {
    case (.metric, .humanHeight):
        return Double(MetricDistance(cm: Int(number1)).cm)
    case (.imperialGB, .humanHeight), (.imperialUS, .humanHeight):
        return Double(ImperialDistance(feet: number1, inches: number2 ?? 0).metricDistance.cm)
    case (.metric, .humanWeight):
        return Double(MetricWeight(grams: Int(number1 * 1000)).kg)
    case (.imperialGB, .humanWeight):
        return Double(ImperialWeight(stones: number1).metrictWeight.kg)
    case (.imperialUS, .humanWeight):
        return Double(ImperialWeight(lbs: number1).metrictWeight.kg)
    case (_, .integer):
        return Double(first)
    case (_, .decimal):
        return Double(first)
    }
}

extension String {
    func numberLocalized(_ locale: Locale) -> NSNumber? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
}
