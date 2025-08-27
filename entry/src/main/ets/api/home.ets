import axiosRequest from '../common/axiosRequest'

/**
 * 获取未查看通知数
 */
export const selectAppNoReadCount =
  async<T>(data?: object) => await axiosRequest.post<T>('/work/workMessage/selectAppNoReadCount', data)

/**
 * 获取第一条通知数
 */
export const selectNoReadAppNotice =
  async<T>(data?: object) => await axiosRequest.post<T>('/work/workMessage/selectNoReadAppNotice', data)

/**
 * 获取统计数据
 */
export const appCallStatistics =
  async<T>(data?: object) => await axiosRequest.post<T>('/work/report/appCallStatistics', data)

/**
 * 获取任务数据
 */
export const appCallTaskStatistics =
  async<T>(data?: object) => await axiosRequest.post<T>('/work/report/appCallTaskStatistics', data)
