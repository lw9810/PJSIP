//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "pjsip_account.h"
#include "napi/native_api.h"
#include <arkui/native_node_napi.h>
#include <pjsua2.hpp>

#ifndef PJSIP_APP_H
#define PJSIP_APP_H

namespace pjsip {
class PjsipApp {
public:
    PjsipApp() = default;
    ~PjsipApp();
    
    // 初始化SIP
    int initPJSIP();
    
    // 修改账号信息
    int modifyAccount(const std::string& idUri, const std::string& registrarUri, 
                      const std::string& userName, const std::string& pwd);
    
    // 设置来电回调
    void SetIncomingCallListener(napi_env env, napi_ref callBack);
    
    // 设置通话状态回调
    void SetCallStateListener(napi_env env, napi_ref callBack);
    
    // 设置注册状态回调
    void SetRegStateListener(napi_env env, napi_ref callBack);
    
    // 接听电话
    void acceptCall();
    
    // 挂断电话
    void hangupCall();
    
    // 拨打电话
    void makeCall(const std::string& uri);
    
    // 获取当前通话对象
    Pjsip_Call* getCurrentCall();
    
    // 销毁资源
    void destroy();
    
    // PJSIP端点实例
    static std::shared_ptr<pj::Endpoint> endpoint;
    static void Export(napi_env env, napi_value exports);

    // 获取注册状态
    bool getRegistrationStatus(int& statusCode, std::string& statusReason);

private:
    bool isInit{false};
    pj::EpConfig epConfig;
    pj::AccountConfig config;
    pj::TransportConfig transportConfig;
    pjsip::Pjsip_Account* account_{nullptr};
};
} // namespace pjsip

#endif // PJSIP_APP_H 