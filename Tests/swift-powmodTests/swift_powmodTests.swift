import Testing

@testable import swift_powmod

@Test func example() async throws {
    let x = [UInt8](repeating: 0, count: 32)
    let y = [UInt8](repeating: 0, count: 32)
    let n = [UInt8](repeating: 0, count: 64)
    let r = PowMod.exp(x, y, n)
    #expect(r.count == 64)
}
