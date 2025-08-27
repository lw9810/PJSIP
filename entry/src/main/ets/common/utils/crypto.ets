import { CryptoJS } from '@ohos/crypto-js'

// 使用any类型避免类型不匹配的问题
const key = CryptoJS.enc.Utf8.parse('ql44umx62pehilbu')

export const crypto = (word: string | number): string => {
  if (!word) {
    return ''
  } else {
    // 将word转换为string类型
    const wordStr = String(word);
    // 使用any类型避免类型不匹配的问题
    let encryptedHexStr = CryptoJS.enc.Hex.parse(wordStr);
    let secs = CryptoJS.enc.Base64.stringify(encryptedHexStr);
    let decrypt = CryptoJS.AES.decrypt(secs, key, {
      mode: CryptoJS.mode.ECB,
      padding: CryptoJS.pad.Pkcs7
    });
    let decryptedStr = decrypt.toString();
    return decryptedStr
  }
}
