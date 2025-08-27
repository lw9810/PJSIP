import { Request } from '../common/request'
import axiosRequest from '../common/axiosRequest'

/**
 * 获取用户配置
 * @param data configCode 配置key
 */
export const relation_query =
  async<T>(data?: object) => await axiosRequest.post<T>('/admin/adminConfig/tenant/relation/query', data)

/**
 * 获取验证码
 * @param data mobile 账号 type 1001 登录验证码 1005 修改密码验证码
 */
export const sendCode = async<T>(data?: object) => await axiosRequest.post<T>('/admin/sendCode', data)

/**
 * 验证当前用户密码是否符合规范
 */
export const pwdSimplicityVerify =
  async<T>(data?: object) => await axiosRequest.post<T>('/admin/pwdSimplicityVerify', data)

/**
 * 验证当前用户密码是否符合规范
 */
export const updatePassword =
  async<T>(data?: object) => await axiosRequest.post<T>('/admin/adminUser/updatePassword/compel', data)

/**
 * 上传用户设备信息
 */
export const appDeviceModel =
  async<T>(data?: object) => await axiosRequest.post<T>('/work/workAppDeviceModel/appDeviceModel', data)

/**
 * 获取客户列表
 */

export const userList =
  async<T>(data?: object) => await axiosRequest.post<T>('/admin/adminUser/select/list', data)

/**
 * 获取分组标签
 */
export const listAllLabel =
  async<T>(data?: object) => await axiosRequest.post<T>('/crm/label/listAllLabel', data)
