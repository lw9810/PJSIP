//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "napi/native_api.h"
#include <cstdint>
#include <string>

#ifndef PJSIP_STRUCT_H
#define PJSIP_STRUCT_H

namespace pjsip {

// 通话状态回调参数
struct CallStateCallback {
    napi_env env_;
    napi_ref callbackRef;
    int32_t status;
    std::string statusText;
};

// 注册状态回调参数
struct RegStateCallback {
    napi_env env_;
    napi_ref callbackRef;
    int32_t status;
    std::string reason;
};

// 空参数回调
struct EmptyParamCallback {
    napi_env env_;
    napi_ref callbackRef;
    int32_t code;
};

// 媒体事件结构
struct CallMediaEvent {
    int medIdx;
    void* call;
};

} // namespace pjsip

#endif // PJSIP_STRUCT_H 