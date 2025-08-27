//
// Created on 2025/3/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "napi/native_api.h"
#include <cstdint>
#include <functional>

#ifndef PJSIP_LISTENER_H
#define PJSIP_LISTENER_H

namespace pjsip {
class Pjsip_Listener {
public:
    virtual ~Pjsip_Listener() = default;
    virtual void onCallStateChange(int32_t status){};
    virtual void onCallMediaEvent(int32_t mid){};
    virtual void onRegState(int32_t status, const std::string &reason){};
};
} // namespace pjsip

#endif // PJSIP_LISTENER_H 