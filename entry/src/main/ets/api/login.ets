import { Request } from '../common/request'
import rcpRequest from '../common/rcpRequest'
import axiosRequest from '../common/axiosRequest'

/**
 * 获取协议
 * @param data type 5 用户协议 6 隐私政策
 */
export const getByType = async<T>(data?: object) => await axiosRequest.post<T>('/work/workProtocol/getByType', data)

/**
 * 登录
 * @param data username 账号 password 密码 type 1 密码登录 2 短信登录
 * deviceId 设备id smsCode 短信验证码 protocol 协议
 */
export const login = async<T>(data?: object) => await axiosRequest.post<T>('/admin/mobile/login', data)

/**
 * 获取权限
 * @param data clientType 2 app端
 */
export const permissions = async<T>(data?: object) => await axiosRequest.post<T>('/admin/adminUser/permissions', data)

/**
 * 获取座席信息
 * @param data seatId 坐席id
 */
export const getSeatInfo = async<T>(data?: object) => await axiosRequest.post<T>('/work/workSeat/getSeatInfo', data)

/**
 * 获取用户配置
 * @param data configCode 配置key
 */
export const getUserConfigValue =
  async<T>(data?: object) => await axiosRequest.post<T>('/admin/adminUserConfig/getUserConfigValue', data)

/**
 * 修改密码
 * @param data userPhone 手机号 newPassword 新密码
 * notarizePassword 确认密码 code 短信验证码
 */
export const retrievePassword = async<T>(data?: object) => await axiosRequest.post<T>('/admin/retrievePassword', data)

/**
 * 退出登录
 */
export const logout = async<T>(data?: object) => await axiosRequest.get<T>('/admin/logout', data)
