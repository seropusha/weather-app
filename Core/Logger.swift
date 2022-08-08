import Foundation

public enum LogLevel: Int {
    
    case verbose, success, warn, fail
    
    func glyph() -> String {
        switch self {
        case .fail: return "💔"
        case .verbose: return "💙"
        case .success: return "💚"
        case .warn: return "💛"
        }
    }
}

public enum Logger {
    
    static let currentLogLevel = LogLevel.verbose
    
    public static func success(_ string: @autoclosure () -> String, file: String = #file, line: Int = #line) {
        log(.success, string, file: file, line: line)
    }
    
    public static func error(_ string: @autoclosure () -> String, file: String = #file, line: Int = #line) {
        log(.fail, string, file: file, line: line)
    }
    
    public static func verbose(_ string: @autoclosure () -> String, file: String = #file, line: Int = #line) {
        log(.verbose, string, file: file, line: line)
    }
    
    public static func warn(_ string: @autoclosure () -> String, file: String = #file, line: Int = #line) {
        log(.warn, string, file: file, line: line)
    }
    
    private static func log(_ level: LogLevel, _ string: () -> String, file: String = #file, line: Int = #line) {
        #if DEBUG
        if currentLogLevel.rawValue > level.rawValue {
            return
        }
        let startIndex = file.range(of: "/", options: .backwards)?.upperBound
        let fileName = file[startIndex!...]
        print(" \(level.glyph()) [\(NSDate())] \(fileName)(\(line)) | \(string())")
        #endif
    }
}

extension Logger {
    
    public static func error(error: Error, file: String = #file, line: Int = #line) {
        self.error("\(error)", file: file, line: line)
    }
    
    public static func warn(_ error: Error, file: String = #file, line: Int = #line) {
        self.warn("\(error)", file: file, line: line)
    }
}
