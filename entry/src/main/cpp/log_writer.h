//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef LOG_WRITER_H
#define LOG_WRITER_H

#include <pjsua2.hpp>
#include <hilog/log.h>
#include <string>

// 日志域和标签定义 - 使用0x00前缀避免与系统定义冲突
#define LOG_DOMAIN 0x00D002
#define LOG_TAG "PJSIP_CPP"

// 只使用OH_LOG_Print函数的标准宏定义 - 这在HarmonyOS中是可用的
#define LOGI(...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))
#define LOGD(...) ((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))
#define LOGE(...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))
#define LOGW(...) ((void)OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))
#define LOGF(...) ((void)OH_LOG_Print(LOG_APP, LOG_FATAL, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))

// 为字符串参数添加public标记的辅助宏
#define LOG_STR(str) "%{public}s", (str)
#define LOG_INT(num) "%{public}d", (num)

class PJSIP_Writer : public pj::LogWriter {
public:
    void write(const pj::LogEntry &entry) override {
        std::string log = entry.threadName + " " + std::to_string(entry.threadId) + " " + entry.msg;
        
        switch (entry.level) {
        case 1:
            LOGE(LOG_STR(log.c_str()));
            break;
        case 2:
            LOGW(LOG_STR(log.c_str()));
            break;
        case 3:
            LOGI(LOG_STR(log.c_str()));
            break;
        default:
            LOGD(LOG_STR(log.c_str()));
            break;
        }
    }
};

// 日志辅助函数，用于记录函数进入和退出
class ScopeLogger {
private:
    std::string funcName_;
public:
    ScopeLogger(const std::string& funcName) : funcName_(funcName) {
        LOGI("[ENTER] %{public}s", funcName_.c_str());
    }
    
    ~ScopeLogger() {
        LOGI("[EXIT] %{public}s", funcName_.c_str());
    }
};

// 在函数开始处使用此宏可以自动记录函数进入和退出
#define LOG_FUNC_SCOPE ScopeLogger scopeLogger(__FUNCTION__)

#endif // LOG_WRITER_H 