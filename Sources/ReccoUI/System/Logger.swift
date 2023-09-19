enum ReccoError: Error {
    case notInitialized
}

struct Logger {
    let log: (Error) -> Void
}
