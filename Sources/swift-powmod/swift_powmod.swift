// The Swift Programming Language
// https://docs.swift.org/swift-book

import lib

public enum PowMod {
    public static func exp(_ basex: [UInt8], _ exponenty: [UInt8], _ modulusn: [UInt8]) -> [UInt8] {
        let xptr = UnsafeMutablePointer<UInt8>.allocate(capacity: basex.count)
        let yptr = UnsafeMutablePointer<UInt8>.allocate(capacity: exponenty.count)
        let nptr = UnsafeMutablePointer<UInt8>.allocate(capacity: modulusn.count)
        let xcount = basex.count
        let ycount = exponenty.count
        let ncount = modulusn.count

        let rbuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: ncount)
        mod_exp(xptr, xcount, yptr, ycount, nptr, ncount, rbuffer, ncount)
        // copy rbuffer to a new array
        let result = Array(UnsafeBufferPointer(start: rbuffer, count: ncount))
        rbuffer.deallocate()
        xptr.deallocate()
        yptr.deallocate()
        nptr.deallocate()
        return result
    }
}