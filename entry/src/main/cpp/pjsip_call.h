//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef PJSIP_CALL_H
#define PJSIP_CALL_H

#include "pjsip_listener.h"
#include <native_window/external_window.h>
#include <pjsua2.hpp>
#include "napi/native_api.h"

namespace pjsip {
class Pjsip_Call : public pj::Call {
public:
    // 重载构造函数，支持不指定call_id的情况
    Pjsip_Call(pj::Account &acc);
    // 原有构造函数
    Pjsip_Call(pj::Account &acc, int call_id);
    ~Pjsip_Call() override;
    void onCallState(pj::OnCallStateParam &prm) override;
    void onCallMediaState(pj::OnCallMediaStateParam &prm) override;
    void onCallTransferStatus(pj::OnCallTransferStatusParam &prm) override;
    void onCallReplaced(pj::OnCallReplacedParam &prm) override;
    void onCallMediaEvent(pj::OnCallMediaEventParam &prm) override;
    void onCallSdpCreated(pj::OnCallSdpCreatedParam &prm) override;

    void makeCall(const std::string &dst_uri, const pj::CallOpParam &prm = pj::CallOpParam());
    void attachListener(Pjsip_Listener *listener);
    
    // 添加通话状态监听器，提供给JavaScript层的回调
    void addCallStateListener(napi_env env, napi_ref callback);

private:
    Pjsip_Listener *listener_;
    pj::Account *account_;  // 存储账户引用
};
} // namespace pjsip

#endif // PJSIP_CALL_H 