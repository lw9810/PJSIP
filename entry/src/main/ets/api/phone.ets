import axiosRequest from '../common/axiosRequest'

/**
 * 拨打记录
 */
export const appDataReportList =
  async<T>(data?: object) => await axiosRequest.post<T>('/work/appDataReport/callDial', data)
