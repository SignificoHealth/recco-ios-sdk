import Foundation
import ReccoHeadless

struct MetricVolume {
    let ml: Int
    
    init(ml: Int) {
        self.ml = ml
    }
    
    var liters: Double {
        Double(ml / 1000)
    }
    
    var imperial: ImperialVolume {
        ImperialVolume(self)
    }
}

struct MetricWeight {
    let grams: Int
    
    init(grams: Int) {
        self.grams = grams
    }
    
    var kg: Double {
        Double(grams) / 1000
    }
    
    var imperial: ImperialWeight {
        ImperialWeight(self)
    }
    
    var display: (String, String?) {
        return (String(kg), nil)
    }
}

struct MetricDistance {
    let cm: Int
    
    init(cm: Int) {
        self.cm = cm
    }

    init(m: Double) {
        self.cm = Int(m * 100)
    }
    
    var m: Double {
        Double(cm / 100)
    }
    
    var km: Double {
        m * 0.001
    }
    
    var imperial: ImperialDistance {
        ImperialDistance(self)
    }
    
    var display: (String, String?) {
        return (String(cm), nil)
    }
}

struct ImperialWeight {
    let metrictWeight: MetricWeight
    
    init(_ metric: MetricWeight) {
        self.metrictWeight = metric
    }
    
    init(lbs: Double) {
        self.metrictWeight = .init(grams: Int(lbs.lbsToGrams))
    }
    
    init(stones: Double) {
        self.metrictWeight = .init(grams: Int(stones * 6350))
    }
    
    var lbs: Double {
        Double(metrictWeight.grams) * 0.002205
    }
    
    var stones: Double {
        Double(metrictWeight.grams) * 0.000157473
    }
    
    var displayUS: (String, String?) {
        return (String(lbs), nil)
    }
    
    var displayGB: (String, String?) {
        return (String(stones), nil)
    }
}

struct ImperialDistance {
    let metricDistance: MetricDistance
    
    init(_ metric: MetricDistance) {
        self.metricDistance = metric
    }
    
    init(miles: Double) {
        self.metricDistance = .init(cm: Int(miles.milesToCm))
    }
    
    init(feet: Double) {
        self.metricDistance = .init(cm: Int(feet.feetToCm))
    }
    
    init(inches: Double) {
        self.metricDistance = .init(cm: Int(inches.inchesToCm))
    }
    
    init(feet: Double, inches: Double) {
        self.metricDistance = .init(cm: Int(inches.inchesToCm) + Int(feet.feetToCm))
    }
    
    var inches: Double {
        Double(metricDistance.cm) * 0.393701
    }
    
    var feet: Double {
        metricDistance.m * 3.28084
    }
    
    var miles: Double {
        metricDistance.km * 0.621371
    }
    
    var feetAndInches: (Int, Int) {
        let roundedInches = inches.rounded(.up)
        return (Int(roundedInches / 12), Int(roundedInches.truncatingRemainder(dividingBy: 12)))
    }
    
    var display: (String, String) {
        return (String(feetAndInches.0), String(feetAndInches.1))
    }
}

struct ImperialVolume {
    let metricVolume: MetricVolume
    
    init(_ metric: MetricVolume) {
        self.metricVolume = metric
    }
    
    init(floz: Double) {
        self.metricVolume = .init(ml: Int(floz.flozToMl))
    }
 
    var floz: Double {
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
