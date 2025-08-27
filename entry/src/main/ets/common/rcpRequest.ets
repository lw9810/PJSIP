import { rcp } from "@kit.RemoteCommunicationKit";

import { AppStorageV2, PersistenceV2, promptAction, router } from '@kit.ArkUI';
import { TOKEN_KEY, BASE_URL, TOKEN_HEADER_KEY, TOKEN_INFO } from '../constants'
import { Result, token_info } from '../models/index'
import { BusinessError } from '@kit.BasicServicesKit';

class ResponseHeaderInterceptor implements rcp.Interceptor {
  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    return next.handle(context);
  }
}

class ResponseInterceptor implements rcp.Interceptor {
  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    try {
      const response = await next.handle(context);
      response['result'] = {}
      if (response.statusCode !== 200) {
        promptAction.showToast({ message: '请求失败' })
        response['result']['msg'] = '请求失败'
      } else {
        const result = response.toJSON() as Result<object | object[] | null>
        console.log(`请求成功：${JSON.stringify(result)}}`)
        console.log(`请求成功response：${JSON.stringify(response)}`)
        if (result.code === 200 || result.code === 1016) { // 1016 微信登录
          response['result'] = result
        } else if ([-2, -4].includes(result.code)) {
          promptAction.showToast({ message: '登录过期，请重新登录' })
          PersistenceV2.remove(TOKEN_INFO) // 删除token
          // new UserSettingClass(getContext()).setUserToken("") // 清空首选项的token
          router.replaceNamedRoute({
            name: 'login'
          })
          response['result']['msg'] = 'token不存在或超时'
        } else if (result.code === 404) {
          promptAction.showToast({ message: '请求地址不正确' })
          response['result']['msg'] = '请求地址不正确'
        } else {
          promptAction.showToast({ message: result.msg })
          response['result']['msg'] = result.msg
        }
      }
      return response
    } catch (error) {
      console.log(`网络请求失败：${JSON.stringify(error)}`)
      promptAction.showToast({ message: error.message })
      return Promise.reject(error)
    }


  }
}

class RcpRequest {
  getSession<T>(headers: rcp.ResponseHeaders = {}): rcp.Session {
    if (!headers['Content-Type']) {
      headers['Content-Type'] = 'application/json'
    }

    const tokenInfo = AppStorageV2.connect(token_info, TOKEN_INFO, () => new token_info()) as token_info
    // 在请求头部携带token
    if (tokenInfo.token) {
      headers[tokenInfo.token_header as string] = tokenInfo.token
    }
    const requestConfiguration: rcp.Configuration = {
      tracing: {
        verbose: true,
      },
      security: {
        remoteValidation: 'skip'
      }
    }
    const interceptors: rcp.Interceptor[] = [
      new ResponseHeaderInterceptor(),
      new ResponseInterceptor()
    ]
    return rcp.createSession({
      headers,
      requestConfiguration,
      interceptors,
      baseAddress: BASE_URL
    })
  }

  async get<T>(url: string, data?: object): Promise<Result<T>> {
    if (data && Object.keys(data).length) {
      url += "?" + Object.keys(data).map(key => {
        if (data[key]) {
          return `${key}=${data[key]}`
        }
        return ""
      }).join('&')
    }
    const session: rcp.Session = this.getSession<T>()
    const response = await session.get(url)
    return response.toJSON() as Result<T>
  }

  async post<T>(url: string, data?: object): Promise<Result<T>> {
    const session: rcp.Session = this.getSession<T>()
    const response = await session.post(url, data)
    console.log(`请求结果：${JSON.stringify(response)}`)
    return response.toJSON() as Result<T>
  }

  async uploadFromFile<T>(url: string, uploadFrom: rcp.UploadFromFile): Promise<Result<T>> {
    const headers: rcp.ResponseHeaders = {
      'Content-Type': 'multipart/form-data'
    }
    const session: rcp.Session = this.getSession<T>(headers)
    const response = await session.uploadFromFile(url, uploadFrom)
    return response.toJSON() as Result<T>
  }

  async delete<T>(url: string): Promise<Result<T>> {
    const session: rcp.Session = this.getSession<T>()
    const response = await session.delete(url)
    return response.toJSON() as Result<T>
  }

  async put<T>(url: string, data?: object): Promise<Result<T>> {
    const session: rcp.Session = this.getSession<T>()
    const response = await session.put(url, data)
    return response.toJSON() as Result<T>
  }
}

export default new RcpRequest();