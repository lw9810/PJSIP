// 引入包名
import { http } from '@kit.NetworkKit';
import { AppStorageV2, PersistenceV2, promptAction, router } from '@kit.ArkUI';
import { TOKEN_KEY, BASE_URL, TOKEN_HEADER_KEY, TOKEN_INFO } from '../constants'
import { Result, token_info } from '../models/index'

import('../pages/Login')


// 每一个httpRequest对应一个HTTP请求任务，不可复用

const httpRequest = http.createHttp()


interface header {
  'Content-Type': string;
}

interface config {
  data?: object;
  header?: object | header;
}

async function requestHttp<T>(url: string = "", config: http.HttpRequestOptions): Promise<Result<T>> {
  const data = config.extraData as object
  let urlStr = BASE_URL + url
  const method = config.method
  // 手动拼接
  if (method === http.RequestMethod.GET) {
    if (data && Object.keys(data).length) {
      urlStr += "?" + Object.keys(data).map(key => {
        if (data[key]) {
          return `${key}=${data[key]}`
        }
        return ""
      }).join('&')
    }
    config.extraData = undefined
  }
  if (config.header) {
    if (!config.header['Content-Type']) {
      config.header['Content-Type'] = 'application/json'
    }


    const tokenInfo = AppStorageV2.connect(token_info, TOKEN_INFO, () => new token_info()) as token_info
    // 在请求头部携带token
    if (tokenInfo.token) {
      config.header[tokenInfo.token_header as string] = tokenInfo.token
    }
  } else {
    config.header = {
      'Content-Type': 'application/json',
    }
  }
  try {
    const res = await httpRequest.request(urlStr, config)
    if (res.responseCode !== 200) {
      promptAction.showToast({ message: '请求失败' })
      return Promise.reject(new Error('请求失败'))
    } else {
      console.log(`请求成功：${JSON.stringify(res.result)}`)
      const result = JSON.parse(res.result as string) as Result<T>
      if (result.code === 200 || result.code === 1016) { // 1016 微信登录
        // 执行成功
        return result // 直接返回数据
      } else if ([-2, -4].includes(result.code)) {
        promptAction.showToast({ message: '登录过期，请重新登录' })
        PersistenceV2.remove(TOKEN_INFO) // 删除token
        // new UserSettingClass(getContext()).setUserToken("") // 清空首选项的token
        router.replaceNamedRoute({
          name: 'login'
        })
        return Promise.reject(new Error("token不存在或超时"))
      } else if (result.code === 404) {
        promptAction.showToast({ message: '请求地址不正确' })
        return Promise.reject(new Error('请求地址不正确'))
      } else {
        promptAction.showToast({ message: result.msg })
        return Promise.reject(new Error(result.msg))
      }

    }
  } catch (error) {
    console.log(`网络请求失败：${JSON.stringify(error)}`)
    promptAction.showToast({ message: error.message })
    return Promise.reject(error)
  } finally {
    console.log("网络请求结束")
    httpRequest.destroy(); // 销毁请求
  }
}

// 导出一个类的静态方法
export class Request {
  static async get<T>(url: string, extraData?: object): Promise<Result<T>> {
    return requestHttp<T>(url, { extraData, method: http.RequestMethod.GET })
  }

  static post<T>(url: string, extraData?: object): Promise<Result<T>> {
    return requestHttp<T>(url, { extraData, method: http.RequestMethod.POST })
  }

  static postFile<T>(url: string, multiFormDataList: http.MultiFormData[], extraData?: object): Promise<Result<T>> {
    const header: header = { 'Content-Type': 'multipart/form-data' }
    return requestHttp<T>(url, {
      extraData,
      multiFormDataList,
      header,
      method: http.RequestMethod.POST
    })
  }

  static delete<T>(url: string, extraData?: object): Promise<Result<T>> {
    return requestHttp<T>(url, { extraData, method: http.RequestMethod.DELETE })
  }

  static put<T>(url: string, extraData?: object): Promise<Result<T>> {
    return requestHttp<T>(url, { extraData, method: http.RequestMethod.PUT })
  }
}


