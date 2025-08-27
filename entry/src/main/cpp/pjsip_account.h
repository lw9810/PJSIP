//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef PJSIP_ACCOUNT_H
#define PJSIP_ACCOUNT_H

#include "pjsip_listener.h"
#include <pjsua2/account.hpp>
#include <pjsua2/types.hpp>
#include <native_window/external_window.h>
#include <pjsua2.hpp>
#include "napi/native_api.h"
#include <mutex>

// 前向声明 Pjsip_Call 类，避免循环依赖
namespace pjsip {
class Pjsip_Call;
}

namespace pjsip {
// 让Pjsip_Account同时继承pj::Account和Pjsip_Listener
class Pjsip_Account : public pj::Account, public Pjsip_Listener {

public:
    Pjsip_Account(pj::AccountConfig config);
    ~Pjsip_Account() override;
    void onRegState(pj::OnRegStateParam &prm) override;
    void onIncomingCall(pj::OnIncomingCallParam &prm) override;
    void onInstantMessage(pj::OnInstantMessageParam &prm) override;
    
    // 实现Pjsip_Listener接口的方法
    void onCallStateChange(int32_t status) override {};
    void onCallMediaEvent(int32_t mid) override {};
    void onRegState(int32_t status, const std::string &reason) override {};
    
    void SetIncomingCallListener(napi_env env, napi_ref callBack);
    void SetCallStateListener(napi_env env, napi_ref callBack);
    void SetRegStateListener(napi_env env, napi_ref callBack);
    
    void setCall(pj::Call *call);
    void acceptCall();
    void hangupCall();
    void makeCall(const std::string& uri, const pj::CallOpParam &prm = pj::CallOpParam());
    
    // 获取当前通话对象
    Pjsip_Call* getCurrentCall();
    
    // 通知状态改变的方法
    void notifyCallState(int state);
    void notifyRegState(int state, const std::string& reason);
    void notifyIncomingCall(const std::string& from);
    
    pj::AccountConfig accountConfig;

private:
    napi_ref incomingCallCallback_;
    napi_ref callStateCallback_;
    napi_ref regStateCallback_;
    napi_env env_;
    pj::Call *currentCall_;
    Pjsip_Listener *listener_;
    std::mutex callMutex_;
    
    // 线程安全函数，用于从非JS线程调用JS回调
    napi_threadsafe_function regTsfn_;
    napi_threadsafe_function callStateTsfn_;
    napi_threadsafe_function incomingCallTsfn_;
};
} // namespace pjsip


#endif // PJSIP_ACCOUNT_H 