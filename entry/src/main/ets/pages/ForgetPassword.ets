import NavBar from '../components/NavBar';
import { reset_password_form } from '../models/forget_password';
import { promptAction, router } from '@kit.ArkUI';
import { FormController, FormRules } from '../common/utils/form';
import { sendCode } from '../api/index';
import { send_code_form } from '../models/login';
import { Result } from '../models';
import { retrievePassword } from '../api/login';
import { CustomDialogLoading } from '../common/utils/loading';

@Entry
@ComponentV2
struct ResetPassword {
  @Local timer: number = 0
  @Local count: number = 60
  @Local form: reset_password_form = new reset_password_form('', '', '', '')
  private rules: FormRules = {
    "userPhone": [
      { required: true, message: '手机号不能为空' },
      {
        validator: (value: string) => {
          return /^((\+?86)|(\(\+86\)))?(1[3456789][0123456789][0-9]{8})$/.test(value)
            ? true
            : '请输入正确的手机号'
        }
      }],
    "code": [{ required: true, message: '验证码不能为空' }],
    "newPassword": [
      { required: true, message: '密码不能为空' },
      { min: 6, max: 24, message: '密码必须为6-24个字符' }
    ],
    "notarizePassword": [
      { required: true, message: '确认密码不能为空' },
      {
        validator: (value: string) => {
          return value === this.form.newPassword ? true : '两次密码不一致'
        }
      }
    ]

  }
  dialogControllerLoading: CustomDialogController = new CustomDialogController({
    builder: CustomDialogLoading(),
    cornerRadius: 10,
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: false,
    maskColor: Color.Transparent,
    backgroundColor: Color.Transparent
  })
  sendCode = async () => {
    if (this.timer) {
      return
    }
    if (!/^((\+?86)|(\(\+86\)))?(1[3456789][0123456789][0-9]{8})$/.test(this.form.userPhone)) {
      promptAction.showToast({ message: '请输入正确的手机号' })
      return
    }
    this.count = 60
    const form: send_code_form = {
      "mobile": this.form.userPhone,
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
    const controller = new FormController(this.form, this.rules)
    const result = await controller.validate()
    if (typeof result === 'string') {
      promptAction.showToast({ message: result })
      return
    }
    this.dialogControllerLoading.open()
    try {
      await retrievePassword(this.form) as Result<null>
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
      NavBar({ title: '忘记密码' })
      Column() {
        Row() {
          TextInput({ text: this.form.userPhone, placeholder: '请输入手机号码' })
            .type(InputType.Number)
            .form_input().onChange((value: string) => {
            this.form.userPhone = value
          })
        }.form_row()

        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
          TextInput({ text: this.form.code, placeholder: '请输入验证码' })
            .type(InputType.Number)
            .form_input().onChange((value: string) => {
            this.form.code = value
          })
          Button(this.count == 60 ? '发送验证码' : `重新发送(${this.count})`, { buttonStyle: ButtonStyleMode.TEXTUAL })
            .type(ButtonType.Normal).onClick(this.sendCode).enabled(this.count == 60)
        }.form_flex()

        Row() {
          TextInput({ text: this.form.newPassword, placeholder: '请输入您的登录密码，6-24个字符' })
            .type(InputType.NEW_PASSWORD).showPasswordIcon(true)
            .form_input().onChange((value: string) => {
            this.form.newPassword = value
          })
        }.form_row()

        Row() {
          TextInput({ text: this.form.notarizePassword, placeholder: '请再次输入您的登录密码' })
            .type(InputType.NEW_PASSWORD).showPasswordIcon(true)
            .form_input().onChange((value: string) => {
            this.form.notarizePassword = value
          })
        }.form_row()

        Button('确定', { type: ButtonType.Normal })
          .onClick(this.submit).width('100%').height(40)
          .enabled(Boolean(this.form.userPhone && this.form.code
            && this.form.newPassword && this.form.notarizePassword))
      }
      .padding(20)

    }
    .height('100%')
    .width('100%')
  }
}

@Extend(Flex)
function form_flex() {
  .borderRadius(4)
  .margin({ bottom: 20 })
  .border({ width: 1, color: '#dadbde' })
}

@Extend(TextInput)
function form_input() {
  .borderRadius(0)
  .backgroundColor(Color.White)
}

@Extend(Row)
function form_row() {
  .borderRadius(4)
  .margin({ bottom: 20 })
  .border({ width: 1, color: '#dadbde' })
}