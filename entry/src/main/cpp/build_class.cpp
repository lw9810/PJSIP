//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "build_class.h"
#include "pjsip_app.h"
#include "log_writer.h"

// 类型定义
#define PJSIP_APP_CONSTRUCTOR_NAME "PjsipApp"
#define JS_NULL ((void*)0)

static napi_ref constructor_;
static pjsip::PjsipApp* pjsipApp_ = nullptr;

// 获取APP实例
static pjsip::PjsipApp* GetPjsipAppInstance(napi_env env, napi_callback_info info) {
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &thisVal, nullptr);
    
    // 如果已经有实例，直接返回
    if (pjsipApp_ != nullptr) {
        return pjsipApp_;
    }
    
    // 创建新实例
    pjsipApp_ = new pjsip::PjsipApp();
    return pjsipApp_;
}

// 初始化PJSIP
napi_value BuildClass::InitPjsip(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::InitPjsip called");
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    napi_value result;
    
    int ret = app->initPJSIP();
    napi_create_int32(env, ret, &result);
    
    return result;
}

// 拨打电话
napi_value BuildClass::MakeCall(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::MakeCall called");
    
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value thisVal = nullptr;
    
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    
    if (argc < 1) {
        napi_throw_error(env, nullptr, "参数不足，需要提供目标号码");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    // 获取目标号码
    char destination[256] = { 0 };
    size_t len = 0;
    napi_get_value_string_utf8(env, args[0], destination, sizeof(destination), &len);
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    app->makeCall(destination);
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 修改账号信息
napi_value BuildClass::ModifyAccount(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::ModifyAccount called");
    
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_value thisVal = nullptr;
    
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    
    if (argc < 4) {
        napi_throw_error(env, nullptr, "参数不足，需要提供: idUri, registrarUri, userName, pwd");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    // 获取参数
    char idUri[256] = { 0 };
    char registrarUri[256] = { 0 };
    char userName[128] = { 0 };
    char pwd[128] = { 0 };
    size_t len = 0;
    
    napi_get_value_string_utf8(env, args[0], idUri, sizeof(idUri), &len);
    napi_get_value_string_utf8(env, args[1], registrarUri, sizeof(registrarUri), &len);
    napi_get_value_string_utf8(env, args[2], userName, sizeof(userName), &len);
    napi_get_value_string_utf8(env, args[3], pwd, sizeof(pwd), &len);
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    int ret = app->modifyAccount(idUri, registrarUri, userName, pwd);
    
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

// 接听电话
napi_value BuildClass::AcceptCall(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::AcceptCall called");
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    app->acceptCall();
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 挂断电话
napi_value BuildClass::HangupCall(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::HangupCall called");
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    app->hangupCall();
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 添加来电监听器
napi_value BuildClass::AddIncomingCallListener(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::AddIncomingCallListener called");
    
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value thisVal = nullptr;
    
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    
    if (argc < 1) {
        napi_throw_error(env, nullptr, "参数不足，需要提供回调函数");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    // 获取回调函数并创建引用
    napi_valuetype valueType;
    napi_typeof(env, args[0], &valueType);
    
    if (valueType != napi_function) {
        napi_throw_error(env, nullptr, "参数类型错误，需要提供回调函数");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    napi_ref callbackRef;
    napi_create_reference(env, args[0], 1, &callbackRef);
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    app->SetIncomingCallListener(env, callbackRef);
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 添加通话状态监听器
napi_value BuildClass::AddCallStateListener(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::AddCallStateListener called");
    
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value thisVal = nullptr;
    
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    
    if (argc < 1) {
        napi_throw_error(env, nullptr, "参数不足，需要提供回调函数");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    // 获取回调函数并创建引用
    napi_valuetype valueType;
    napi_typeof(env, args[0], &valueType);
    
    if (valueType != napi_function) {
        napi_throw_error(env, nullptr, "参数类型错误，需要提供回调函数");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    napi_ref callbackRef;
    napi_create_reference(env, args[0], 1, &callbackRef);
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    app->SetCallStateListener(env, callbackRef);
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 添加注册状态监听器
napi_value BuildClass::AddRegStateListener(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::AddRegStateListener called");
    
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value thisVal = nullptr;
    
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    
    if (argc < 1) {
        napi_throw_error(env, nullptr, "参数不足，需要提供回调函数");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    // 获取回调函数并创建引用
    napi_valuetype valueType;
    napi_typeof(env, args[0], &valueType);
    
    if (valueType != napi_function) {
        napi_throw_error(env, nullptr, "参数类型错误，需要提供回调函数");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    napi_ref callbackRef;
    napi_create_reference(env, args[0], 1, &callbackRef);
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    app->SetRegStateListener(env, callbackRef);
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 销毁资源
napi_value BuildClass::Destroy(napi_env env, napi_callback_info info) {
    LOGI("BuildClass::Destroy called");
    
    pjsip::PjsipApp* app = GetPjsipAppInstance(env, info);
    app->destroy();
    
    // 释放实例
    if (pjsipApp_ != nullptr) {
        delete pjsipApp_;
        pjsipApp_ = nullptr;
    }
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// JS构造函数
napi_value BuildClass::JsConstructor(napi_env env, napi_callback_info info) {
    napi_value jsThis = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &jsThis, nullptr);
    
    // 创建一个空对象作为实例
    return jsThis;
}

// 导出类
napi_value BuildClass::Export(napi_env env, napi_value exports) {
    napi_property_descriptor properties[] = {
        { "initPjsip", nullptr, InitPjsip, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "makeCall", nullptr, MakeCall, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "modifyAccount", nullptr, ModifyAccount, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "acceptCall", nullptr, AcceptCall, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "hangupCall", nullptr, HangupCall, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "addIncomingCallListener", nullptr, AddIncomingCallListener, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "addCallStateListener", nullptr, AddCallStateListener, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "addRegStateListener", nullptr, AddRegStateListener, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "destroy", nullptr, Destroy, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    
    napi_value constructor = nullptr;
    
    napi_define_class(env, PJSIP_APP_CONSTRUCTOR_NAME, NAPI_AUTO_LENGTH, JsConstructor, nullptr,
                      sizeof(properties) / sizeof(properties[0]), properties, &constructor);
    
    napi_create_reference(env, constructor, 1, &constructor_);
    
    napi_set_named_property(env, exports, PJSIP_APP_CONSTRUCTOR_NAME, constructor);
    
    return exports;
} 