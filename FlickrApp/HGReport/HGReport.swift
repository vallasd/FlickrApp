// TODO: UPDATE FOR UIKIT
// import UIKit

/// HGReport is used to create generic error messaging throughout the app.  User may turn on or off specific message types.  Used to create uniformity in message reporting.
struct HGReport {
    
    static var shared = HGReport()
    
    var isOn = true
    let hgReportHandlerInfo = true
    let hgReportHandlerWarn = true
    let hgReportHandlerError = true
    let hgReportHandlerAlert = true
    let hgReportHandlerAssert = true
    
    func report(_ msg: String, type: HGErrorType) {
        if !isOn { return }
        switch (type) {
        case .info:    if hgReportHandlerInfo == false { return }
        case .warn:    if hgReportHandlerWarn == false { return }
        case .error:   if hgReportHandlerError == false { return }
        case .alert:   if hgReportHandlerAlert == false { return }
        case .assert:
            if hgReportHandlerAssert == false { return }
            let report = "[\(type.string)] " + msg
            assert(true, report)
        }
        let report = "[\(type.string)] " + msg
        print(report)
    }
    
    func optionalFailed<T>(_ decoder: T, object: Any?, returning: Any?) {
        HGReport.shared.report("|\(decoder)| |OPTIONAL UNWRAP FAILED| object: |\(String(describing: object))|, returning: |\(String(describing: returning))|", type: .error)
    }
    
    func defaultsFailed<T>(_ decoder: T, key: String) {
        HGReport.shared.report("|\(decoder)| |DEFAULTS RETRIEVAL FAILED| invalid key: |\(key)|", type: .error)
    }
    
    func decodeFailed<T>(_ decoder: T, object: Any) {
        HGReport.shared.report("|\(decoder)| |DECODING FAILED| not mapable object: |\(object)|", type: .error)
    }
    
    func setDecodeFailed<T>(_ decoder: T, object: Any) {
        HGReport.shared.report("|\(decoder)| |DECODING FAILED| not inserted object: |\(object)|", type: .error)
    }
    
    func notMatching(_ object: Any, object2: Any) {
        HGReport.shared.report("|\(object)| is does not match |\(object2)|", type: .error)
    }
    
    func insertFailed<T>(set: T, object: Any) {
        HGReport.shared.report("|\(set)| |INSERT FAILED| object: \(object)", type: .error)
    }
    
    func deleteFailed<T>(set: T, object: Any) {
        HGReport.shared.report("|\(set)| |DELETE FAILED| object: \(object)", type: .error)
    }
    
    func getFailed<T>(set: T, keys: [Any], values: [Any]) {
        HGReport.shared.report("|\(set)| |GET FAILED| for keys: |\(keys)| values: |\(values)|", type: .error)
    }
    
    func updateFailed<T>(set: T, key: Any, value: Any) {
        HGReport.shared.report("|\(set)| |UPDATE FAILED| for key: |\(key)| not valid value: |\(value)|", type: .error)
    }
    
    func updateFailedGeneric<T>(set: T) {
        HGReport.shared.report("|\(set)| |UPDATE FAILED| nil object returned, possible stale objects", type: .error)
    }
    
    func usedName<T>(decoder: T, name: String) {
        HGReport.shared.report("|\(decoder)| |USED NAME| name: |\(name)| already used", type: .error)
    }
    
    func validateFailed<T,U>(decoder: T, value: Any, key: Any, expectedType: U) {
        HGReport.shared.report("|\(decoder)| |VALIDATION FAILED| for key: |\(key)| value: |\(value)| expected type: |\(expectedType)|", type: .error)
    }
}


