//
// Created on 2025/4/21.
//

#ifndef NETWORK_LOGGER_H
#define NETWORK_LOGGER_H

#include "log_writer.h"
#include <string>
#include <sstream>
#include <vector>
#include <iomanip>

namespace logging {

// 将字节数组转为十六进制字符串
inline std::string bytesToHex(const uint8_t* data, size_t length) {
    std::stringstream ss;
    ss << std::hex << std::setfill('0');
    
    for (size_t i = 0; i < length; ++i) {
        ss << std::setw(2) << static_cast<int>(data[i]);
        if ((i + 1) % 16 == 0 && i != length - 1) {
            ss << '\n';
        } else if (i != length - 1) {
            ss << ' ';
        }
    }
    
    return ss.str();
}

// 记录SIP消息
inline void logSipMessage(const std::string& direction, const std::string& message) {
    LOGI("SIP %{public}s:\n%{public}s", direction.c_str(), message.c_str());
}

// 记录网络包数据
inline void logNetworkPacket(const std::string& direction, const uint8_t* data, size_t length) {
    std::string hexData = bytesToHex(data, length);
    LOGI("网络数据 %{public}s (%{public}zu 字节):\n%{public}s", 
        direction.c_str(), length, hexData.c_str());
}

// 记录网络事件
inline void logNetworkEvent(const std::string& event, const std::string& details) {
    LOGI("网络事件: %{public}s - %{public}s", event.c_str(), details.c_str());
}

// 记录音频流统计信息
inline void logAudioStats(int packetsSent, int packetsLost, double jitter, double latency) {
    LOGI("音频统计: 已发送=%{public}d, 丢包=%{public}d, 抖动=%{public}f ms, 延迟=%{public}f ms",
        packetsSent, packetsLost, jitter, latency);
}

// 记录注册状态变化
inline void logRegistrationChange(int statusCode, const std::string& reason) {
    if (statusCode == 200) {
        LOGI("SIP注册成功 (状态码: %{public}d)", statusCode);
    } else {
        LOGW("SIP注册状态变更: 状态码=%{public}d, 原因=%{public}s", statusCode, reason.c_str());
    }
}

// 记录呼叫状态变化
inline void logCallStateChange(int oldState, int newState, const std::string& stateStr) {
    LOGI("呼叫状态变更: %{public}d -> %{public}d (%{public}s)", 
        oldState, newState, stateStr.c_str());
}

} // namespace logging

#endif // NETWORK_LOGGER_H 