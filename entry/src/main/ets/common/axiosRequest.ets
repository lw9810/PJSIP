// 引入包名
import axios, {
  AxiosError,
  AxiosInstance,
  AxiosRequestConfig,
  AxiosResponse,
  InternalAxiosRequestConfig
} from "@ohos/axios";
import { AppStorageV2, PersistenceV2, promptAction, router } from '@kit.ArkUI';
import { TOKEN_KEY, BASE_URL, TOKEN_HEADER_KEY, TOKEN_INFO } from '../constants'
import { Result, token_info } from '../models/index'

import('../pages/Login')


const config: AxiosRequestConfig = {
  baseURL: BASE_URL,
  timeout: 60 * 10000,
}

class HttpClient {
  private instance: AxiosInstance;

  constructor(config: AxiosRequestConfig) {
    this.instance = axios.create(config);
    this.interceptors()
  }

  private interceptors() {
    // axios 发送请求之前的处理
    this.instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
      if (!config.headers['Content-Type']) {
        config.headers['Content-Type'] = 'application/json'
      }
      const tokenInfo = AppStorageV2.connect(token_info, TOKEN_INFO, () => new token_info()) as token_info
      // 在请求头部携带token
      if (tokenInfo.token) {
        config.headers[tokenInfo.token_header as string] = tokenInfo.token
      }
      console.log(JSON.stringify(config.headers))
      return config;

    },
      (error: AxiosError) => Promise.reject(error) // 请求报错
    )
    // axios 请求返回之后的处理
    // 请求返回处理
    this.instance.interceptors.response.use((res: AxiosResponse) => {
      console.log('Response', JSON.stringify(res.data));
      if ([200, 1016].includes(res.data.code)) { // 1016 微信登录
        // 执行成功
        return res.data // 直接返回数据
      } else if (res.data.code < 0) {
        promptAction.showToast({ message: '登录过期，请重新登录' })
        PersistenceV2.remove(TOKEN_INFO) // 删除token
        router.replaceNamedRoute({
          name: 'login'
        })
        return Promise.reject(new Error("token不存在或超时"))
      } else if (res.data.code === 404) {
        promptAction.showToast({ message: '请求地址不正确' })
        return Promise.reject(new Error('请求地址不正确'))
      } else {
        promptAction.showToast({ message: res.data.msg })
        return Promise.reject(new Error(res.data.msg))
      }
    }, (error: AxiosError) => {
      console.log('Error', JSON.stringify(error));
      if (error.response) {
        this.handleCode(error.response.status)
      } else if (error.code === "ERR_NETWORK") {
        promptAction.showToast({ message: '无法访问服务器' })
      }
      return Promise.reject(error);
    })
  }

  handleCode(code: number): void {
    switch (code) {
      case 301:
        promptAction.showToast({ message: '请求的资源已被永久的移动到新URI' })
        break;
      case 400:
        promptAction.showToast({ message: '接口正常返回，返回错误提示' })
        break;
      case 401:
        promptAction.showToast({ message: '用户没有权限（令牌、用户名、密码错误、登录超时）' })
        break;
      case 403:
        promptAction.showToast({ message: '用户得到授权，但是访问是被禁止的。' })
        break;
      case 404:
        promptAction.showToast({ message: '网络请求错误,未找到该资源!' })
        break;
      case 405:
        promptAction.showToast({ message: '网络请求错误,请求方法未允许!' })
        break;
      case 408:
        promptAction.showToast({ message: '网络请求超时!' })
        break;
      case 422:
        promptAction.showToast({ message: '接口传入参数错误' })
        break;
      case 500:
        promptAction.showToast({ message: '服务器错误，请联系管理员!' })
        break;
      case 501:
        promptAction.showToast({ message: '网络未实现!' })
        break;
      case 502:
        promptAction.showToast({ message: '网络错误!' })
        break;
      case 503:
        promptAction.showToast({ message: '服务不可用，服务器暂时过载或维护!' })
        break;
      case 504:
        promptAction.showToast({ message: '网络超时!' })
        break;
      case 505:
        promptAction.showToast({ message: 'http版本不支持该请求!' })
        break;
      default:
        promptAction.showToast({ message: '请求失败!' })
        break;
    }
  }

  // GET方法
  get<T>(url: string, params?: object): Promise<Result<T>> {
    return this.instance.get(url, { params });
  }

  // POST方法
  post<T>(url: string, data?: object): Promise<Result<T>> {
    return this.instance.post(url, data);
  }

  // PUT方法
  put<T>(url: string, data?: object): Promise<Result<T>> {
    return this.instance.put(url, data);
  }

  // DELETE方法
  delete<T>(url: string): Promise<Result<T>> {
    return this.instance.delete(url);
  }
}

export default new HttpClient(config);