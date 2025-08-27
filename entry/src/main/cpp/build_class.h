//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "napi/native_api.h"
#include <arkui/native_node_napi.h>

#ifndef BUILD_CLASS_H
#define BUILD_CLASS_H

class BuildClass {
public:
    static napi_value Export(napi_env env, napi_value exports);
    static napi_value JsConstructor(napi_env env, napi_callback_info info);
    
    // 初始化PJSIP
    static napi_value InitPjsip(napi_env env, napi_callback_info info);
    
    // 拨打电话
    static napi_value MakeCall(napi_env env, napi_callback_info info);
    
    // 修改账号信息
    static napi_value ModifyAccount(napi_env env, napi_callback_info info);
    
    // 接听电话
    static napi_value AcceptCall(napi_env env, napi_callback_info info);
    
    // 挂断电话
    static napi_value HangupCall(napi_env env, napi_callback_info info);
    
    // 添加来电监听器
    static napi_value AddIncomingCallListener(napi_env env, napi_callback_info info);
    
    // 添加通话状态监听器
    static napi_value AddCallStateListener(napi_env env, napi_callback_info info);
    
    // 添加注册状态监听器
    static napi_value AddRegStateListener(napi_env env, napi_callback_info info);
    
    // 销毁资源
    static napi_value Destroy(napi_env env, napi_callback_info info);
};

#endif // BUILD_CLASS_H 