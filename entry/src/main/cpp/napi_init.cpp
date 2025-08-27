#include "pjsip_call.h"
#include "pjsip_app.h"
#include "napi/native_api.h"
#include <string>
#include <sstream>
#include "log_writer.h"  // 包含日志头文件

// 用于保存服务器信息的全局变量，供拨号时使用
static std::string g_serverHost;

// 全局变量
static pjsip::PjsipApp* pjsipApp_ = nullptr;

// 获取APP实例
static pjsip::PjsipApp* GetPjsipAppInstance() {
    // 如果已经有实例，直接返回
    if (pjsipApp_ != nullptr) {
        return pjsipApp_;
    }
    
    // 创建新实例
    pjsipApp_ = new pjsip::PjsipApp();
    return pjsipApp_;
}

// 初始化PJSIP
static napi_value InitPjsip(napi_env env, napi_callback_info info) {
    pjsip::PjsipApp* app = GetPjsipAppInstance();
    napi_value result;
    
    int ret = app->initPJSIP();
    napi_create_int32(env, ret, &result);
    
    return result;
}

// 拨打电话，只接收电话号码作为参数
static napi_value MakeCall(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    if (argc < 1) {
        napi_throw_error(env, nullptr, "参数不足，需要提供目标号码");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    // 获取目标号码
    char phoneNumber[128] = { 0 };
    size_t len = 0;
    napi_get_value_string_utf8(env, args[0], phoneNumber, sizeof(phoneNumber), &len);
    
    // 使用之前保存的服务器主机构建SIP URI
    if (g_serverHost.empty()) {
        napi_throw_error(env, nullptr, "请先调用modifyAccount设置服务器信息");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    // 构建完整的SIP URI
    std::string destination = "sip:" + std::string(phoneNumber) + "@" + g_serverHost;
    
    pjsip::PjsipApp* app = GetPjsipAppInstance();
    app->makeCall(destination.c_str());
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 修改账号信息，参数简化为服务器地址、用户名和密码
static napi_value ModifyAccount(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    if (argc < 3) {
        napi_throw_error(env, nullptr, "参数不足，需要提供: server, userName, pwd");
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }
    
    // 获取参数
    char serverStr[256] = { 0 };
    char userName[128] = { 0 };
    char pwd[128] = { 0 };
    size_t len = 0;
    
    napi_get_value_string_utf8(env, args[0], serverStr, sizeof(serverStr), &len);
    napi_get_value_string_utf8(env, args[1], userName, sizeof(userName), &len);
    napi_get_value_string_utf8(env, args[2], pwd, sizeof(pwd), &len);
    
    // 解析服务器地址和端口
    std::string server(serverStr);
    std::string host;
    std::string port = "5060"; // 默认SIP端口
    
    // 检查是否包含端口
    size_t colonPos = server.find(":");
    if (colonPos != std::string::npos) {
        host = server.substr(0, colonPos);
        port = server.substr(colonPos + 1);
    } else {
        host = server;
    }
    
    // 保存服务器主机信息，用于拨号
    g_serverHost = host;
    
    // 构建SIP URI
    std::string idUri = "sip:" + std::string(userName) + "@" + host;
    std::string registrarUri = "sip:" + server;
    
    pjsip::PjsipApp* app = GetPjsipAppInstance();
    int ret = app->modifyAccount(idUri.c_str(), registrarUri.c_str(), userName, pwd);
    
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

// 接听电话
static napi_value AcceptCall(napi_env env, napi_callback_info info) {
    pjsip::PjsipApp* app = GetPjsipAppInstance();
    app->acceptCall();
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 挂断电话
static napi_value HangupCall(napi_env env, napi_callback_info info) {
    pjsip::PjsipApp* app = GetPjsipAppInstance();
    app->hangupCall();
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 添加来电监听器
static napi_value AddIncomingCallListener(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
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
    
    pjsip::PjsipApp* app = GetPjsipAppInstance();
    app->SetIncomingCallListener(env, callbackRef);
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 添加通话状态监听器
static napi_value AddCallStateListener(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
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
    
    pjsip::PjsipApp* app = GetPjsipAppInstance();
    
    // 首先尝试为应用程序设置通话状态监听器
    app->SetCallStateListener(env, callbackRef);
    
    // 然后，如果当前有活跃的通话，也为当前通话设置监听器
    if (app->getCurrentCall() != nullptr) {
        app->getCurrentCall()->addCallStateListener(env, callbackRef);
    }
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 添加注册状态监听器
static napi_value AddRegStateListener(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
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
    
    pjsip::PjsipApp* app = GetPjsipAppInstance();
    app->SetRegStateListener(env, callbackRef);
    
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// 销毁资源
static napi_value Destroy(napi_env env, napi_callback_info info) {
    pjsip::PjsipApp* app = GetPjsipAppInstance();
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

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // 直接导出函数，不使用类
    napi_property_descriptor desc[] = {
        { "initPjsip", nullptr, InitPjsip, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "makeCall", nullptr, MakeCall, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "modifyAccount", nullptr, ModifyAccount, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "acceptCall", nullptr, AcceptCall, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "hangupCall", nullptr, HangupCall, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "addIncomingCallListener", nullptr, AddIncomingCallListener, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "addCallStateListener", nullptr, AddCallStateListener, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "addRegStateListener", nullptr, AddRegStateListener, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "destroy", nullptr, Destroy, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
