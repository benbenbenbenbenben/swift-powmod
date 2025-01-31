import BigInt
import Foundation
import Testing

@testable import swift_powmod

@Test func example() async throws {
    // n
    let publicKeyHex =
        "B622B5DDF2FC003E0E3771DB409B658CFD5E1C5BFB6A40E10D10EB925F69DACDF1D1468F4507B75C106A3C20D296DB029AE5010EB91B3CF9093FE9B24F8532920521E18BEB615EDEB568A0061C095EA062587580DF0725E266E7FE1BE7493E027EE9A816A24791EE196806FACD74E397579BDBDECA13465F523F0F8A714F4B8F33C6F7846E7CBEDD6334335DE08C0B9EBAAC85A0DB5D7CC170D28FC5F6BA82FBC893ECCA85622B0D6B5C3A79834595A726DB6B1783FF8F3DB19ACFE10F83B5E6218B9AE748E4A5ED8BC1F2F0FAAEDE87"
    // y
    let privateKeyHex =
        "1E5B1E4FA87F555FAD093DA48AC490ECD4E504B9FF3C6025822D7C98653C4F2252F8366D362BF3E4AD670A05786E79D5C47B802D1ED9DF7ED6DFFC486296331856305041FC903A7A7391700104AC3A70106413957A8130FB1126AA59FBE18A55BFD19C03C5B698521153E68C90A3A9E19B3948F165FFE9B69EDB8DAE0FF6CAFD780770CB52341913CE8021620BA32BB8661BDFE30FBCF99FCDE669268732A19FA2153AB964EE5030FF88B06136F42448CB7F8DB996FBF12995587B4A747384E551AB94D45E16C41757BD83C44F8A13F7"
    // x
    let dataToSign =
        "6A045413339000001513FFFF12490000020101D001B622B5DDF2FC003E0E3771DB409B658CFD5E1C5BFB6A40E10D10EB925F69DACDF1D1468F4507B75C106A3C20D296DB029AE5010EB91B3CF9093FE9B24F8532920521E18BEB615EDEB568A0061C095EA062587580DF0725E266E7FE1BE7493E027EE9A816A24791EE196806FACD74E397579BDBDECA13465F523F0F8A714F4B8F33C6F7846E7CBEDD6334335DE08C0B9EBAAC85A0DB5D7CC170D28FC5F6BA82FBC893ECCA85622B0D6B5C3A79834595A726DB6B1783FF8F3DB19ACFE10F83B5E6218B9AE748E4B6BF364742272251170C3C11EF28FA507D2DEA01BC"

    let x = dataToSign.hexaToBytes()
    let y = privateKeyHex.hexaToBytes()
    let n = publicKeyHex.hexaToBytes()
    let r = PowMod.exp(x, y, n)
    let t = PowMod.exp(x, y, n)
    let p = PowMod.exp(x, y, n)
    let o = PowMod.exp(x, y, n)
    #expect(r.count == privateKeyHex.count / 2)
    #expect(t.count == privateKeyHex.count / 2)
    #expect(p.count == privateKeyHex.count / 2)
    #expect(o.count == privateKeyHex.count / 2)
}

@Test func versusBigInt() async throws {

    // n
    let publicKeyHex =
        "B622B5DDF2FC003E0E3771DB409B658CFD5E1C5BFB6A40E10D10EB925F69DACDF1D1468F4507B75C106A3C20D296DB029AE5010EB91B3CF9093FE9B24F8532920521E18BEB615EDEB568A0061C095EA062587580DF0725E266E7FE1BE7493E027EE9A816A24791EE196806FACD74E397579BDBDECA13465F523F0F8A714F4B8F33C6F7846E7CBEDD6334335DE08C0B9EBAAC85A0DB5D7CC170D28FC5F6BA82FBC893ECCA85622B0D6B5C3A79834595A726DB6B1783FF8F3DB19ACFE10F83B5E6218B9AE748E4A5ED8BC1F2F0FAAEDE87"
    // y
    let privateKeyHex =
        "1E5B1E4FA87F555FAD093DA48AC490ECD4E504B9FF3C6025822D7C98653C4F2252F8366D362BF3E4AD670A05786E79D5C47B802D1ED9DF7ED6DFFC486296331856305041FC903A7A7391700104AC3A70106413957A8130FB1126AA59FBE18A55BFD19C03C5B698521153E68C90A3A9E19B3948F165FFE9B69EDB8DAE0FF6CAFD780770CB52341913CE8021620BA32BB8661BDFE30FBCF99FCDE669268732A19FA2153AB964EE5030FF88B06136F42448CB7F8DB996FBF12995587B4A747384E551AB94D45E16C41757BD83C44F8A13F7"
    // x
    let dataToSign =
        "6A045413339000001513FFFF12490000020101D001B622B5DDF2FC003E0E3771DB409B658CFD5E1C5BFB6A40E10D10EB925F69DACDF1D1468F4507B75C106A3C20D296DB029AE5010EB91B3CF9093FE9B24F8532920521E18BEB615EDEB568A0061C095EA062587580DF0725E266E7FE1BE7493E027EE9A816A24791EE196806FACD74E397579BDBDECA13465F523F0F8A714F4B8F33C6F7846E7CBEDD6334335DE08C0B9EBAAC85A0DB5D7CC170D28FC5F6BA82FBC893ECCA85622B0D6B5C3A79834595A726DB6B1783FF8F3DB19ACFE10F83B5E6218B9AE748E4B6BF364742272251170C3C11EF28FA507D2DEA01BC"

    let x = dataToSign.hexaToBytes()
    let y = privateKeyHex.hexaToBytes()
    let n = publicKeyHex.hexaToBytes()
    let r = PowMod.exp(x, y, n)

    let xBigInt = BigInt(dataToSign, radix: 16)!
    let yBigInt = BigInt(privateKeyHex, radix: 16)!
    let nBigInt = BigInt(publicKeyHex, radix: 16)!
    let rBigInt = xBigInt.power(yBigInt, modulus: nBigInt)

    let rHex = r.map { String(format: "%02x", $0) }.joined()
    let rBigIntHex = String(rBigInt, radix: 16)


    #expect(rBigIntHex.count == rHex.count)
    #expect(rBigIntHex == rHex)
}
