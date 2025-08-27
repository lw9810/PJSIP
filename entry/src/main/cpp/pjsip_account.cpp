//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "pjsip_account.h"
#include "pjsip_call.h"
#include "log_writer.h"
#include "pjsip_struct.h"

namespace pjsip {

// 定义用于回调的结构体
struct RegStateCallbackData {
    int state;
    std::string reason;
};

// 定义用于通话状态回调的结构体
struct CallStateCallbackData {
    int state;
};

// 定义用于来电回调的结构体
struct IncomingCallCallbackData {
    std::string from;
};

// 线程安全回调执行函数 - 注册状态
static void CallJsRegStateCallback(napi_env env, napi_value js_callback, void* context, void* data) {
    // 转换数据
    RegStateCallbackData* callbackData = static_cast<RegStateCallbackData*>(data);
    
    // 检查参数
    if (env == nullptr || callbackData == nullptr) {
        // 释放内存
        if (callbackData != nullptr) {
            delete callbackData;
        }
        LOGE("CallJsRegStateCallback: 无效的环境或数据");
        return;
    }
    
    LOGI("CallJsRegStateCallback: 准备调用JS回调，状态=%d, 原因=%s", 
         callbackData->state, callbackData->reason.c_str());
    
    // 创建参数
    napi_value args[2];
    napi_create_int32(env, callbackData->state, &args[0]);
    napi_create_string_utf8(env, callbackData->reason.c_str(), NAPI_AUTO_LENGTH, &args[1]);
    
    // 调用JavaScript回调
    napi_value global;
    napi_get_global(env, &global);
    
    napi_value result;
    napi_status status = napi_call_function(env, global, js_callback, 2, args, &result);
    
    if (status != napi_ok) {
        LOGE("调用注册状态回调失败，错误码: %d", status);
    } else {
        LOGI("注册状态回调成功执行");
    }
    
    // 释放内存
    delete callbackData;
}

// 线程安全回调执行函数 - 通话状态
static void CallJsCallStateCallback(napi_env env, napi_value js_callback, void* context, void* data) {
    // 转换数据
    CallStateCallbackData* callbackData = static_cast<CallStateCallbackData*>(data);
    
    // 检查参数
    if (env == nullptr || callbackData == nullptr) {
        // 释放内存
        if (callbackData != nullptr) {
            delete callbackData;
        }
        LOGE("CallJsCallStateCallback: 无效的环境或数据");
        return;
    }
    
    LOGI("CallJsCallStateCallback: 准备调用JS回调，状态=%d", callbackData->state);
    
    // 创建参数
    napi_value arg;
    napi_create_int32(env, callbackData->state, &arg);
    
    // 调用JavaScript回调
    napi_value global;
    napi_get_global(env, &global);
    
    napi_value result;
    napi_status status = napi_call_function(env, global, js_callback, 1, &arg, &result);
    
    if (status != napi_ok) {
        LOGE("调用通话状态回调失败，错误码: %d", status);
    } else {
        LOGI("通话状态回调成功执行");
    }
    
    // 释放内存
    delete callbackData;
}

// 线程安全回调执行函数 - 来电
static void CallJsIncomingCallCallback(napi_env env, napi_value js_callback, void* context, void* data) {
    // 转换数据
    IncomingCallCallbackData* callbackData = static_cast<IncomingCallCallbackData*>(data);
    
    // 检查参数
    if (env == nullptr || callbackData == nullptr) {
        // 释放内存
        if (callbackData != nullptr) {
            delete callbackData;
        }
        LOGE("CallJsIncomingCallCallback: 无效的环境或数据");
        return;
    }
    
    LOGI("CallJsIncomingCallCallback: 准备调用JS回调，来电号码=%s", callbackData->from.c_str());
    
    // 创建参数
    napi_value arg;
    napi_create_string_utf8(env, callbackData->from.c_str(), NAPI_AUTO_LENGTH, &arg);
    
    // 调用JavaScript回调
    napi_value global;
    napi_get_global(env, &global);
    
    napi_value result;
    napi_status status = napi_call_function(env, global, js_callback, 1, &arg, &result);
    
    if (status != napi_ok) {
        LOGE("调用来电回调失败，错误码: %d", status);
    } else {
        LOGI("来电回调成功执行");
    }
    
    // 释放内存
    delete callbackData;
}

Pjsip_Account::Pjsip_Account(pj::AccountConfig config) 
    : accountConfig(config), currentCall_(nullptr), 
      incomingCallCallback_(nullptr), callStateCallback_(nullptr), regStateCallback_(nullptr),
      regTsfn_(nullptr), callStateTsfn_(nullptr), incomingCallTsfn_(nullptr),
      listener_(nullptr) {
    LOGI("Pjsip_Account created");
    
    // 确保会话定时器设置正确
    if (accountConfig.callConfig.timerMinSESec < 90) {
        LOGW("Pjsip_Account构造函数: 检测到timerMinSESec小于90，自动修正为90");
        accountConfig.callConfig.timerMinSESec = 90;
    }
    
    // 确保会话过期时间合理
    if (accountConfig.callConfig.timerSessExpiresSec < accountConfig.callConfig.timerMinSESec) {
        accountConfig.callConfig.timerSessExpiresSec = accountConfig.callConfig.timerMinSESec * 2;
        LOGI("Pjsip_Account构造函数: 调整会话过期时间为: %{public}d 秒", accountConfig.callConfig.timerSessExpiresSec);
    }
}

Pjsip_Account::~Pjsip_Account() {
    LOGI("Pjsip_Account destroyed");
    if (currentCall_ != nullptr) {
        delete currentCall_;
        currentCall_ = nullptr;
    }
    
    // 释放线程安全函数
    if (regTsfn_ != nullptr) {
        napi_release_threadsafe_function(regTsfn_, napi_tsfn_abort);
        regTsfn_ = nullptr;
    }
    
    if (callStateTsfn_ != nullptr) {
        napi_release_threadsafe_function(callStateTsfn_, napi_tsfn_abort);
        callStateTsfn_ = nullptr;
    }
    
    if (incomingCallTsfn_ != nullptr) {
        napi_release_threadsafe_function(incomingCallTsfn_, napi_tsfn_abort);
        incomingCallTsfn_ = nullptr;
    }
    
    // 释放回调引用
    if (incomingCallCallback_ != nullptr) {
        napi_delete_reference(env_, incomingCallCallback_);
        incomingCallCallback_ = nullptr;
    }
    
    if (callStateCallback_ != nullptr) {
        napi_delete_reference(env_, callStateCallback_);
        callStateCallback_ = nullptr;
    }
    
    if (regStateCallback_ != nullptr) {
        napi_delete_reference(env_, regStateCallback_);
        regStateCallback_ = nullptr;
    }
}

void Pjsip_Account::onRegState(pj::OnRegStateParam &prm) {
    pj::AccountInfo ai = getInfo();
    bool isRegistered = ai.regIsActive;
    int statusCode = prm.code;
    std::string reason = prm.reason;
    
    LOGI("Registration state changed: %{public}d, %{public}s", statusCode, reason.c_str());
    
    // 通知注册状态
    notifyRegState(statusCode, reason);
}

void Pjsip_Account::onIncomingCall(pj::OnIncomingCallParam &prm) {
    LOGI("Incoming call from: %{public}s", prm.rdata.srcAddress.c_str());
    
    // 创建呼叫对象
    if (currentCall_ != nullptr) {
        delete currentCall_;
    }
    
    Pjsip_Call* call = new Pjsip_Call(*this, prm.callId);
    currentCall_ = call;
    
    // 设置自身为listener，因为Pjsip_Account同时也是一个Pjsip_Listener
    listener_ = this;
    call->attachListener(this);
    
    // 通知前端有来电
    notifyIncomingCall(prm.rdata.srcAddress);
    
    // 记录日志
    LOGI("Processed incoming call from: %s", prm.rdata.srcAddress.c_str());
}

void Pjsip_Account::onInstantMessage(pj::OnInstantMessageParam &prm) {
    // 处理即时消息，可根据需要实现
    LOGI("Received IM from %{public}s: %{public}s", prm.fromUri.c_str(), prm.msgBody.c_str());
}

void Pjsip_Account::SetIncomingCallListener(napi_env env, napi_ref callBack) {
    LOGI("SetIncomingCallListener: 开始设置来电监听器");
    
    env_ = env;
    
    // 清理旧的线程安全函数
    if (incomingCallTsfn_ != nullptr) {
        LOGI("SetIncomingCallListener: 清理旧的线程安全函数");
        napi_release_threadsafe_function(incomingCallTsfn_, napi_tsfn_abort);
        incomingCallTsfn_ = nullptr;
    }
    
    // 删除旧的回调引用
    if (incomingCallCallback_ != nullptr) {
        LOGI("SetIncomingCallListener: 删除旧的回调引用");
        napi_delete_reference(env_, incomingCallCallback_);
    }
    
    incomingCallCallback_ = callBack;
    
    // 获取回调函数值
    napi_value callbackFunc;
    napi_status status = napi_get_reference_value(env, callBack, &callbackFunc);
    if (status != napi_ok) {
        LOGE("SetIncomingCallListener: 获取来电回调引用失败，错误码: %d", status);
        return;
    }
    
    LOGI("SetIncomingCallListener: 成功获取回调函数引用");
    
    // 创建线程安全函数
    napi_value resource_name;
    napi_create_string_utf8(env, "IncomingCallCallback", NAPI_AUTO_LENGTH, &resource_name);
    
    status = napi_create_threadsafe_function(
        env,
        callbackFunc,
        nullptr,
        resource_name,
        0,
        1,
        nullptr,
        nullptr,
        nullptr,
        CallJsIncomingCallCallback,
        &incomingCallTsfn_
    );
    
    if (status != napi_ok) {
        LOGE("SetIncomingCallListener: 创建来电线程安全函数失败，错误码: %d", status);
        incomingCallTsfn_ = nullptr;
    } else {
        LOGI("SetIncomingCallListener: 成功创建来电回调的线程安全函数");
    }
}

void Pjsip_Account::SetCallStateListener(napi_env env, napi_ref callBack) {
    LOGI("SetCallStateListener: 开始设置通话状态监听器");
    
    env_ = env;
    
    // 清理旧的线程安全函数
    if (callStateTsfn_ != nullptr) {
        LOGI("SetCallStateListener: 清理旧的线程安全函数");
        napi_release_threadsafe_function(callStateTsfn_, napi_tsfn_abort);
        callStateTsfn_ = nullptr;
    }
    
    // 删除旧的回调引用
    if (callStateCallback_ != nullptr) {
        LOGI("SetCallStateListener: 删除旧的回调引用");
        napi_delete_reference(env_, callStateCallback_);
    }
    
    callStateCallback_ = callBack;
    
    // 获取回调函数值
    napi_value callbackFunc;
    napi_status status = napi_get_reference_value(env, callBack, &callbackFunc);
    if (status != napi_ok) {
        LOGE("SetCallStateListener: 获取通话状态回调引用失败，错误码: %d", status);
        return;
    }
    
    LOGI("SetCallStateListener: 成功获取回调函数引用");
    
    // 创建线程安全函数
    napi_value resource_name;
    napi_create_string_utf8(env, "CallStateCallback", NAPI_AUTO_LENGTH, &resource_name);
    
    status = napi_create_threadsafe_function(
        env,
        callbackFunc,
        nullptr,
        resource_name,
        0,
        1,
        nullptr,
        nullptr,
        nullptr,
        CallJsCallStateCallback,
        &callStateTsfn_
    );
    
    if (status != napi_ok) {
        LOGE("SetCallStateListener: 创建通话状态线程安全函数失败，错误码: %d", status);
        callStateTsfn_ = nullptr;
    } else {
        LOGI("SetCallStateListener: 成功创建通话状态回调的线程安全函数");
    }
}

void Pjsip_Account::SetRegStateListener(napi_env env, napi_ref callBack) {
    LOGI("SetRegStateListener: 开始设置注册状态监听器");
    
    env_ = env;
    
    // 清理旧的线程安全函数
    if (regTsfn_ != nullptr) {
        LOGI("SetRegStateListener: 清理旧的线程安全函数");
        napi_release_threadsafe_function(regTsfn_, napi_tsfn_abort);
        regTsfn_ = nullptr;
    }
    
    // 删除旧的回调引用
    if (regStateCallback_ != nullptr) {
        LOGI("SetRegStateListener: 删除旧的回调引用");
        napi_delete_reference(env_, regStateCallback_);
    }
    
    regStateCallback_ = callBack;
    
    // 获取回调函数值
    napi_value callbackFunc;
    napi_status status = napi_get_reference_value(env, callBack, &callbackFunc);
    if (status != napi_ok) {
        LOGE("SetRegStateListener: 获取注册状态回调引用失败，错误码: %d", status);
        return;
    }
    
    LOGI("SetRegStateListener: 成功获取回调函数引用");
    
    // 创建线程安全函数
    napi_value resource_name;
    napi_create_string_utf8(env, "RegStateCallback", NAPI_AUTO_LENGTH, &resource_name);
    
    status = napi_create_threadsafe_function(
        env,
        callbackFunc,
        nullptr,
        resource_name,
        0,
        1,
        nullptr,
        nullptr,
        nullptr,
        CallJsRegStateCallback,
        &regTsfn_
    );
    
    if (status != napi_ok) {
        LOGE("SetRegStateListener: 创建线程安全函数失败，错误码: %d", status);
        regTsfn_ = nullptr;
    } else {
        LOGI("SetRegStateListener: 成功创建注册状态回调的线程安全函数");
    }
}

void Pjsip_Account::setCall(pj::Call *call) {
    if (currentCall_ != nullptr && currentCall_ != call) {
        delete currentCall_;
    }
    currentCall_ = call;
}

void Pjsip_Account::acceptCall() {
    if (currentCall_) {
        try {
            // 接听电话
            pj::CallOpParam prm;
            prm.statusCode = PJSIP_SC_OK;
            
            currentCall_->answer(prm);
            LOGI("Call accepted");
        } catch (pj::Error &err) {
            LOGE("Error answering call: %{public}s", err.info().c_str());
        }
    } else {
        LOGE("No call to accept");
    }
}

void Pjsip_Account::hangupCall() {
    if (currentCall_) {
        try {
            // 挂断电话
            pj::CallOpParam prm;
            prm.statusCode = PJSIP_SC_DECLINE;
            
            currentCall_->hangup(prm);
            LOGI("Call hangup");
        } catch (pj::Error &err) {
            LOGE("Error hanging up call: %{public}s", err.info().c_str());
        }
    } else {
        LOGE("No call to hangup");
    }
}

void Pjsip_Account::makeCall(const std::string &uri, const pj::CallOpParam &prm) {
    LOGI("Pjsip_Account::makeCall - URI: %{public}s", uri.c_str());
    
    // 先检查参数有效性
    if (uri.empty()) {
        LOGE("Pjsip_Account::makeCall - URI为空，无法拨打");
        return;
    }
    
    // 不要检查账户状态，避免使用getInfo()引起崩溃
    
    try {
        LOGI("尝试创建新的呼叫对象");
        // 创建新的Call对象，使用新的构造函数方式
        Pjsip_Call* newCall = nullptr;
        try {
            // 使用不指定call_id的构造函数，避免assertion错误
            newCall = new Pjsip_Call(*this);
            LOGI("成功创建呼叫对象");
        } catch (pj::Error &e) {
            LOGE("创建呼叫对象失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
            return;
        } catch (std::exception &e) {
            LOGE("创建呼叫对象时发生标准异常: %{public}s", e.what());
            return;
        } catch (...) {
            LOGE("创建呼叫对象时发生未知异常");
            return;
        }
        
        if (newCall) {
            try {
                // 添加侦听器
                if (listener_) {
                    LOGI("将呼叫状态侦听器附加到新呼叫对象");
                    newCall->attachListener(listener_);
                }
                
                LOGI("准备拨打电话...");
                // 创建呼叫操作参数，使用传入的参数或创建默认参数
                pj::CallOpParam local_prm = prm;
                
                // 设置默认值，如果没有设置
                if (local_prm.opt.audioCount <= 0) {
                    local_prm.opt.audioCount = 1;
                }
                
                // 默认禁用视频
                if (local_prm.opt.videoCount < 0) {
                    local_prm.opt.videoCount = 0;
                }
                
                // 强制使用基本标记
                local_prm.opt.flag |= 1; // 常量取代PJSUA_CALL_REGULAR
                
                // 检查URI是否包含完整端口信息
                std::string finalUri = uri;
                // 确保URI已经以sip:开头
                if (finalUri.find("sip:") != 0 && finalUri.find("sips:") != 0) {
                    finalUri = "sip:" + finalUri;
                }
                
                // 检查URI中是否包含@符号和端口号
                size_t atPos = finalUri.find('@');
                if (atPos != std::string::npos) {
                    size_t hostStart = atPos + 1;
                    size_t hostEnd = finalUri.find(';', hostStart);
                    if (hostEnd == std::string::npos) {
                        hostEnd = finalUri.length();
                    }
                    
                    std::string hostname = finalUri.substr(hostStart, hostEnd - hostStart);
                    // 检查URI中的域名部分是否已包含端口号
                    if (hostname.find(':') == std::string::npos) {
                        // 没有端口号，尝试从注册服务器URI中获取端口
                        // 使用账户配置而不是从getInfo()获取
                        try {
                            // 使用accountConfig成员变量获取注册服务器URI
                            std::string registrarUri = accountConfig.regConfig.registrarUri;
                            LOGI("注册服务器URI: %{public}s", registrarUri.c_str());
                            
                            if (!registrarUri.empty()) {
                                size_t regPortPos = registrarUri.find(':', registrarUri.find("sip:") + 4);
                                if (regPortPos != std::string::npos) {
                                    // 提取端口号
                                    size_t regPortEnd = registrarUri.find(';', regPortPos);
                                    if (regPortEnd == std::string::npos) {
                                        regPortEnd = registrarUri.find('/', regPortPos);
                                    }
                                    if (regPortEnd == std::string::npos) {
                                        regPortEnd = registrarUri.length();
                                    }
                                    std::string port = registrarUri.substr(regPortPos, regPortEnd - regPortPos);
                                    LOGI("从注册服务器URI获取端口: %{public}s", port.c_str());
                                    
                                    // 将注册服务器的端口应用到呼叫URI
                                    std::string domainWithPort = hostname + port;
                                    finalUri.replace(hostStart, hostEnd - hostStart, domainWithPort);
                                }
                            } else {
                                LOGW("注册服务器URI为空，无法获取端口");
                            }
                        } catch (std::exception &e) {
                            LOGW("获取注册服务器端口失败: %{public}s", e.what());
                        }
                    }
                }
                
                // 确保URI使用UDP传输
                if (finalUri.find(";transport=") == std::string::npos) {
                    finalUri += ";transport=udp";
                }
                
                LOGI("最终拨打URI：%{public}s", finalUri.c_str());
                
                // 执行呼叫 - 直接调用makeCall，不要使用getInfo等可能引起崩溃的方法
                LOGI("调用Call::makeCall...");
                try {
                    newCall->makeCall(finalUri, local_prm);
                    LOGI("呼叫请求已发送");
                    
                    // 先更新当前呼叫对象，再进行其他操作
                    {
                        std::lock_guard<std::mutex> lock(callMutex_);
                        if (currentCall_) {
                            delete currentCall_;
                        }
                        currentCall_ = newCall;
                    }
                    LOGI("当前活动呼叫已更新");
                } catch (pj::Error &e) {
                    LOGE("发起呼叫失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
                    delete newCall;  // 清理资源
                    return;
                }
            } catch (pj::Error &e) {
                LOGE("准备呼叫过程失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
                delete newCall;  // 清理资源
                return;
            } catch (std::exception &e) {
                LOGE("准备呼叫过程发生标准异常: %{public}s", e.what());
                delete newCall;  // 清理资源
                return;
            } catch (...) {
                LOGE("准备呼叫过程发生未知异常");
                delete newCall;  // 清理资源
                return;
            }
        } else {
            LOGE("创建呼叫对象后指针为空");
        }
    } catch (std::exception &e) {
        LOGE("Pjsip_Account::makeCall 发生标准异常: %{public}s", e.what());
    } catch (...) {
        LOGE("Pjsip_Account::makeCall 发生未知异常");
    }
    
    LOGI("Pjsip_Account::makeCall 完成");
}

void Pjsip_Account::notifyCallState(int state) {
    LOGI("notifyCallState: 通话状态变更为 %d", state);
    
    if (callStateTsfn_ != nullptr) {
        // 创建回调数据
        CallStateCallbackData* data = new CallStateCallbackData {
            state
        };
        
        LOGI("notifyCallState: 正在通过线程安全函数发送状态 %d", state);
        
        // 使用线程安全函数在JS线程中调用回调
        napi_status status = napi_call_threadsafe_function(callStateTsfn_, data, napi_tsfn_blocking);
        if (status != napi_ok) {
            LOGE("notifyCallState: 调用通话状态线程安全函数失败，错误码: %d", status);
            // 释放内存，避免泄漏
            delete data;
        } else {
            LOGI("notifyCallState: 成功发送通话状态改变事件到JS线程：%d", state);
        }
    } else {
        // 记录日志，保存静态变量以便前端主动查询
        LOGI("notifyCallState: 通话状态改变但没有线程安全回调: %d，尝试将来再次通知", state);
        static int lastState = state;
    }
}

void Pjsip_Account::notifyRegState(int state, const std::string& reason) {
    LOGI("notifyRegState: 注册状态变更为 %d, 原因: %s", state, reason.c_str());
    
    if (regTsfn_ != nullptr) {
        // 创建回调数据
        RegStateCallbackData* data = new RegStateCallbackData {
            state,
            reason
        };
        
        LOGI("notifyRegState: 正在通过线程安全函数发送状态 %d, 原因: %s", state, reason.c_str());
        
        // 使用线程安全函数在JS线程中调用回调
        napi_status status = napi_call_threadsafe_function(regTsfn_, data, napi_tsfn_blocking);
        if (status != napi_ok) {
            LOGE("notifyRegState: 调用线程安全函数失败，错误码: %d", status);
            // 释放内存，避免泄漏
            delete data;
        } else {
            LOGI("notifyRegState: 成功发送注册状态改变事件到JS线程：%d, %s", state, reason.c_str());
        }
    } else {
        // 记录日志，保存静态变量以便前端主动查询
        LOGI("notifyRegState: 注册状态改变但没有线程安全回调: %d, %s，尝试将来再次通知", state, reason.c_str());
        static int lastState = state;
        static std::string lastReason = reason;
    }
}

void Pjsip_Account::notifyIncomingCall(const std::string& from) {
    LOGI("notifyIncomingCall: 有来电 %s", from.c_str());
    
    if (incomingCallTsfn_ != nullptr) {
        // 创建回调数据
        IncomingCallCallbackData* data = new IncomingCallCallbackData {
            from
        };
        
        LOGI("notifyIncomingCall: 正在通过线程安全函数发送来电通知 %s", from.c_str());
        
        // 使用线程安全函数在JS线程中调用回调
        napi_status status = napi_call_threadsafe_function(incomingCallTsfn_, data, napi_tsfn_blocking);
        if (status != napi_ok) {
            LOGE("notifyIncomingCall: 调用来电线程安全函数失败，错误码: %d", status);
            // 释放内存，避免泄漏
            delete data;
        } else {
            LOGI("notifyIncomingCall: 成功发送来电事件到JS线程：%s", from.c_str());
        }
    } else {
        // 记录日志，保存静态变量以便前端主动查询
        LOGI("notifyIncomingCall: 收到来电但没有线程安全回调: %s，尝试将来再次通知", from.c_str());
        static std::string lastIncomingNumber = from;
    }
}

Pjsip_Call* Pjsip_Account::getCurrentCall() {
    std::lock_guard<std::mutex> lock(callMutex_);
    
    if (currentCall_ == nullptr) {
        return nullptr;
    }
    
    // 尝试将 pj::Call 转换为 Pjsip_Call
    try {
        return dynamic_cast<Pjsip_Call*>(currentCall_);
    } catch (std::exception& e) {
        LOGE("转换 currentCall_ 失败: %{public}s", e.what());
        return nullptr;
    }
}

} // namespace pjsip 