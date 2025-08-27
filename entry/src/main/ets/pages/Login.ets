import * as api from '../api/login'
import { login_form, login_result, login_result_data, SeatInfo, send_code_form, webview_params } from '../models/login'
import { AppStorageV2, LoadingDialog, PersistenceV2, promptAction, router } from '@kit.ArkUI'
import { CONFIG, LOGIN_INFO, SIP_DATA, TOKEN_HEADER_KEY, TOKEN_INFO, TOKEN_KEY, USER_INFO } from '../constants'
import { deviceInfo } from '@kit.BasicServicesKit';

import {
  config_form,
  config_result,
  config_result_data,
  permissions_form,
  permissions_result,
  permissions_result_data,
  seat_form,
  seat_result,
  seat_result_data,
  sip_data,
  config,
  login_info,
  token_info
} from '../models'
import { crypto } from '../common/utils/crypto'
import { relation_query, sendCode } from '../api'
import { Result } from '../models';
import { CustomDialogLoading } from '../common/utils/loading'
import { convertKeysToCamelCase } from '../common/utils';

import('./Index')


@Entry({ routeName: 'login' })
@ComponentV2
struct Login {
  @Local timer: number = 0
  @Local count: number = 60
  @Local userInfo: login_result_data =
    PersistenceV2.connect(login_result_data, USER_INFO, () => new login_result_data()) as login_result_data
  @Local tokenInfo: token_info = PersistenceV2.connect(token_info, TOKEN_INFO, () => new token_info()) as token_info
  @Local Config: config = PersistenceV2.connect(config, CONFIG, () => new config()) as config
  @Local loginInfo: login_info =
    PersistenceV2.connect(login_info, LOGIN_INFO, () => new login_info('', '')) as login_info
  // 1 密码登录 2 验证码登录
  @Local form: login_form = new login_form('13696594262', 'lw123456', deviceInfo.serial, 1, '', [])
  dialogControllerLoading: CustomDialogController = new CustomDialogController({
    builder: CustomDialogLoading(),
    cornerRadius: 10,
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: false,
    maskColor: Color.Transparent,
    backgroundColor: Color.Transparent
  })

  aboutToAppear(): void {

    const data = AppStorageV2.connect(login_info, LOGIN_INFO, () => new login_info('', '')) as login_info
    console.log('login_info', JSON.stringify(data), data.username)
    if (data?.username) {
      this.form.username = data.username
      this.form.password = data.password
    }
  }

  sendCode = async () => {
    if (this.timer) {
      return
    }
    if (!/^((\+?86)|(\(\+86\)))?(1[3456789][0123456789][0-9]{8})$/.test(this.form.username)) {
      promptAction.showToast({ message: '请输入正确的手机号' })
      return
    }
    this.count = 60
    const form: send_code_form = {
      "mobile": this.form.username,
      "type": '1005'
    }
    try {
      await sendCode(form) as Result<null>
      this.timer = setInterval(() => {
        if (this.count > 0) {
          this.count--
        } else {
          clearInterval(this.timer)
          this.timer = 0
          this.count = 60
        }
      }, 1000)
    } catch (e) {
    }

  }
  submit = async () => {
    if (this.form.protocol.length === 0) {
      promptAction.showToast({ message: '请勾选协议' })
      return
    }

    this.dialogControllerLoading.open()
    try {
      const params: login_form = convertKeysToCamelCase(this.form)
      const result: login_result = await api.login(params)
      if (result.code === 200) {
        const data = result.data as login_result_data
        promptAction.showToast({ message: '登录成功' })
        this.tokenInfo.token = data?.tokenName ?? ''
        this.tokenInfo.token_header = data?.tokenValue ?? ''
        this.loginInfo.username = this.form.username
        this.loginInfo.password = this.form.password

        PersistenceV2.connect(login_result_data, USER_INFO, () => data)
        PersistenceV2.save(LOGIN_INFO)
        PersistenceV2.save(TOKEN_INFO)
        PersistenceV2.save(USER_INFO)

        if (!data.register && data.userId) {
          try {
            await this.jurisdiction()
          } catch (e) {
          }
        }
        if (data.seat) {
          try {
            await this.getSeat(data)
          } catch (e) {
          }
        }
        if (!data.register) {
          try {
            this.getLocal()
            this.getConfig()
          } catch (e) {
          }
        }
        console.log('登录跳转')
        router.replaceNamedRoute({
          name: 'index'
        })
      }
    } catch (e) {
    }
    this.dialogControllerLoading.close()
  }
  getSeat = async (result_data: login_result_data) => {
    const form = new seat_form(result_data.seatInfo.id as number)
    const result: seat_result = await api.getSeatInfo(form)
    const data = result.data as seat_result_data
    const sipData = PersistenceV2.connect(sip_data, SIP_DATA, () => new sip_data()) as sip_data
    if (data.sipExtensionNumber) {
      sipData.isEnable = true
      sipData.sipAccount = data.sipExtensionNumber
      sipData.sipIp = data.sipExtensionIp && data.sipExtensionPort ?
        crypto(data.sipExtensionIp) + ':' + crypto(data.sipExtensionPort) : ''
      sipData.sipPassword = crypto(data.sipExtensionPwd)
      sipData.userPhone = this.form.username
      PersistenceV2.save(SIP_DATA)
    }
    this.userInfo.seatInfo = data as SeatInfo
    PersistenceV2.save(USER_INFO)
  }
  getLocal = async () => {
    if (this.userInfo.seatInfo.mode == 4) {
      this.userInfo.isLocal = true
    } else {
      try {
        const form = new config_form('local_dial')
        const result: config_result = await api.getUserConfigValue(form)
        const Local = result.data as config_result_data
        this.userInfo.isLocal = Local.values[0] == '0' ? false : true
      } catch (e) {
      }
    }
    try {
      const form = new config_form('customer_label_frame')
      const result: config_result = await api.getUserConfigValue(form)
      const user = result.data as config_result_data
      this.userInfo.isShowLabel = user.values[0] == '0' ? false : true
    } catch (e) {
    }

    PersistenceV2.save(USER_INFO)
  }
  jurisdiction = async () => {
    const form = new permissions_form(2)
    const result: permissions_result = await api.permissions(form)
    const data = result.data as permissions_result_data[] || []
    let jurisdiction: string[] = []
    const deepChild = (data: permissions_result_data[]) => {
      for (let i = 0; i < data.length; i++) {
        const childMenu = data[i].childMenu as permissions_result_data[] || [];
        deepChild(childMenu)
        if (data[i].realm) {
          jurisdiction.push(data[i].realm)
        }
      }
    }
    deepChild(data)
    this.userInfo.jurisdiction = jurisdiction
    this.userInfo.isPermissions = 0
    PersistenceV2.save(USER_INFO)
  }
  getConfig = async () => {
    try {
      const form = new config_form('customer_data_protection')
      const result: config_result = await relation_query(form)
      const data = result.data as config_result_data
      this.Config.phone = data.values[0] == '0' ? 0 : 1
    } catch (e) {
    }
    try {
      const form = new config_form('customer_name_protection')
      const result: config_result = await relation_query(form)
      const data = result.data as config_result_data
      this.Config.name = data.values[0] == '0' ? 0 : 1
    } catch (e) {
    }
    PersistenceV2.save(CONFIG)
  }
  getContext = async (value: number) => {
    const params: webview_params =
      new webview_params('https://api.kaxin.com/document/app/kxdx_crm/userAgreement.html', '用户协议')

    if (value === 6) {
      params.url = 'https://api.kaxin.com/document/app/kxdx_crm/userAgreement.html'
      params.title = '隐私政策'
    }

    router.pushUrl({
      url: 'pages/WebComponent',
      params: params
    })

  }

  build() {
    Column() {
      Text('欢迎使用卡信电销外呼crm').fontSize(24).fontWeight(FontWeight.Bold).width('100%').padding({ bottom: 10 })
      Text('防封外呼+CRM管理 助你业绩高效增长').fontSize(16).fontColor('#909399').padding({ bottom: 88 }).width('100%')
      Row() {
        Image($r('app.media.person_shield')).form_row_icon()
        TextInput({ text: this.form.username, placeholder: '请输入手机号码' })
          .type(InputType.Number)
          .form_input().onChange((value: string) => {
          this.form.username = value
        })
      }.form_row()

      Row() {
        if (this.form.loginType === 1) {
          Image($r('app.media.lock')).form_row_icon()
          TextInput({ text: this.form.password, placeholder: '请输入密码' })
            .type(InputType.NEW_PASSWORD)
            .showPasswordIcon(false)
            .form_input().onChange((value: string) => {
            this.form.password = value
          })
        } else {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Image($r('app.media.envelope')).form_row_icon().width(38)
            TextInput({ text: this.form.smsCode, placeholder: '请输入验证码' })
              .type(InputType.Number)
              .form_input()
              .onChange((value: string) => {
                this.form.smsCode = value
              })
              .layoutWeight(0)
              .flexGrow(1)
              .flexShrink(1)
              .flexBasis('0%')
            Button(this.count == 60 ? '发送验证码' : `重新发送(${this.count})`,
              { buttonStyle: ButtonStyleMode.TEXTUAL })
              .type(ButtonType.Normal).width(160)
              .onClick(this.sendCode).enabled(this.count == 60)
          }
        }
      }.form_row()

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        if (this.form.loginType === 1) {
          Text('短信验证码登录').form_login_method().onClick(() => {
            console.log('短信验证码登录')
            this.form.loginType = 2
          })
          Text('忘记密码？').form_login_method().onClick(() => {
            router.pushUrl({
              url: 'pages/ForgetPassword'
            })
          })
        } else {
          Text('密码登录').form_login_method().onClick(() => {
            this.form.loginType = 1
          })
          Text('未注册手机号登录时将自动注册').form_login_method().fontColor('#909399')
        }
      }.padding({ bottom: 90 }).width('100%')

      Button('登录', { type: ButtonType.Normal })
        .onClick(this.submit)
        .width('100%')
        .height(40)
        .margin({ bottom: 20 })
        .enabled(Boolean((this.form.username && this.form.password) || (this.form.username && this.form.smsCode)))

      Row() {
        Checkbox()
          .select(this.form.protocol[0] === 'x')
          .selectedColor(0x39a2db)
          .shape(CheckBoxShape.ROUNDED_SQUARE)
          .onChange((value: boolean) => {
            value ? this.form.protocol = ['x'] : this.form.protocol = []
          })
        Text() {
          Span('我已阅读并同意')
          Span('《用户协议》').fontColor('#3291F8').onClick(() => this.getContext(5))
          Span('和')
          Span('《隐私政策》').fontColor('#3291F8').onClick(() => this.getContext(6))
        }.fontSize(14)
      }.width('100%')

    }
    .height('100%')
    .width('100%')
    .padding(20)
  }
}

@Extend(Text)
function form_login_method() {
  .fontSize(14)
  .fontColor('#FF9039')
}

@Extend(Row)
function form_row() {
  .borderRadius(4)
  .margin({ bottom: 20 })
  .border({ width: 1, color: '#dadbde' })
}

@Extend(Image)
function form_row_icon() {
  .width(24)
  .height(24)
  .margin({ left: 10 })
  .fillColor('#909399')
}

@Extend(TextInput)
function form_input() {
  .layoutWeight(1)
  .borderRadius(0)
  .backgroundColor(Color.White)
}