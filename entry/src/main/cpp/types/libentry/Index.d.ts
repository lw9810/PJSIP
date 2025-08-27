/**
 * 初始化PJSIP
 * @returns 成功返回0，失败返回其他值
 */
export const initPjsip: () => number;

/**
 * 拨打电话
 * @param phoneNumber 目标电话号码，例如：13696594262
 */
export const makeCall: (phoneNumber: string) => void;

/**
 * 修改账号信息
 * @param server 服务器地址和端口，例如：36.158.249.23:5034
 * @param userName 用户名，例如：506397
 * @param pwd 密码，例如：MYaglT1evB43pFN0AN
 * @returns 成功返回0，失败返回其他值
 */
export const modifyAccount: (server: string, userName: string, pwd: string) => number;

/**
 * 接听电话
 */
export const acceptCall: () => void;

/**
 * 挂断电话
 */
export const hangupCall: () => void;

/**
 * 添加来电监听器
 * @param callback 来电回调函数，参数为呼叫方的URI地址
 */
export const addIncomingCallListener: (callback: (from: string) => void) => void;

/**
 * 添加通话状态监听器
 * @param callback 通话状态回调函数，参数为状态码：
 *                 0 - NULL (空闲)
 *                 1 - CALLING (呼叫中)
 *                 2 - INCOMING (来电)
 *                 3 - EARLY (早期媒体)
 *                 4 - CONNECTING (连接中)
 *                 5 - CONFIRMED (通话中)
 *                 6 - DISCONNECTED (已断开)
 */
export const addCallStateListener: (callback: (state: number) => void) => void;

/**
 * 添加注册状态监听器
 * @param callback 注册状态回调函数，参数为状态码和原因
 *                 状态码200表示注册成功
 */
export const addRegStateListener: (callback: (status: number, reason: string) => void) => void;

/**
 * 销毁PJSIP资源
 */
export const destroy: () => void;

