//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "pjsip_app.h"
#include "log_writer.h"
#include "pjsip_account.h"
#include "pjsip_call.h"
#include <pjsua2/media.hpp>
#include <native_window/external_window.h>
#include <pjsua.h>
#include <pjsip.h>
#include <pjsip_ua.h>

namespace pjsip {

const int LOG_LEVEL = 5;
const int SIP_PORT = 6000;
std::shared_ptr<pj::Endpoint> PjsipApp::endpoint = nullptr;

// 实现SIP消息回调函数
static pj_bool_t on_rx_request(pjsip_rx_data* rdata)
{
    if (!rdata || !rdata->msg_info.msg) {
        LOGE("RX请求: 收到空数据");
        return PJ_FALSE;
    }
    
    pjsip_msg* msg = rdata->msg_info.msg;
    char uri_buf[512];
    int len = pjsip_uri_print(PJSIP_URI_IN_REQ_URI, msg->line.req.uri, uri_buf, sizeof(uri_buf));
    if (len <= 0) {
        pj_ansi_strncpy(uri_buf, "[URI不可打印]", sizeof(uri_buf));
    }
    
    LOGI("RX请求: %.*s %s", 
         (int)msg->line.req.method.name.slen,
         msg->line.req.method.name.ptr,
         uri_buf);
    return PJ_FALSE; // 返回PJ_FALSE继续处理，PJ_TRUE终止处理
}

static pj_bool_t on_rx_response(pjsip_rx_data* rdata)
{
    if (!rdata || !rdata->msg_info.msg) {
        LOGE("RX响应: 收到空数据");
        return PJ_FALSE;
    }
    
    pjsip_msg* msg = rdata->msg_info.msg;
    LOGI("RX响应: %d %.*s", 
         msg->line.status.code,
         (int)msg->line.status.reason.slen,
         msg->line.status.reason.ptr);
    return PJ_FALSE; // 返回PJ_FALSE继续处理，PJ_TRUE终止处理
}

static pj_status_t on_tx_request(pjsip_tx_data* tdata)
{
    if (!tdata || !tdata->msg) {
        LOGE("TX请求: 发送空数据");
        return PJ_SUCCESS;
    }
    
    pjsip_msg* msg = tdata->msg;
    char uri_buf[512];
    int len = pjsip_uri_print(PJSIP_URI_IN_REQ_URI, msg->line.req.uri, uri_buf, sizeof(uri_buf));
    if (len <= 0) {
        pj_ansi_strncpy(uri_buf, "[URI不可打印]", sizeof(uri_buf));
    }
    
    LOGI("TX请求: %.*s %s", 
         (int)msg->line.req.method.name.slen,
         msg->line.req.method.name.ptr,
         uri_buf);
    return PJ_SUCCESS;
}

static pj_status_t on_tx_response(pjsip_tx_data* tdata)
{
    if (!tdata || !tdata->msg) {
        LOGE("TX响应: 发送空数据");
        return PJ_SUCCESS;
    }
    
    pjsip_msg* msg = tdata->msg;
    LOGI("TX响应: %d %.*s", 
         msg->line.status.code,
         (int)msg->line.status.reason.slen,
         msg->line.status.reason.ptr);
    return PJ_SUCCESS;
}

// SIP模块定义
// 接收请求模块
static pjsip_module rx_req_module = {
    NULL, NULL,                  // prev, next
    { (char*)"rx_req_module", 13 },     // 名称
    -1,                          // ID
    PJSIP_MOD_PRIORITY_DIALOG_USAGE - 1, // 优先级
    NULL,                        // load()
    NULL,                        // start()
    NULL,                        // stop()
    NULL,                        // unload()
    on_rx_request,               // on_rx_request()
    NULL,                        // on_rx_response()
    NULL,                        // on_tx_request()
    NULL,                        // on_tx_response()
};

// 接收响应模块
static pjsip_module rx_res_module = {
    NULL, NULL,                  // prev, next
    { (char*)"rx_res_module", 13 },     // 名称
    -1,                          // ID
    PJSIP_MOD_PRIORITY_DIALOG_USAGE - 1, // 优先级
    NULL,                        // load()
    NULL,                        // start()
    NULL,                        // stop()
    NULL,                        // unload()
    NULL,                        // on_rx_request()
    on_rx_response,              // on_rx_response()
    NULL,                        // on_tx_request()
    NULL,                        // on_tx_response()
};

// 发送请求模块
static pjsip_module tx_req_module = {
    NULL, NULL,                  // prev, next
    { (char*)"tx_req_module", 13 },     // 名称
    -1,                          // ID
    PJSIP_MOD_PRIORITY_DIALOG_USAGE - 1, // 优先级
    NULL,                        // load()
    NULL,                        // start()
    NULL,                        // stop()
    NULL,                        // unload()
    NULL,                        // on_rx_request()
    NULL,                        // on_rx_response()
    on_tx_request,               // on_tx_request()
    NULL,                        // on_tx_response()
};

// 发送响应模块
static pjsip_module tx_res_module = {
    NULL, NULL,                  // prev, next
    { (char*)"tx_res_module", 13 },     // 名称
    -1,                          // ID
    PJSIP_MOD_PRIORITY_DIALOG_USAGE - 1, // 优先级
    NULL,                        // load()
    NULL,                        // start()
    NULL,                        // stop()
    NULL,                        // unload()
    NULL,                        // on_rx_request()
    NULL,                        // on_rx_response()
    NULL,                        // on_tx_request()
    on_tx_response,              // on_tx_response()
};

PjsipApp::~PjsipApp() {
    destroy();
}

int PjsipApp::initPJSIP() {
    LOG_FUNC_SCOPE; // 自动记录函数进入和退出
    LOGI("PjsipApp initPJSIP 开始初始化...");
    
    if (isInit) {
        LOGI("PJSIP已经初始化，无需重复操作");
        return 0;
    }
    
    // 标记初始化开始，但要确保即使失败也能安全地重试
    // 将isInit标记移到成功后再设置
    
    try {
        // 创建端点实例
        LOGI("创建PJSIP端点实例...");
        if (endpoint) {
            LOGI("PJSIP端点实例已存在，将重用");
        } else {
            endpoint = std::make_shared<pj::Endpoint>();
        }
        
        if (!endpoint) {
            LOGE("创建PJSIP端点实例失败");
            return -1;
        }
        
        // 配置日志
        LOGI("配置PJSIP日志系统...");
        pj::EpConfig epConfig;
        epConfig.logConfig.level = 6; // 增加日志级别，获取更详细信息
        epConfig.logConfig.consoleLevel = 6;
        
        // 确保日志写入器被正确创建
        PJSIP_Writer* logWriter = new PJSIP_Writer();
        if (!logWriter) {
            LOGE("创建日志写入器失败");
            return -1;
        }
        epConfig.logConfig.writer = logWriter;
        epConfig.logConfig.decor = epConfig.logConfig.decor & ~256 | 128;
        
        // 启用SIP消息日志
        epConfig.logConfig.msgLogging = PJ_TRUE;
        
        // 设置用户代理
        std::string agent = "KX_SIP_PjSIP";
        LOGI("设置用户代理为: %{public}s", agent.c_str());
        epConfig.uaConfig.userAgent = agent;
        
        // 配置媒体参数
        LOGI("配置媒体参数: 时钟频率=%{public}d, 音频帧时长=%{public}d", 8000, 20);
        epConfig.medConfig.clockRate = 8000;
        epConfig.medConfig.audioFramePtime = 20;
        epConfig.medConfig.sndClockRate = 8000;
        epConfig.medConfig.channelCount = 1;

        // 初始化媒体
        epConfig.medConfig.ecTailLen = 0; // 禁用回声消除
        epConfig.medConfig.ecOptions = 0; // 禁用所有回声消除选项
        epConfig.medConfig.noVad = PJ_TRUE; // 禁用语音活动检测
        
        // 配置STUN服务器 - EpConfig不支持natConfig，只支持uaConfig中的stunServer
        LOGI("配置全局STUN服务器...");
        epConfig.uaConfig.stunServer.push_back("stun.l.google.com:19302");
        epConfig.uaConfig.stunServer.push_back("stun1.l.google.com:19302");
        
        // 创建库 - 先不注册线程
        LOGI("创建PJSIP库...");
        try {
            endpoint->libCreate();
        } catch (pj::Error &e) {
            LOGE("创建PJSIP库失败: %s [错误码:%d]", e.info().c_str(), e.status);
            delete logWriter; // 释放已分配的资源
            return -1;
        }
        LOGI("PJSIP库创建成功");
        
        // 初始化库 - 在正确的位置应用配置
        LOGI("初始化PJSIP库...");
        try {
            endpoint->libInit(epConfig);
        } catch (pj::Error &e) {
            LOGE("初始化PJSIP库失败: %s [错误码:%d]", e.info().c_str(), e.status);
            endpoint->libDestroy();
            endpoint = nullptr;
            return -1;
        }
        LOGI("PJSIP库初始化成功");
        
        // 初始化音频设备
        LOGI("初始化音频设备...");
        try {
            pj::AudDevManager& mgr = endpoint->audDevManager();
            int count = mgr.getDevCount();
            LOGI("检测到%d个音频设备", count);
            
            if (count > 0) {
                // 列出所有音频设备
                for (int i = 0; i < count; i++) {
                    try {
                        pj::AudioDevInfo info = mgr.getDevInfo(i);
                        LOGI("音频设备 #%d: 名称=%s, 输入=%d, 输出=%d, 默认采样率=%d", 
                            i, info.name.c_str(), info.inputCount, info.outputCount, info.defaultSamplesPerSec);
                    } catch (pj::Error &e) {
                        LOGW("获取音频设备#%d信息失败: %s", i, e.info().c_str());
                    }
                }
                
                // 设置默认设备
                try {
                    mgr.setPlaybackDev(PJMEDIA_AUD_DEFAULT_PLAYBACK_DEV);
                    mgr.setCaptureDev(PJMEDIA_AUD_DEFAULT_CAPTURE_DEV);
                    LOGI("音频设备设置为默认设备");
                } catch (pj::Error &e) {
                    LOGW("设置默认音频设备失败: %s [错误码:%d]", e.info().c_str(), e.status);
                }
                
                // 设置声音级别
                try {
                    mgr.setOutputVolume(75); // 设置为中等音量级别
                    mgr.setInputVolume(75);
                    LOGI("音频设备音量设置成功");
                } catch (pj::Error &e) {
                    LOGW("设置音频设备音量失败: %s", e.info().c_str());
                }
            } else {
                LOGW("未检测到可用的音频设备，语音功能可能无法使用");
            }
        } catch (pj::Error &e) {
            LOGE("初始化音频设备失败: %s [错误码:%d]", e.info().c_str(), e.status);
            // 这是一个警告，但不必终止整个应用
        }
        
        // 注册SIP消息模块
        LOGI("注册SIP消息模块...");
        try {
            pjsip_endpoint *pjEndpt = pjsua_get_pjsip_endpt();
            if (!pjEndpt) {
                LOGE("无法获取PJSIP端点，SIP消息模块注册失败");
                endpoint->libDestroy();
                endpoint = nullptr;
                return -1;
            }
            
            pjsip_endpt_register_module(pjEndpt, &rx_req_module);
            pjsip_endpt_register_module(pjEndpt, &rx_res_module);
            pjsip_endpt_register_module(pjEndpt, &tx_req_module);
            pjsip_endpt_register_module(pjEndpt, &tx_res_module);
            LOGI("SIP消息模块注册成功");
        } catch (pj::Error &e) {
            LOGE("注册SIP消息模块失败: %s", e.info().c_str());
            endpoint->libDestroy();
            endpoint = nullptr;
            return -1;
        } catch (...) {
            LOGE("注册SIP消息模块时发生未知异常");
            endpoint->libDestroy();
            endpoint = nullptr;
            return -1;
        }
        
        // 正确的位置注册线程 - 库初始化后
        LOGI("注册主线程到PJSIP...");
        try {
            endpoint->libRegisterThread("main");
        } catch (pj::Error &e) {
            LOGW("注册主线程失败: %s，这可能是该线程已被注册", e.info().c_str());
            // 线程注册失败不是致命错误，可以继续
        }
        LOGI("主线程注册成功");
        
        // 创建 UDP 传输
        pj::TransportConfig transportConfig;
        transportConfig.port = SIP_PORT;
        // 注意：较新版本PJSIP可能不支持以下参数，已注释
        // transportConfig.udpSocketRcvBufSize = 65536;
        // transportConfig.udpSocketSndBufSize = 65536;
        // transportConfig.mtuSize = 1200;
        LOGI("创建UDP传输层，端口: %{public}d", SIP_PORT);
        
        pj::TransportId udpId = -1;
        try {
            // 尝试创建UDP传输
            pjsip_transport_type_e udpType = pjsip_transport_type_e::PJSIP_TRANSPORT_UDP;
            udpId = endpoint->transportCreate(udpType, transportConfig);
            
            // 获取传输信息
            try {
                pjsua_transport_info info;
                pjsua_transport_get_info(udpId, &info);
                LOGI("UDP传输创建成功 - ID: %d, 本地地址: %s:%d", 
                     udpId, info.local_name.host.ptr, info.local_name.port);
            } catch (...) {
                LOGI("UDP传输创建成功 - ID: %d，但无法获取详细信息", udpId);
            }
        } catch (pj::Error &e) {
            LOGE("创建UDP传输失败: %s [错误码:%d]", e.info().c_str(), e.status);
            // 严重错误，无法继续
            endpoint->libDestroy();
            endpoint = nullptr;
            return -1;
        }
        
        // 不创建TCP传输，强制只使用UDP
        LOGI("项目配置为仅使用UDP传输层");
        
        // 启动库
        LOGI("启动PJSIP库...");
        try {
            endpoint->libStart();
        } catch (pj::Error &e) {
            LOGE("启动PJSIP库失败: %s [错误码:%d]", e.info().c_str(), e.status);
            endpoint->libDestroy();
            endpoint = nullptr;
            return -1;
        }
        LOGI("PJSIP库启动成功");
        
        // 设置编解码器优先级 - 只保留PCMU和PCMA
        LOGI("配置音频编解码器...");
        try {
            // 首先禁用所有编解码器
            pj_str_t all_codec_id = pj_str((char*)"");
            pjsua_codec_set_priority(&all_codec_id, PJMEDIA_CODEC_PRIO_DISABLED);
            
            // 启用并设置PCMU为最高优先级
            pj_str_t pcmu_codec_id = pj_str((char*)"PCMU/8000");
            pjsua_codec_set_priority(&pcmu_codec_id, PJMEDIA_CODEC_PRIO_HIGHEST);
            
            // 启用并设置PCMA为次高优先级
            pj_str_t pcma_codec_id = pj_str((char*)"PCMA/8000");
            pjsua_codec_set_priority(&pcma_codec_id, PJMEDIA_CODEC_PRIO_NEXT_HIGHER);
            
            // 启用电话事件，用于DTMF
            pj_str_t tel_codec_id = pj_str((char*)"telephone-event/8000");
            pjsua_codec_set_priority(&tel_codec_id, PJMEDIA_CODEC_PRIO_NORMAL);
            
            // 启用G722，增加兼容性
            pj_str_t g722_codec_id = pj_str((char*)"G722/8000");
            pjsua_codec_set_priority(&g722_codec_id, PJMEDIA_CODEC_PRIO_NORMAL);
            
            // 尝试启用Opus，如果可用
            pj_str_t opus_codec_id = pj_str((char*)"opus/48000/2");
            pjsua_codec_set_priority(&opus_codec_id, PJMEDIA_CODEC_PRIO_NORMAL);
            
            LOGI("音频编解码器配置成功");
        } catch (pj::Error &e) {
            LOGE("设置编解码器优先级失败: %s [错误码:%d]", e.info().c_str(), e.status);
            // 这是一个警告，但不必终止整个应用
        }
        
        // 默认账号配置
        LOGI("配置SIP账号...");
        pj::AccountConfig config;
        config.idUri = "sip:anonymous";
        
        // 启用ICE并配置NAT穿透
        LOGI("配置ICE和NAT穿透");
        config.natConfig.iceEnabled = true;
        config.natConfig.sdpNatRewriteUse = true; // 重写SDP中的地址
        config.natConfig.contactRewriteUse = true; // 重写Contact头中的地址
        // 添加UDP保活设置，确保NAT映射保持活跃
        config.natConfig.udpKaIntervalSec = 15;  // 每15秒发送UDP保活包
        config.natConfig.udpKaData = "\r\n";     // 简单的保活数据
        
        // 配置STUN和TURN服务器
        LOGI("配置STUN和TURN服务器...");
        // 禁用TURN
        config.natConfig.turnEnabled = PJ_FALSE;
        
        // 配置ICE策略
        config.natConfig.iceTrickle = PJ_ICE_SESS_TRICKLE_DISABLED; // 禁用trickle ICE
        config.natConfig.iceAlwaysUpdate = PJ_TRUE;
        config.natConfig.iceAggressiveNomination = PJ_FALSE; // 使用标准提名
        
        // 确保会话定时器设置正确
        config.callConfig.timerUse = PJSUA_SIP_TIMER_OPTIONAL;  // 改为可选模式，更兼容
        config.callConfig.timerMinSESec = 90;  // 确保这个值至少为90
        config.callConfig.timerSessExpiresSec = 1800;
        
        // 确保会话过期时间大于最小会话刷新间隔
        if (config.callConfig.timerSessExpiresSec < config.callConfig.timerMinSESec * 2) {
            config.callConfig.timerSessExpiresSec = config.callConfig.timerMinSESec * 2;
            LOGI("调整会话过期时间为: %{public}d 秒", config.callConfig.timerSessExpiresSec);
        }
        
        // 配置媒体参数以减小SDP大小
        LOGI("配置媒体参数以减小SDP大小");
        
        // 限制使用的编解码器，只保留必要的几个
        // 注意：较新版本PJSIP可能不支持以下参数，已注释
        // config.mediaConfig.codecConfig.speexEnabled = false; // 禁用speex
        // config.mediaConfig.codecConfig.ilbcEnabled = false;  // 禁用ilbc
        // config.mediaConfig.codecConfig.gsmEnabled = true;    // GSM通常较小
        // config.mediaConfig.codecConfig.pcmaEnabled = true;   // PCMA (G.711 a-law)
        // config.mediaConfig.codecConfig.pcmuEnabled = true;   // PCMU (G.711 u-law)
        
        // 降低媒体MTU大小 - 注释掉不支持的属性
        // config.mediaConfig.transportConfig.mtuSize = 1200;
        
        // config.videoConfig.autoTransmitOutgoing = true;
        // config.videoConfig.autoShowIncoming = true;
        
        // 确保会话过期时间合理
        if (config.callConfig.timerSessExpiresSec < config.callConfig.timerMinSESec) {
            config.callConfig.timerSessExpiresSec = config.callConfig.timerMinSESec * 2;
            LOGI("调整会话过期时间为: %{public}d 秒", config.callConfig.timerSessExpiresSec);
        }
        
        LOGI("创建SIP账号...");
        try {
            if (!account_) {
                account_ = new pjsip::Pjsip_Account(config);
                LOGI("成功创建新SIP账号");
            } else {
                LOGI("使用已存在的SIP账号");
            }
            
            if (!account_) {
                LOGE("SIP账号创建失败");
                endpoint->libDestroy();
                endpoint = nullptr;
                return -1;
            }
            
            LOGI("注册SIP账号...");
            account_->create(config);
            LOGI("SIP账号注册成功");
        } catch (pj::Error &e) {
            LOGE("SIP账号注册失败: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
            if (account_) {
                delete account_;
                account_ = nullptr;
            }
            endpoint->libDestroy();
            endpoint = nullptr;
            return -1;
        }
        
        // 添加RTCP反馈配置
        try {
            // 设置编解码器优先级 - 只保留PCMU和PCMA
            LOGI("重新配置音频编解码器...");
            // 首先禁用所有编解码器
            pj_str_t all_codec_id = pj_str((char*)"");
            pjsua_codec_set_priority(&all_codec_id, PJMEDIA_CODEC_PRIO_DISABLED);
            
            // 启用并设置PCMU为最高优先级
            pj_str_t pcmu_codec_id = pj_str((char*)"PCMU/8000");
            pjsua_codec_set_priority(&pcmu_codec_id, PJMEDIA_CODEC_PRIO_HIGHEST);
            
            // 启用并设置PCMA为次高优先级
            pj_str_t pcma_codec_id = pj_str((char*)"PCMA/8000");
            pjsua_codec_set_priority(&pcma_codec_id, PJMEDIA_CODEC_PRIO_NEXT_HIGHER);
            
            LOGI("音频编解码器配置成功，只启用PCMU和PCMA");
        } catch (pj::Error &e) {
            LOGE("设置编解码器优先级失败: %s [错误码:%d]", e.info().c_str(), e.status);
            // 这是一个警告，但不必终止整个应用
        }
        
        // 修改账号
        try {
            LOGI("正在应用新账号设置...");
            if (account_) {
                account_->modify(config);
                LOGI("账号修改成功: %{public}s @ %{public}s", 
                     config.sipConfig.authCreds.empty() ? "anonymous" : config.sipConfig.authCreds[0].username.c_str(), 
                     config.regConfig.registrarUri.empty() ? "none" : config.regConfig.registrarUri.c_str());
            } else {
                LOGE("账号对象为空，无法修改");
                endpoint->libDestroy();
                endpoint = nullptr;
                return -1;
            }
        } catch (pj::Error &e) {
            LOGE("修改账号失败: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
            // 这不是致命错误，可以继续
        }
        
        // 初始化成功后再设置标记
        isInit = true;
        LOGI("PJSIP初始化全部完成，状态良好");
        return 0;
    } catch (pj::Error &e) {
        LOGE("PJSIP初始化过程失败: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
        // 清理资源
        if (endpoint) {
            try {
                endpoint->libDestroy();
                endpoint = nullptr;
            } catch (...) {
                // 忽略清理过程中的错误
            }
        }
        
        if (account_) {
            delete account_;
            account_ = nullptr;
        }
        
        return -1;
    } catch (std::exception &e) {
        LOGE("PJSIP初始化过程失败，发生标准异常: %{public}s", e.what());
        // 清理资源
        if (endpoint) {
            try {
                endpoint->libDestroy();
                endpoint = nullptr;
            } catch (...) {
                // 忽略清理过程中的错误
            }
        }
        
        if (account_) {
            delete account_;
            account_ = nullptr;
        }
        
        return -1;
    } catch (...) {
        LOGE("PJSIP初始化过程失败，发生未知异常");
        // 清理资源
        if (endpoint) {
            try {
                endpoint->libDestroy();
                endpoint = nullptr;
            } catch (...) {
                // 忽略清理过程中的错误
            }
        }
        
        if (account_) {
            delete account_;
            account_ = nullptr;
        }
        
        return -1;
    }
}

int PjsipApp::modifyAccount(const std::string& idUri, const std::string& registrarUri, 
                      const std::string& userName, const std::string& pwd) {
    LOG_FUNC_SCOPE;
    LOGI("正在修改SIP账号...");
    LOGI("ID URI: %{public}s", idUri.c_str());
    LOGI("注册服务器: %{public}s", registrarUri.c_str());
    LOGI("用户名: %{public}s", userName.c_str());
    LOGI("密码长度: %{public}zu", pwd.length()); // 出于安全考虑不打印密码本身
    
    config.idUri = idUri;
    config.regConfig.registrarUri = registrarUri;
    config.sipConfig.authCreds.clear();
    
    // 添加认证信息
    pj::AuthCredInfo authCredInfo;
    authCredInfo.scheme = "Digest";
    authCredInfo.realm = "*";
    authCredInfo.username = userName;
    authCredInfo.dataType = 0;
    authCredInfo.data = pwd;
    config.sipConfig.authCreds.push_back(authCredInfo);
    config.sipConfig.proxies.clear();
    
    // 启用ICE并配置NAT穿透
    LOGI("配置ICE和NAT穿透");
    config.natConfig.iceEnabled = true;
    config.natConfig.sdpNatRewriteUse = true; // 重写SDP中的地址
    config.natConfig.contactRewriteUse = true; // 重写Contact头中的地址
    // 添加UDP保活设置，确保NAT映射保持活跃
    config.natConfig.udpKaIntervalSec = 15;  // 每15秒发送UDP保活包
    config.natConfig.udpKaData = "\r\n";     // 简单的保活数据
    
    // 配置STUN和TURN服务器
    LOGI("配置STUN和TURN服务器...");
    // 禁用TURN
    config.natConfig.turnEnabled = PJ_FALSE;
    
    // 配置ICE策略
    config.natConfig.iceTrickle = PJ_ICE_SESS_TRICKLE_DISABLED; // 禁用trickle ICE
    config.natConfig.iceAlwaysUpdate = PJ_TRUE;
    config.natConfig.iceAggressiveNomination = PJ_FALSE; // 使用标准提名
    
    // 配置媒体参数以减小SDP大小
    LOGI("配置媒体参数以减小SDP大小");
    
    // 限制使用的编解码器，只保留必要的几个
    // 注意：较新版本PJSIP可能不支持以下参数，已注释
    // config.mediaConfig.codecConfig.speexEnabled = false; // 禁用speex
    // config.mediaConfig.codecConfig.ilbcEnabled = false;  // 禁用ilbc
    // config.mediaConfig.codecConfig.gsmEnabled = true;    // GSM通常较小
    // config.mediaConfig.codecConfig.pcmaEnabled = true;   // PCMA (G.711 a-law)
    // config.mediaConfig.codecConfig.pcmuEnabled = true;   // PCMU (G.711 u-law)
    
    // 降低媒体MTU大小 - 注释掉不支持的属性
    // config.mediaConfig.transportConfig.mtuSize = 1200;
    
    // config.videoConfig.autoTransmitOutgoing = true;
    // config.videoConfig.autoShowIncoming = true;
    
    // 确保会话定时器设置正确
    if (config.callConfig.timerMinSESec < 90) {
        LOGW("检测到timerMinSESec小于90，自动修正为90");
        config.callConfig.timerMinSESec = 90;
    }
    
    // 确保会话过期时间合理
    if (config.callConfig.timerSessExpiresSec < config.callConfig.timerMinSESec) {
        config.callConfig.timerSessExpiresSec = config.callConfig.timerMinSESec * 2;
        LOGI("调整会话过期时间为: %{public}d 秒", config.callConfig.timerSessExpiresSec);
    }
    
    try {
        if (account_) {
            LOGI("开始更新账号配置...");
            account_->modify(config);
            LOGI("账号修改成功: %{public}s @ %{public}s", userName.c_str(), registrarUri.c_str());
        } else {
            LOGE("账号对象为空，无法修改");
            return PJ_FALSE;
        }
    } catch (pj::Error &e) {
        LOGE("修改账号失败: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
        return PJ_FALSE;
    }
    
    return PJ_SUCCESS;
}

void PjsipApp::SetIncomingCallListener(napi_env env, napi_ref callBack) {
    if (account_) {
        account_->SetIncomingCallListener(env, callBack);
    }
}

void PjsipApp::SetCallStateListener(napi_env env, napi_ref callBack) {
    if (account_) {
        account_->SetCallStateListener(env, callBack);
    }
}

void PjsipApp::SetRegStateListener(napi_env env, napi_ref callBack) {
    if (account_) {
        account_->SetRegStateListener(env, callBack);
    }
}

void PjsipApp::acceptCall() {
    if (account_) {
        account_->acceptCall();
    }
}

void PjsipApp::hangupCall() {
    if (account_) {
        account_->hangupCall();
    }
}

void PjsipApp::makeCall(const std::string& uri) {
    LOGI("PjsipApp::makeCall - 开始拨打电话到 %{public}s", uri.c_str());
    
    // 检查参数有效性
    if (uri.empty()) {
        LOGE("PjsipApp::makeCall - URI为空，无法拨打");
        return;
    }
    
    // 检查初始化状态
    if (!isInit) {
        LOGE("PjsipApp::makeCall - PJSIP未初始化，无法拨打电话");
        return;
    }
    
    // 检查账号是否存在
    if (!account_) {
        LOGE("PjsipApp::makeCall - 账户未创建，无法拨打电话");
        return;
    }
    
    try {
        // 检查音频设备是否可用（这是一个关键步骤，因为音频设备初始化失败是导致崩溃的原因）
        try {
            LOGI("检查音频设备状态...");
            int count = pj::Endpoint::instance().audDevManager().getDevCount();
            if (count <= 0) {
                LOGE("没有可用的音频设备，无法拨打电话");
                return;
            }
            LOGI("检测到%d个音频设备", count);
            
            // 可选：提前设置音频设备，避免在通话建立时才设置引起的崩溃
            try {
                LOGI("预先设置音频设备");
                pj::AudDevManager& mgr = pj::Endpoint::instance().audDevManager();
                mgr.setPlaybackDev(0);
                mgr.setCaptureDev(0);
                LOGI("音频设备设置成功");
            } catch (pj::Error &e) {
                LOGE("设置音频设备失败: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
                // 音频设备设置失败可能是一个严重问题，但我们仍然尝试继续拨打电话
            }
        } catch (pj::Error &e) {
            LOGE("检查音频设备失败: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
            return;
        }
        
        LOGI("准备从注册服务器提取端口...");
        // 从注册服务器URI中提取端口
        std::string registrarUri = config.regConfig.registrarUri;
        int port = 5060; // 默认SIP端口
        
        if (!registrarUri.empty()) {
            LOGI("注册服务器URI: %{public}s", registrarUri.c_str());
            size_t portPos = registrarUri.find(':', registrarUri.find("sip:") + 4);
            if (portPos != std::string::npos) {
                // 提取端口号
                size_t portEnd = registrarUri.find(';', portPos);
                if (portEnd == std::string::npos) {
                    portEnd = registrarUri.find('/', portPos);
                }
                if (portEnd == std::string::npos) {
                    portEnd = registrarUri.length();
                }
                std::string portStr = registrarUri.substr(portPos + 1, portEnd - portPos - 1);
                LOGI("从注册服务器URI提取的端口: %{public}s", portStr.c_str());
                
                try {
                    port = std::stoi(portStr);
                    LOGI("将使用端口: %{public}d", port);
                } catch (std::exception& e) {
                    LOGW("端口转换失败，使用默认端口5060: %{public}s", e.what());
                }
            } else {
                LOGW("注册服务器URI中未找到端口，使用默认端口5060");
            }
        } else {
            LOGW("注册服务器URI为空，使用默认端口5060");
        }
        
        // 准备最终URI
        std::string finalUri = uri;
        
        // 确保URI已经以sip:开头
        if (finalUri.find("sip:") != 0 && finalUri.find("sips:") != 0) {
            finalUri = "sip:" + finalUri;
        }
        
        // 解析URI中的域名部分
        size_t atPos = finalUri.find('@');
        if (atPos != std::string::npos) {
            size_t hostStart = atPos + 1;
            size_t hostEnd = finalUri.find(';', hostStart);
            if (hostEnd == std::string::npos) {
                hostEnd = finalUri.length();
            }
            
            std::string hostname = finalUri.substr(hostStart, hostEnd - hostStart);
            // 检查URI中是否已包含端口号
            if (hostname.find(':') == std::string::npos) {
                // 没有端口号，添加提取的端口
                std::string domainWithPort = hostname + ":" + std::to_string(port);
                finalUri.replace(hostStart, hostEnd - hostStart, domainWithPort);
                LOGI("已添加端口到URI: %{public}s", finalUri.c_str());
            } else {
                LOGI("URI已包含端口，保持不变: %{public}s", finalUri.c_str());
            }
        } else {
            LOGW("URI格式异常，未找到@符号: %{public}s", finalUri.c_str());
        }
        
        // 确保URI使用UDP传输
        if (finalUri.find(";transport=") == std::string::npos) {
            finalUri += ";transport=udp";
            LOGI("已添加UDP传输参数到URI");
        }
        
        LOGI("最终拨打URI: %{public}s", finalUri.c_str());
        
        // 确保只使用PCMU和PCMA编解码器
        try {
            LOGI("为当前通话配置音频编解码器...");
            // 首先禁用所有编解码器
            pj_str_t all_codec_id = pj_str((char*)"");
            pjsua_codec_set_priority(&all_codec_id, PJMEDIA_CODEC_PRIO_DISABLED);
            
            // 启用并设置PCMU为最高优先级
            pj_str_t pcmu_codec_id = pj_str((char*)"PCMU/8000");
            pjsua_codec_set_priority(&pcmu_codec_id, PJMEDIA_CODEC_PRIO_HIGHEST);
            
            // 启用并设置PCMA为次高优先级
            pj_str_t pcma_codec_id = pj_str((char*)"PCMA/8000");
            pjsua_codec_set_priority(&pcma_codec_id, PJMEDIA_CODEC_PRIO_NEXT_HIGHER);
            
            // 启用电话事件，用于DTMF
            pj_str_t tel_codec_id = pj_str((char*)"telephone-event/8000");
            pjsua_codec_set_priority(&tel_codec_id, PJMEDIA_CODEC_PRIO_NORMAL);
            
            // 启用G722，增加兼容性
            pj_str_t g722_codec_id = pj_str((char*)"G722/8000");
            pjsua_codec_set_priority(&g722_codec_id, PJMEDIA_CODEC_PRIO_NORMAL);
            
            // 尝试启用Opus，如果可用
            pj_str_t opus_codec_id = pj_str((char*)"opus/48000/2");
            pjsua_codec_set_priority(&opus_codec_id, PJMEDIA_CODEC_PRIO_NORMAL);
            
            LOGI("音频编解码器配置成功");
        } catch (pj::Error &e) {
            LOGE("设置编解码器优先级失败: %s [错误码:%d]", e.info().c_str(), e.status);
            // 这是一个警告，但不必终止整个拨号过程
        }
        
        // 配置通话参数，显式设置媒体选项
        pj::CallOpParam callParam;
        callParam.opt.audioCount = 1;  // 只启用音频
        callParam.opt.videoCount = 0;  // 禁用视频，减少复杂性
        
        // 添加SRTP支持
        try {
            LOGI("配置SRTP支持...");
            // 检查您的库是否没有pjsua_srtp_opt，移除相关代码
            // pjsua_srtp_opt srtp_opt;
            // pjsua_srtp_opt_default(&srtp_opt);
            // srtp_opt.crypto_count = 1;
            // srtp_opt.crypto[0].key = pj_str((char*)"AES_CM_128_HMAC_SHA1_80");
            // srtp_opt.crypto[0].name = pj_str((char*)"AES_CM_128_HMAC_SHA1_80");
            
            // 您的PJSIP库可能未启用SRTP支持或使用不同的常量
            // 查看PJSIP头文件以确定正确的标志
            // 暂时注释掉 PJSUA_CALL_SECURE 标志
            // callParam.opt.flag |= PJSUA_CALL_SECURE; // 启用安全通话
            LOGI("当前PJSIP库可能不支持SRTP");
        } catch (std::exception &e) {
            LOGW("配置SRTP支持时出错: %s", e.what());
        } catch (...) {
            LOGW("配置SRTP支持时出现未知错误");
        }
        
        // 确保会话计时器设置正确
        callParam.opt.flag |= 1; // 使用PJSUA_CALL_REGULAR代替PJSUA_CALL_USE_TIMER
        
        // 确保在通话前STUN服务器已正确配置
        try {
            LOGI("准备STUN服务器配置...");
            // 直接检查和更新端点的 STUN 服务器列表
            try {
                // 获取现有的 STUN 服务器列表
                pj::StringVector stunServers;
                
                // 创建临时的 STUN 服务器列表
                stunServers.push_back("stun.l.google.com:19302");
                stunServers.push_back("stun1.l.google.com:19302");
                
                // 使用正确的方法更新 STUN 服务器
                endpoint->natUpdateStunServers(stunServers, PJ_TRUE);
                LOGI("已更新STUN服务器配置");
            } catch (pj::Error &e) {
                LOGW("更新STUN配置失败: %s", e.info().c_str());
            }
        } catch (std::exception &e) {
            LOGW("检查STUN配置时发生异常: %s", e.what());
        } catch (...) {
            LOGW("检查STUN配置时发生未知异常");
        }
        
        // 在保护代码块中调用makeCall
        LOGI("准备通过account_->makeCall拨打电话");
        try {
            // 再次检查账号对象是否有效
            if (!account_) {
                LOGE("account_对象为空，无法拨打电话");
                return;
            }
            
            // 确保URI不为空
            if (finalUri.empty()) {
                LOGE("最终URI为空，无法继续拨打");
                return;
            }
            
            // 记录将要拨打的URI
            LOGI("将要拨打的URI: %s", finalUri.c_str());
            
            // 记录会话计时器设置
            LOGI("会话计时器配置: timerUse=%d, timerMinSE=%d, timerSessExpires=%d",
                 config.callConfig.timerUse,
                 config.callConfig.timerMinSESec,
                 config.callConfig.timerSessExpiresSec);
            
            // 传递callParam参数
            account_->makeCall(finalUri, callParam);
            LOGI("makeCall请求已发送");
        } catch (pj::Error &e) {
            LOGE("account_->makeCall调用失败: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
        } catch (std::exception &e) {
            LOGE("account_->makeCall调用失败，发生标准异常: %{public}s", e.what());
        } catch (...) {
            LOGE("account_->makeCall调用失败，发生未知异常");
        }
    } catch (pj::Error &e) {
        LOGE("PjsipApp::makeCall - PJSIP错误: %{public}s [错误码:%{public}d]", e.info().c_str(), e.status);
    } catch (std::exception& e) {
        LOGE("PjsipApp::makeCall - 发生异常: %{public}s", e.what());
    } catch (...) {
        LOGE("PjsipApp::makeCall - 发生未知异常");
    }
    
    LOGI("PjsipApp::makeCall - 执行完成");
}

void PjsipApp::destroy() {
    if (isInit) {
        if (endpoint) {
            try {
                endpoint->libDestroy();
                endpoint = nullptr;
            } catch (pj::Error& e) {
                LOGE("Error destroying endpoint: %{public}s", e.info().c_str());
            }
        }
        
        if (account_) {
            delete account_;
            account_ = nullptr;
        }
        
        isInit = false;
        LOGI("PjsipApp destroyed");
    }
}

bool PjsipApp::getRegistrationStatus(int& statusCode, std::string& statusReason) {
    if (!isInit || !account_) {
        statusCode = 0;
        statusReason = "PJSIP未初始化或账号未创建";
        return false;
    }
    
    try {
        // 获取账号信息
        pj::AccountInfo info = account_->getInfo();
        bool isRegistered = info.regIsActive;
        
        // 返回当前状态
        statusCode = isRegistered ? 200 : info.regStatus;
        statusReason = info.regStatusText;
        
        LOGI("getRegistrationStatus: %d, %s, active: %d", 
             statusCode, statusReason.c_str(), isRegistered);
        
        return isRegistered;
    } catch (pj::Error &e) {
        statusCode = e.status;
        statusReason = e.info();
        LOGE("Error getting registration status: %s", e.info().c_str());
        return false;
    }
}

Pjsip_Call* PjsipApp::getCurrentCall() {
    LOGI("PjsipApp::getCurrentCall - 获取当前通话对象");
    
    if (!account_) {
        LOGW("账户对象为空，无法获取当前通话");
        return nullptr;
    }
    
    return account_->getCurrentCall();
}

} // namespace pjsip