import { CONFIG } from '../../constants'
import { config } from '../../models'
import { AppStorageV2 } from '@kit.ArkUI'

export const dataHasp = (value: string, type: string): string => {
  const Config = AppStorageV2.connect(config, CONFIG, () => new config()) as config
  if (value) {
    if (type === 'name' && Config?.name) {
      if (value.length == 1) {
        return value
      } else if (value.length == 2) {
        return value.substring(0, 1) + '*'
      } else {
        return value.substring(0, 1) + '*' + value.substring(value.length - 1)
      } //企业名称
    } else if (type === 'phone' && Config?.phone) {
      return value.substring(0, 3) + '****' + value.substring(value.length - 4)
    } else if (type == 'tenantName') {
      if (value.length == 1) {
        return value
      } else if (value.length < 5) {
        return value.substring(0, 1) +
          '****'
      } else if (value.length < 10) {
        return value.substring(0, 3) + '******'
      } else {
        return value.substring(0, 3) +
          '******' + value.substring(9, value.length)
      }
      //信用社代码
    } else if (type == 'creditCode') {
      return value.substring(0, 4) + '*******' + value.substring(value.length - 4)
    }
    //身份证
    else if (type == 'userCode') {
      return value.substring(0, 6) + '****' + value.substring(value.length - 4)
    } else {
      return value
    }
  } else {
    return '--'
  }
}

export function underscoreToCamelCase(underscoreString: string): string {
  // 捕获__ob_替换成''
  return underscoreString.replace(/(__ob_)/g, (match: string, letter: string): string => {
    console.log(letter)
    return '';
  });
}

export function convertKeysToCamelCase(obj: ESObject | Array<ESObject>): ESObject | Array<ESObject> {
  if (Array.isArray(obj)) {
    return obj.map((item: ESObject): ESObject => {
      return convertKeysToCamelCase(item);
    });
  }

  if (obj && typeof obj === 'object') {
    const newObj: ESObject = {};
    Object.keys(obj).forEach((key: string): void => {
      if (obj.hasOwnProperty(key)) {
        const newKey = underscoreToCamelCase(key);
        newObj[newKey] = convertKeysToCamelCase(obj[key]);
      }
    });
    return newObj;
  } else {
    return obj;
  }
}