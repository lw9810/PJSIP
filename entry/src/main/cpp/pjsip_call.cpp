//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "pjsip_call.h"
#include "log_writer.h"
#include "pjsip_account.h"

using namespace pjsip;

Pjsip_Call::Pjsip_Call(pj::Account &acc, int call_id) : pj::Call(acc, call_id), listener_(nullptr), account_(&acc) {
    LOGI("Pjsip_Call created with ID: %d", call_id);
}

// 无ID版本的构造函数，仅初始化基类，不调用getInfo()
Pjsip_Call::Pjsip_Call(pj::Account &acc) : pj::Call(acc, PJSUA_INVALID_ID), listener_(nullptr), account_(&acc) {
    LOGI("Pjsip_Call created without ID");
}

Pjsip_Call::~Pjsip_Call() {
    LOGI("Pjsip_Call destroyed");
    listener_ = nullptr;
    account_ = nullptr; // 不需要删除，仅标记为nullptr
}

void Pjsip_Call::onCallState(pj::OnCallStateParam &prm) {
    try {
        pj::CallInfo ci = getInfo();
        LOGI("Call state changed to %{public}d (%{public}s)", ci.state, ci.stateText.c_str());
        
        // 更详细的状态描述
        std::string stateDesc;
        switch (ci.state) {
            case PJSIP_INV_STATE_NULL: stateDesc = "NULL (空闲)"; break;
            case PJSIP_INV_STATE_CALLING: stateDesc = "CALLING (呼叫中)"; break;
            case PJSIP_INV_STATE_INCOMING: stateDesc = "INCOMING (来电)"; break;
            case PJSIP_INV_STATE_EARLY: stateDesc = "EARLY (早期媒体)"; break;
            case PJSIP_INV_STATE_CONNECTING: stateDesc = "CONNECTING (连接中)"; break;
            case PJSIP_INV_STATE_CONFIRMED: stateDesc = "CONFIRMED (通话中)"; break;
            case PJSIP_INV_STATE_DISCONNECTED: stateDesc = "DISCONNECTED (已断开)"; break;
            default: stateDesc = "未知状态"; break;
        }
        LOGI("通话状态详细描述: %{public}s", stateDesc.c_str());
        
        // 确保监听器被调用
        if (listener_ != nullptr) {
            LOGI("通知监听器状态变化: %{public}d", ci.state);
            listener_->onCallStateChange(ci.state);
        } else {
            LOGW("无可用的监听器来通知状态变化，尝试通知账户监听器");
            
            // 尝试通过账户对象通知
            if (account_ != nullptr) {
                try {
                    pjsip::Pjsip_Account* acc = dynamic_cast<pjsip::Pjsip_Account*>(account_);
                    if (acc != nullptr) {
                        LOGI("通过账户对象通知状态变化");
                        acc->notifyCallState(ci.state);
                    } else {
                        LOGW("账户不是 Pjsip_Account 类型，无法通知");
                    }
                } catch (std::exception& e) {
                    LOGE("尝试通知账户时出错: %{public}s", e.what());
                } catch (...) {
                    LOGE("尝试通知账户时出现未知错误");
                }
            } else {
                LOGW("没有可用的账户对象来通知状态变化");
            }
        }
    } catch (pj::Error &e) {
        LOGE("获取呼叫信息失败: %{public}s", e.info().c_str());
    } catch (...) {
        LOGE("调用onCallState异常");
    }
}

void Pjsip_Call::onCallMediaState(pj::OnCallMediaStateParam &prm) {
    LOGI("Call media state changed");
    
    pj::CallInfo ci = getInfo();
    for (unsigned i = 0; i < ci.media.size(); i++) {
        if (ci.media[i].type == PJMEDIA_TYPE_AUDIO) {
            try {
                pj::AudioMedia am = getAudioMedia(i);
                am.startTransmit(pj::Endpoint::instance().audDevManager().getPlaybackDevMedia());
                pj::Endpoint::instance().audDevManager().getCaptureDevMedia().startTransmit(am);
            } catch (pj::Error &e) {
                LOGE("Error connecting audio media: %{public}s", e.info().c_str());
            }
        } else if (ci.media[i].type == PJMEDIA_TYPE_VIDEO) {
            // 视频处理暂未实现
        }
    }
    
    if (listener_) {
        listener_->onCallMediaEvent(0);
    }
}

void Pjsip_Call::onCallTransferStatus(pj::OnCallTransferStatusParam &prm) {
    // 未实现
}

void Pjsip_Call::onCallReplaced(pj::OnCallReplacedParam &prm) {
    // 未实现
}

void Pjsip_Call::onCallMediaEvent(pj::OnCallMediaEventParam &prm) {
    // 未实现
}

void Pjsip_Call::onCallSdpCreated(pj::OnCallSdpCreatedParam &prm) { 
    LOGI("pjsip_call onCallSdpCreated---->");
    
    // 简单记录SDP内容而不尝试修改
    LOGI("SDP已创建，内容: %s", prm.sdp.wholeSdp.c_str());
    
    // 由于C++层封装的原因，我们无法直接操作底层的SDP结构
    // 如果需要修改SDP，应该在更底层的PJSIP_UA回调中进行
}

void Pjsip_Call::makeCall(const std::string &dst_uri, const pj::CallOpParam &prm) {
    LOGI("Pjsip_Call::makeCall - 开始拨打: %{public}s", dst_uri.c_str());
    
    try {
        // 首先检查URI是否为空
        if (dst_uri.empty()) {
            LOGE("Pjsip_Call::makeCall - URI为空，无法拨打");
            return;
        }
        
        // 首先验证音频设备状态
        try {
            pj::AudDevManager& mgr = pj::Endpoint::instance().audDevManager();
            int count = mgr.getDevCount();
            if (count <= 0) {
                LOGE("没有可用的音频设备，无法拨打电话");
                return;
            }
            LOGI("检测到%d个音频设备", count);
            
            // 获取当前设备ID，检查是否正确设置
            int playDev = mgr.getPlaybackDev();
            int capDev = mgr.getCaptureDev();
            LOGI("当前音频设备: 播放设备=%d, 录音设备=%d", playDev, capDev);
            
            // 如果设备ID无效，尝试重新设置
            if (playDev < 0 || capDev < 0) {
                LOGW("检测到无效的音频设备ID，尝试重新设置...");
                mgr.setPlaybackDev(0);
                mgr.setCaptureDev(0);
                LOGI("重新设置音频设备为默认设备");
            }
        } catch (pj::Error &e) {
            LOGE("音频设备检查失败: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
            // 音频设备问题是严重错误，但让我们继续尝试，可能有内部的容错机制
        }
        
        // 检查并确保URI格式包含UDP传输
        std::string final_uri = dst_uri;
        
        // 首先检查URI是否有SIP前缀
        if (final_uri.find("sip:") != 0 && final_uri.find("sips:") != 0) {
            LOGW("URI格式不正确，添加sip:前缀");
            final_uri = "sip:" + final_uri;
        }
        
        // 确保URI使用UDP传输
        if (final_uri.find(";transport=") == std::string::npos) {
            LOGI("添加UDP传输参数到URI");
            final_uri += ";transport=udp";
        } else if (final_uri.find(";transport=udp") == std::string::npos) {
            // 替换任何其他传输为UDP
            LOGW("替换现有传输参数为UDP");
            size_t pos = final_uri.find(";transport=");
            size_t end = final_uri.find(";", pos + 1);
            if (end == std::string::npos) {
                final_uri.replace(pos, std::string::npos, ";transport=udp");
            } else {
                final_uri.replace(pos, end - pos, ";transport=udp");
            }
        }
        
        // 检查URI是否包含端口，如果没有，尝试从hostname中查找
        size_t atPos = final_uri.find('@');
        if (atPos != std::string::npos) {
            size_t hostStart = atPos + 1;
            size_t hostEnd = final_uri.find(';', hostStart);
            if (hostEnd == std::string::npos) {
                hostEnd = final_uri.length();
            }
            
            std::string hostname = final_uri.substr(hostStart, hostEnd - hostStart);
            if (hostname.find(':') == std::string::npos) {
                // 没有端口号，可以自动添加端口，但保持端口号可配置
                LOGI("URI不包含端口，将保持原样使用默认端口");
            }
        }
        
        // 输出最终使用的URI
        LOGI("最终拨打URI: %{public}s", final_uri.c_str());
        
        // 更安全的方式进行呼叫
        LOGI("开始准备拨打电话...");
        // 确保所有参数有效
        if (final_uri.empty()) {
            LOGE("目标URI为空，无法拨打");
            return;
        }
        
        // 设置呼叫参数
        LOGI("设置呼叫参数...");
        pj::CallOpParam prm;
        prm.opt.audioCount = 1;
        prm.opt.videoCount = 0;
        
        // 设置会话计时器模式为强制使用会话计时器
        // 注意：pj::CallSetting 没有 timerUse 成员，只能使用 flag
        prm.opt.flag |= 1;  // 使用会话计时器标志 (PJSUA_CALL_USE_TIMER)
        
        // 设置安全通话标志
        try {
            LOGI("设置安全通话标志");
            // 您的PJSIP库可能不支持PJSUA_CALL_SECURE标志
            // callParam.opt.flag |= PJSUA_CALL_SECURE;
            LOGI("注意: 当前PJSIP库可能不支持安全通话功能");
        } catch (std::exception &e) {
            LOGW("设置安全通话标志时出错: %s", e.what());
        } catch (...) {
            LOGW("设置安全通话标志时出现未知错误");
        }
        
        // 发起呼叫
        try {
            LOGI("调用父类makeCall方法...");
            
            // 重要：先为音频设备创建安全的上下文
            try {
                pjsua_call_setting call_setting;
                pjsua_call_setting_default(&call_setting);
                call_setting.aud_cnt = prm.opt.audioCount;
                call_setting.vid_cnt = prm.opt.videoCount;
                
                // 使设备处于准备就绪状态
                pjsua_set_no_snd_dev();
                pjsua_set_snd_dev(PJMEDIA_AUD_DEFAULT_CAPTURE_DEV, PJMEDIA_AUD_DEFAULT_PLAYBACK_DEV);
                
                LOGI("音频设备准备完成");
            } catch (pj::Error &e) {
                LOGW("设置音频设备失败，但将继续尝试通话: %{public}s", e.info().c_str());
            } catch (...) {
                LOGW("设置音频设备时发生未知异常，但将继续尝试通话");
            }
            
            // 获取账户和验证账户有效性
            try {
                // 获取账户信息前先检查我们是否有有效的呼叫ID
                int callId = getId();
                if (callId != PJSUA_INVALID_ID) {
                    LOGI("当前有效的呼叫ID: %d", callId);
                } else {
                    LOGW("当前没有有效的呼叫ID，使用构造函数中的账户");
                }
                
                // 尝试获取账户信息
                pj::Account *acc = nullptr;
                try {
                    // 使用保存的account_成员变量
                    acc = account_;
                    if (acc) {
                        LOGI("成功获取账户信息");
                    } else {
                        LOGE("无法获取有效的账户对象");
                        return;
                    }
                } catch (pj::Error &e) {
                    LOGE("获取账户信息失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
                    return;
                } catch (...) {
                    LOGE("获取账户信息时发生未知异常");
                    return;
                }
            } catch (pj::Error &e) {
                LOGE("验证账户有效性失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
                return;
            } catch (...) {
                LOGE("验证账户有效性时发生未知异常");
                return;
            }
            
            // 现在拨打电话，使用最健壮的异常处理
            try {
                // 记录拨打开始时间
                LOGI("开始拨打电话: %{public}s", final_uri.c_str());
                
                // 调用父类的makeCall方法
                pj::Call::makeCall(final_uri, prm);
                
                LOGI("makeCall请求成功发送");
            } catch (pj::Error &e) {
                LOGE("调用父类makeCall方法失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
                throw; // 重新抛出异常以便上层处理
            } catch (std::exception &e) {
                LOGE("调用父类makeCall方法失败，发生标准异常: %{public}s", e.what());
                throw;
            } catch (...) {
                LOGE("调用父类makeCall方法失败，发生未知异常");
                throw;
            }
            
            // 只有在呼叫成功创建后才获取呼叫信息
            try {
                // 呼叫成功后，此时应该已有有效的call_id
                int call_id = getId();
                if (call_id >= 0) {
                    LOGI("呼叫ID: %{public}d", call_id);
                    
                    // 获取更多详细信息，使用try-catch保护
                    try {
                        pj::CallInfo ci = getInfo();
                        LOGI("呼叫状态: %{public}d, 远端URI: %{public}s", 
                             ci.state, ci.remoteUri.c_str());
                    } catch (pj::Error &e) {
                        // 只记录，不中断流程
                        LOGW("获取详细呼叫信息失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
                    }
                } else {
                    LOGW("获取到无效的呼叫ID: %d", call_id);
                }
            } catch (pj::Error &e) {
                // 只记录，不中断流程
                LOGW("获取呼叫ID失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
            }
        } catch (pj::Error &e) {
            LOGE("调用makeCall方法失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
            throw; // 重新抛出异常以便上层处理
        }
    } catch (pj::Error &e) {
        LOGE("makeCall整体流程失败: %{public}s [错误码: %{public}d]", e.info().c_str(), e.status);
        // 不要在这里抛出异常，而是安全返回
    } catch (std::exception &e) {
        LOGE("makeCall发生标准异常: %{public}s", e.what());
    } catch (...) {
        LOGE("makeCall发生未知异常");
    }
    
    LOGI("Pjsip_Call::makeCall 执行完成");
}

void Pjsip_Call::attachListener(Pjsip_Listener *listener) {
    listener_ = listener;
} 

// 通话状态监听器实现
class CallStateListener : public Pjsip_Listener {
public:
    CallStateListener(napi_env env, napi_ref callback) 
        : env_(env), callback_(callback), tsfn_(nullptr) {
        // 创建线程安全函数
        InitThreadSafeFunction();
    }
    
    ~CallStateListener() {
        // 释放资源
        if (tsfn_ != nullptr) {
            napi_release_threadsafe_function(tsfn_, napi_tsfn_abort);
            tsfn_ = nullptr;
        }
        
        if (callback_ != nullptr) {
            napi_delete_reference(env_, callback_);
            callback_ = nullptr;
        }
    }
    
    void onCallStateChange(int32_t status) override {
        LOGI("CallStateListener::onCallStateChange - 状态: %{public}d", status);
        
        // 转换状态到人类可读的描述
        std::string stateDesc;
        switch (status) {
            case PJSIP_INV_STATE_NULL: stateDesc = "NULL (空闲)"; break;
            case PJSIP_INV_STATE_CALLING: stateDesc = "CALLING (呼叫中)"; break;
            case PJSIP_INV_STATE_INCOMING: stateDesc = "INCOMING (来电)"; break;
            case PJSIP_INV_STATE_EARLY: stateDesc = "EARLY (早期媒体)"; break;
            case PJSIP_INV_STATE_CONNECTING: stateDesc = "CONNECTING (连接中)"; break;
            case PJSIP_INV_STATE_CONFIRMED: stateDesc = "CONFIRMED (通话中)"; break;
            case PJSIP_INV_STATE_DISCONNECTED: stateDesc = "DISCONNECTED (已断开)"; break;
            default: stateDesc = "未知状态"; break;
        }
        LOGI("即将通知JS通话状态变化: %{public}d (%{public}s)", status, stateDesc.c_str());
        
        // 确保线程安全函数已初始化
        if (tsfn_ == nullptr) {
            LOGE("线程安全函数未初始化，无法通知状态变化");
            return;
        }
        
        // 创建状态数据并复制
        int32_t* status_data = new int32_t(status);
        
        // 调用线程安全函数，传递状态数据
        LOGI("正在调用线程安全函数发送状态: %{public}d", status);
        napi_status result = napi_call_threadsafe_function(tsfn_, 
            status_data, napi_tsfn_blocking);
            
        if (result != napi_ok) {
            LOGE("调用线程安全函数失败，错误码: %{public}d", result);
            delete status_data; // 释放内存
        } else {
            LOGI("成功发送通话状态到JS线程");
        }
    }
    
    // 不覆盖其他方法，使用默认的空实现
    
private:
    napi_env env_;
    napi_ref callback_;
    napi_threadsafe_function tsfn_;
    
    // JS回调函数，将在主线程上执行
    static void CallJsCallback(napi_env env, napi_value js_callback, 
                             void* context, void* data) {
        LOGI("CallStateListener::CallJsCallback - 开始执行JS回调");
        
        if (data == nullptr) {
            LOGE("回调数据为空");
            return;
        }
        
        // 转换数据指针
        int32_t* status = static_cast<int32_t*>(data);
        LOGI("JS回调: 收到通话状态数据: %{public}d", *status);
        
        // 转换状态到人类可读的描述
        std::string stateDesc;
        switch (*status) {
            case PJSIP_INV_STATE_NULL: stateDesc = "NULL (空闲)"; break;
            case PJSIP_INV_STATE_CALLING: stateDesc = "CALLING (呼叫中)"; break;
            case PJSIP_INV_STATE_INCOMING: stateDesc = "INCOMING (来电)"; break;
            case PJSIP_INV_STATE_EARLY: stateDesc = "EARLY (早期媒体)"; break;
            case PJSIP_INV_STATE_CONNECTING: stateDesc = "CONNECTING (连接中)"; break;
            case PJSIP_INV_STATE_CONFIRMED: stateDesc = "CONFIRMED (通话中)"; break;
            case PJSIP_INV_STATE_DISCONNECTED: stateDesc = "DISCONNECTED (已断开)"; break;
            default: stateDesc = "未知状态"; break;
        }
        LOGI("JS回调: 准备调用JS函数传递状态: %{public}d (%{public}s)", *status, stateDesc.c_str());
        
        // 检查回调函数是否有效
        napi_valuetype value_type;
        napi_status check_result = napi_typeof(env, js_callback, &value_type);
        if (check_result != napi_ok || value_type != napi_function) {
            LOGE("提供的回调不是函数类型，错误码: %{public}d, 类型: %{public}d", check_result, value_type);
            delete status;
            return;
        }
        
        // 创建一个数字值
        napi_value status_value;
        napi_status result = napi_create_int32(env, *status, &status_value);
        
        if (result != napi_ok) {
            LOGE("创建状态值失败，错误码: %{public}d", result);
            delete status; // 释放内存
            return;
        }
        
        // 验证创建的值是否有效
        napi_valuetype value_type2;
        result = napi_typeof(env, status_value, &value_type2);
        if (result != napi_ok || value_type2 != napi_number) {
            LOGE("创建的状态值类型错误，期望number，实际: %{public}d", value_type2);
            delete status;
            return;
        }
        
        // 调用JS回调
        napi_value global;
        result = napi_get_global(env, &global);
        
        if (result != napi_ok) {
            LOGE("获取全局对象失败，错误码: %{public}d", result);
            delete status; // 释放内存
            return;
        }
        
        LOGI("开始调用JS回调函数...");
        napi_value args[] = { status_value };
        napi_value ret;
        result = napi_call_function(env, global, js_callback, 1, args, &ret);
        
        if (result != napi_ok) {
            LOGE("调用JS回调失败，错误码: %{public}d", result);
        } else {
            LOGI("成功调用了JS回调函数，状态值: %{public}d", *status);
        }
        
        // 释放内存
        delete status;
        LOGI("CallStateListener::CallJsCallback - 执行JS回调完成");
    }
    
    // 初始化线程安全函数
    void InitThreadSafeFunction() {
        LOGI("CallStateListener::InitThreadSafeFunction - 开始初始化线程安全函数");
        
        // 检查环境是否有效
        if (env_ == nullptr) {
            LOGE("NAPI环境为空，无法初始化线程安全函数");
            return;
        }
        
        // 检查回调引用是否有效
        if (callback_ == nullptr) {
            LOGE("回调函数引用为空，无法初始化线程安全函数");
            return;
        }
        
        // 获取回调函数值
        napi_value callback_value;
        napi_status status = napi_get_reference_value(env_, callback_, &callback_value);
        
        if (status != napi_ok) {
            LOGE("获取回调引用失败，错误码: %{public}d", status);
            return;
        }
        
        // 验证回调是否为函数
        napi_valuetype value_type;
        status = napi_typeof(env_, callback_value, &value_type);
        if (status != napi_ok || value_type != napi_function) {
            LOGE("回调引用不是函数类型，错误码: %{public}d, 类型: %{public}d", status, value_type);
            return;
        }
        
        LOGI("成功获取回调函数引用");
        
        // 创建资源名称
        napi_value resource_name;
        status = napi_create_string_utf8(env_, "CallStateCallback", 
                                     NAPI_AUTO_LENGTH, &resource_name);
        
        if (status != napi_ok) {
            LOGE("创建资源名称失败，错误码: %{public}d", status);
            return;
        }
        
        // 创建线程安全函数
        LOGI("开始创建线程安全函数...");
        status = napi_create_threadsafe_function(
            env_,                    // 环境
            callback_value,          // 回调函数
            nullptr,                 // async_resource
            resource_name,           // async_resource_name
            0,                       // max_queue_size (0表示无限)
            1,                       // initial_thread_count
            nullptr,                 // thread_finalize_data
            nullptr,                 // thread_finalize_cb
            nullptr,                 // context
            CallJsCallback,          // call_js_cb
            &tsfn_                   // result
        );
        
        if (status != napi_ok) {
            LOGE("创建线程安全函数失败，错误码: %{public}d", status);
            tsfn_ = nullptr;
        } else {
            LOGI("成功创建通话状态回调的线程安全函数，tsfn_指针: %{public}p", tsfn_);
        }
    }
};

void Pjsip_Call::addCallStateListener(napi_env env, napi_ref callback) {
    LOGI("Pjsip_Call::addCallStateListener - 开始添加通话状态监听器");
    
    // 检查环境是否有效
    if (env == nullptr) {
        LOGE("NAPI环境为空，无法添加监听器");
        return;
    }
    
    // 检查回调引用是否有效
    if (callback == nullptr) {
        LOGE("回调函数引用为空，无法添加监听器");
        return;
    }
    
    // 验证回调是否为函数
    napi_value callback_value;
    napi_status status = napi_get_reference_value(env, callback, &callback_value);
    if (status != napi_ok) {
        LOGE("获取回调引用失败，错误码: %{public}d", status);
        return;
    }
    
    napi_valuetype value_type;
    status = napi_typeof(env, callback_value, &value_type);
    if (status != napi_ok || value_type != napi_function) {
        LOGE("回调引用不是函数类型，错误码: %{public}d, 类型: %{public}d", status, value_type);
        return;
    }
    
    LOGI("回调引用有效，准备创建监听器");
    
    try {
        // 如果已经有监听器，先释放它
        if (listener_ != nullptr) {
            LOGI("已存在监听器，将被替换");
            delete listener_;
            listener_ = nullptr;
        }
        
        // 创建新的自定义监听器
        CallStateListener* listener = new CallStateListener(env, callback);
        if (listener == nullptr) {
            LOGE("创建监听器失败，内存分配错误");
            return;
        }
        
        LOGI("成功创建新的CallStateListener实例");
        
        // 将监听器附加到呼叫对象
        listener_ = listener;
        
        LOGI("通话状态监听器添加成功，现在等待状态变化事件");
    } catch (std::exception& e) {
        LOGE("添加通话状态监听器失败: %{public}s", e.what());
    } catch (...) {
        LOGE("添加通话状态监听器时发生未知异常");
    }
} 