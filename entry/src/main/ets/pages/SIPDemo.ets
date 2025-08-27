import libEntry from 'libentry.so'
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';

const permissions: Array<Permissions> =
  ['ohos.permission.INTERNET', 'ohos.permission.MICROPHONE'];

// 定义日志域和TAG
const DOMAIN_CODE = 0xD002;
const TAG = 'PJSIP_JS';

@Entry
@Component
struct SIPDemo {
  @State sipInitialized: boolean = false
  @State registrationStatus: string = '未注册'
  @State callStatus: string = '空闲'
  @State incomingCallFrom: string = ''
  @State hasIncomingCall: boolean = false
  // SIP服务器配置
  @State server: string = '36.158.249.23:5034'
  @State username: string = '506397'
  @State password: string = 'MYaglT1evB43pFN0AN'
  // 呼叫目标
  @State callDestination: string = '13696594262'

  // 初始化PJSIP
  initPJSIP() {
    try {
      // 直接调用函数，不使用类
      const result = libEntry.initPjsip()
      if (result === 0) {
        this.sipInitialized = true
        console.info('PJSIP初始化成功')

        // 添加注册状态监听
        libEntry.addRegStateListener((status: number, reason: string) => {
          console.info(`注册状态: ${status}, 原因: ${reason}`)
          if (status === 200) {
            this.registrationStatus = '已注册'
          } else {
            this.registrationStatus = `注册失败: ${reason}`
          }
        })

        // 添加通话状态监听
        libEntry.addCallStateListener((status: number) => {
          // 使用console.info和hilog双重记录，确保日志可见
          console.info(`通话状态: ${status}`)

          // 使用hilog记录通话状态，这会直接记录到系统日志
          hilog.info(DOMAIN_CODE, TAG, `收到通话状态变化: ${status}`)

          // 转换状态到更易读的形式
          let stateDesc = '';
          switch (status) {
            case 0: stateDesc = 'NULL (空闲)'; break;
            case 1: stateDesc = 'CALLING (呼叫中)'; break;
            case 2: stateDesc = 'INCOMING (来电)'; break;
            case 3: stateDesc = 'EARLY (早期媒体)'; break;
            case 4: stateDesc = 'CONNECTING (连接中)'; break;
            case 5: stateDesc = 'CONFIRMED (通话中)'; break;
            case 6: stateDesc = 'DISCONNECTED (已断开)'; break;
            default: stateDesc = '未知状态'; break;
          }

          hilog.info(DOMAIN_CODE, TAG, `通话状态描述: ${stateDesc}`)

          // 根据状态码更新UI
          switch (status) {
            case 0: // PJSIP_INV_STATE_NULL
              this.callStatus = '空闲'
              this.hasIncomingCall = false
              break
            case 1: // PJSIP_INV_STATE_CALLING
              this.callStatus = '呼叫中'
              break
            case 2: // PJSIP_INV_STATE_INCOMING
              this.callStatus = '来电'
              this.hasIncomingCall = true
              break
            case 3: // PJSIP_INV_STATE_EARLY
              this.callStatus = '早期媒体'
              break
            case 4: // PJSIP_INV_STATE_CONNECTING
              this.callStatus = '正在连接'
              break
            case 5: // PJSIP_INV_STATE_CONFIRMED
              this.callStatus = '通话中'
              this.hasIncomingCall = false
              break
            case 6: // PJSIP_INV_STATE_DISCONNECTED
              this.callStatus = '已断开'
              this.hasIncomingCall = false
              break
            default:
              this.callStatus = `未知状态: ${status}`
              break
          }

          // 记录UI更新
          hilog.info(DOMAIN_CODE, TAG, `通话状态UI已更新为: ${this.callStatus}`)
        })

        // 添加来电监听
        libEntry.addIncomingCallListener((from: string) => {
          console.info(`来电: ${from}`)
          this.incomingCallFrom = from
          this.hasIncomingCall = true
        })

        // 初始化时不自动注册，等待用户点击注册按钮
        console.info('PJSIP初始化完成，等待注册')
      } else {
        console.error('PJSIP初始化失败')
      }
    } catch (error) {
      console.error(`PJSIP错误: ${error}`)
    }
  }

  // 注册SIP账号
  registerAccount() {
    try {
      this.registrationStatus = '注册中...'
      // 调用修改账号接口进行注册
      const modifyResult = libEntry.modifyAccount(this.server, this.username, this.password)
      if (modifyResult === 0) {
        console.info('账号注册请求已发送')
        // 注册状态将通过回调更新
      } else {
        console.error('账号注册请求失败')
        this.registrationStatus = '注册失败'
      }
    } catch (error) {
      console.error(`账号注册错误: ${error}`)
      this.registrationStatus = `注册错误: ${error}`
    }
  }

  // 拨打电话
  makeCall() {
    try {
      // 直接传入电话号码，不需要构建SIP URI
      libEntry.makeCall(this.callDestination)
      console.info(`正在拨打: ${this.callDestination}`)
    } catch (error) {
      console.error(`拨打电话错误: ${error}`)
    }
  }

  // 接听电话
  acceptCall() {
    try {
      libEntry.acceptCall()
      console.info('接听来电')
      this.hasIncomingCall = false
    } catch (error) {
      console.error(`接听电话错误: ${error}`)
    }
  }

  // 挂断电话
  hangupCall() {
    try {
      libEntry.hangupCall()
      console.info('挂断电话')
    } catch (error) {
      console.error(`挂断电话错误: ${error}`)
    }
  }

  // 销毁PJSIP
  destroyPJSIP() {
    try {
      libEntry.destroy()
      this.sipInitialized = false
      this.registrationStatus = '未注册'
      console.info('PJSIP已销毁')
    } catch (error) {
      console.error(`销毁PJSIP错误: ${error}`)
    }
  }

  aboutToAppear() {

    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    this.reqPermissionsFromUser(permissions, context);
    // 页面出现时自动初始化
    // this.initPJSIP()
  }

  async reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext) {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let isPermission = false;
    let result = await atManager.requestPermissionsFromUser(context, permissions);
    let grantStatus: Array<number> = result.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      if (grantStatus[i] === 0) {
        isPermission = true;
      } else {
        isPermission = false;
      }
    }
    if (isPermission) {
      this.initPJSIP();
    } else {
      this.registrationStatus = "pjsip 初始化失败，请授予相关权限"
    }
  }

  aboutToDisappear() {
    // 页面消失时销毁
    this.destroyPJSIP()
  }

  build() {
    Column() {
      Text('PJSIP演示').fontSize(24).fontWeight(FontWeight.Bold).margin({ top: 20, bottom: 20 })

      // 状态显示
      Column() {
        Text('PJSIP状态: ' + (this.sipInitialized ? '已初始化' : '未初始化')).margin(5)
        Text('注册状态: ' + this.registrationStatus).margin(5)
        Text('通话状态: ' + this.callStatus).margin(5)

      }
      .width('100%')
      .padding(10)
      .backgroundColor('#f5f5f5')
      .borderRadius(8)
      .margin({ bottom: 20 })

      // 配置信息
      Column() {
        Text('配置信息').fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 10 })

        Row() {
          Text('服务器:').width('30%')
          TextInput({ text: this.server })
            .onChange((value) => {
              this.server = value
            })
            .width('70%')
        }.width('100%').margin({ bottom: 10 })

        Row() {
          Text('用户名:').width('30%')
          TextInput({ text: this.username })
            .onChange((value) => {
              this.username = value
            })
            .width('70%')
        }.width('100%').margin({ bottom: 10 })

        Row() {
          Text('密码:').width('30%')
          TextInput({ text: this.password })
            .type(InputType.Password)
            .onChange((value) => {
              this.password = value
            })
            .width('70%')
        }.width('100%').margin({ bottom: 10 })

        // 也保留这里的注册按钮，样式更明显
        Button('更新账号并注册')
          .onClick(() => this.registerAccount())
          .width('100%')
          .height(50)
          .margin({ top: 10 })
          .backgroundColor('#2196F3')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#f5f5f5')
      .borderRadius(8)
      .margin({ bottom: 20 })

      // 拨号部分
      Column() {
        Text('拨号').fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 10 })

        Row() {
          Text('号码:').width('30%')
          TextInput({ text: this.callDestination })
            .onChange((value) => {
              this.callDestination = value
            })
            .width('70%')
        }.width('100%').margin({ bottom: 10 })

        Button('拨打电话')
          .onClick(() => this.makeCall())
          .width('100%')
          .margin({ bottom: 10 })
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#f5f5f5')
      .borderRadius(8)
      .margin({ bottom: 20 })

      // 通话控制按钮
      Row() {
        Button('挂断')
          .onClick(() => this.hangupCall())
          .width('40%')
          .backgroundColor('#f44336')

        if (this.hasIncomingCall) {
          Button('接听')
            .onClick(() => this.acceptCall())
            .width('40%')
            .backgroundColor('#4caf50')
            .margin({ left: 20 })
        }
      }.width('100%').justifyContent(FlexAlign.Center).margin({ bottom: 20 })

      // 来电显示
      if (this.hasIncomingCall) {
        Column() {
          Text('来电信息').fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 10 })
          Text('来电号码: ' + this.incomingCallFrom).margin(5)
        }
        .width('100%')
        .padding(10)
        .backgroundColor('#ffeb3b')
        .borderRadius(8)
        .margin({ bottom: 20 })
      }

      // 控制按钮
      Row() {
        Button('重新初始化')
          .onClick(() => {
            this.destroyPJSIP()
            this.initPJSIP()
          })
          .width('45%')

        Button('销毁')
          .onClick(() => this.destroyPJSIP())
          .width('45%')
          .margin({ left: 10 })
      }.width('100%').justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
} 