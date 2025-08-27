import router from '@ohos.router';
import { appDeviceModel, pwdSimplicityVerify, updatePassword } from '../api';
import { USER_INFO } from '../constants';
import { login_result_data } from '../models/login';
import { app_device_model, Result, update_password_form } from '../models';
import Home from './Home'
import { AppStorageV2, LoadingDialog, promptAction } from '@kit.ArkUI';
import { FormController, FormRules } from '../common/utils/form';
import { CustomDialogLoading } from '../common/utils/loading';
import { deviceInfo } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';
import My from './My';
import Client from './Client';
import Phone from './Phone';
import Instrument from './Instrument';
import { AppUtil, PreferencesUtil } from '@pura/harmony-utils';

@CustomDialog
struct CustomDialogUpdatePasswordExample {
  dialogControllerLoading: CustomDialogController = new CustomDialogController({
    builder: CustomDialogLoading(),
    cornerRadius: 10,
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: false,
    maskColor: Color.Transparent,
    backgroundColor: Color.Transparent
  })
  @State form: update_password_form = {
    oldPassword: '',
    newPassword: ''
  }
  private rules: FormRules = {
    "oldPassword": [
      { required: true, message: '密码不能为空' },
      { min: 6, max: 24, message: '密码必须为6-24个字符' }
    ],
    "newPassword": [
      { required: true, message: '确认密码不能为空' },
      {
        validator: (value: string) => {
          return value === this.form.oldPassword ? true : '两次密码不一致'
        }
      }
    ]

  }
  controller?: CustomDialogController
  cancel: () => void = () => {
    console.log('cancel')
    if (this.controller != undefined) {
      this.controller.close()
    }
  }
  confirm: () => void = async () => {
    const controller = new FormController(this.form, this.rules)
    const result = await controller.validate()
    if (typeof result === 'string') {
      promptAction.showToast({ message: result })
      return
    }
    this.dialogControllerLoading.open()
    try {
      await updatePassword(this.form) as Result<null>
      if (this.controller != undefined) {
        this.controller.close()
      }
      promptAction.showToast({ message: '修改成功' })
      router.replaceNamedRoute({
        name: 'login'
      })
    } catch (e) {
    }
    this.dialogControllerLoading.close()
  }

  build() {
    Column() {
      Text('您的密码过于简单，请立即修改')
        .padding({ top: 20, bottom: 30 })
      TextInput({ text: this.form.oldPassword, placeholder: '请设置新密码（6-24位不重复不连续字符）' })
        .type(InputType.NEW_PASSWORD)
        .showPasswordIcon(false)
        .form_input()
        .onChange((value: string) => {
          this.form.oldPassword = value
        })
      TextInput({ text: this.form.newPassword, placeholder: '请重复输入新密码' })
        .type(InputType.NEW_PASSWORD)
        .showPasswordIcon(false)
        .form_input()
        .onChange((value: string) => {
          this.form.newPassword = value
        })
      Button('确认修改', { type: ButtonType.Normal })
        .onClick(this.confirm)
        .margin(20)
        .width(180)
    }
  }
}

@Entry({ routeName: 'index' })
@ComponentV2
struct Index {
  @Local currentIndex: number = 0
  private controller: TabsController = new TabsController()
  @Local userInfo: login_result_data = AppStorageV2.connect(login_result_data, USER_INFO, () => new login_result_data()) as login_result_data
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogUpdatePasswordExample(),
    autoCancel: true,
    customStyle: false,
    cornerRadius: 10,
    width: 300,
    height: 260,
    backgroundColor: Color.White,
    shadow: ({
      radius: 10,
      color: Color.Grey,
      offsetX: 6,
      offsetY: 0
    }),
  })
  getPwdSimplicityVerify = async () => {
    if (this.userInfo && !this.userInfo?.register) {
      const result: Result<boolean> = await pwdSimplicityVerify()
      if (!result.data) {
        this.dialogController.open()
      }
    }
  }
  setAppDeviceModel = async () => {
    let versionName = await AppUtil.getVersionName();
    const form: app_device_model = {
      deviceModel: deviceInfo.deviceType,
      brand: deviceInfo.brand,
      romName: 'harmonyos',
      system: deviceInfo.osFullName,
      userPhone: this.userInfo?.userPhone,
      tenantId: this.userInfo?.tenantId,
      appVersion: versionName
    }
    await appDeviceModel(form) as Result<null>
  }

  async aboutToAppear(): Promise<void> {
    this.getPwdSimplicityVerify()
    // this.dialogController.open()
    console.log('userInfo:',JSON.stringify(this.userInfo))
  }

  @Builder
  tabBuilder(title: Resource, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#FF9039' : '#BABABA')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
    })
  }

  build() {
    Navigation() {
      Tabs({
        barPosition: BarPosition.End,
        index: this.currentIndex,
        controller: this.controller
      }) {
        TabContent() {
          Home()
        }
        .tabBar(this.tabBuilder($r('app.string.navigation_toolbar_home'), 0, $r('app.media.home_selected'),
          $r("app.media.home")))


        TabContent() {
          Client()
        }
        .tabBar(this.tabBuilder($r('app.string.navigation_toolbar_client'), 1, $r('app.media.client_selected'),
          $r("app.media.client")))

        TabContent() {
          Phone()
        }
        .tabBar(this.tabBuilder($r('app.string.navigation_toolbar_phone'), 2, $r('app.media.telephone_selected'),
          $r("app.media.telephone")))

        TabContent() {
          Instrument()
        }
        .tabBar(this.tabBuilder($r('app.string.navigation_toolbar_instrument'), 3, $r('app.media.instrument_selected'),
          $r("app.media.instrument")))

        TabContent() {
          My()
        }
        .tabBar(this.tabBuilder($r('app.string.navigation_toolbar_my'), 4, $r('app.media.my_selected'),
          $r("app.media.my")))
      }.scrollable(false)
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }.mode(NavigationMode.Stack).hideTitleBar(true).hideToolBar(true).backgroundColor($r('app.color.pages_background'))
  }
}

@Extend(TextInput)
function form_input() {
  .borderRadius(0)
  .margin({ bottom: 10, left: 20, right: 20 })
}
