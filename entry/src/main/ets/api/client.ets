import axiosRequest from '../common/axiosRequest'

/**
 * 获取客户列表
 */
export const customerAppList =
  async<T>(data?: object) => await axiosRequest.post<T>('/crm/crmCustomer/app/list', data)
