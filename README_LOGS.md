# PJSIP日志工具使用指南

本文档介绍了如何使用和查看PJSIP应用程序的日志。

## 日志系统概述

PJSIP应用程序使用HarmonyOS的日志系统（HiLog）记录各种级别的日志，包括：

- **DEBUG**：详细的调试信息
- **INFO**：普通信息性消息
- **WARN**：警告信息
- **ERROR**：错误信息
- **FATAL**：致命错误信息

所有日志都使用`PJSIP_CPP`标签，域ID为`0xD002000`。

## 在应用中测试日志

1. 打开应用程序
2. 点击界面底部的"测试C++日志"按钮
3. 应用将生成各种级别和格式的测试日志

## 使用日志查看脚本

项目根目录下提供了一个日志查看脚本`view_logs.sh`，使用前需要授予执行权限：

```bash
chmod +x view_logs.sh
```

### 基本用法

```bash
./view_logs.sh [选项] [过滤条件]
```

### 选项

- `-h, --help`：显示帮助信息
- `-a, --all`：查看所有级别的日志
- `-i, --info`：只查看INFO级别日志（默认）
- `-e, --error`：只查看ERROR级别日志
- `-w, --warn`：只查看WARN级别日志
- `-f, --follow`：实时跟踪日志（默认）
- `-c, --count N`：显示最近N行日志

### 示例

```bash
# 实时查看所有PJSIP相关的INFO日志
./view_logs.sh

# 实时查看所有级别的PJSIP日志
./view_logs.sh -a

# 查看最近100行ERROR日志
./view_logs.sh -e -c 100

# 使用自定义过滤条件（查看包含"网络"的日志）
./view_logs.sh 网络
```

## 直接使用hilog命令

如果需要更精细的控制，可以直接使用HarmonyOS的`hilog`命令：

```bash
# 通过hdc连接设备并执行hilog命令
hdc shell "hilog -w -l INFO | grep -i 'PJSIP'"
```

常用hilog参数：
- `-w`：实时查看日志（类似tail -f）
- `-r`：查看已缓存的日志
- `-x`：显示详细信息
- `-l LEVEL`：指定日志级别（DEBUG/INFO/WARN/ERROR/FATAL）

## 日志分析提示

1. 注册状态相关日志通常包含"注册状态"或"Registration"关键词
2. 通话状态相关日志包含"通话状态"或"Call state"关键词
3. 网络相关日志包含"网络"或"Network"关键词
4. 以"[ENTER]"和"[EXIT]"开头的日志表示函数进入和退出

## 常见问题排查

1. **看不到日志**：确保设备已连接且授予了应用读写日志的权限
2. **日志过多难以查找**：使用具体的过滤条件，如`./view_logs.sh 注册状态`
3. **日志不全面**：尝试使用`-a`选项查看所有级别的日志

## 日志辅助函数

开发者可以使用以下文件中的辅助函数增强日志记录：

- `log_writer.h`：基本日志记录
- `network_logger.h`：网络和SIP相关的日志记录 