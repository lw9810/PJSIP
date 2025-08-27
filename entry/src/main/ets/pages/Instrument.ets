import { USER_INFO } from '../constants'
import { login_result_data } from '../models/login'
import { AppStorageV2 } from '@kit.ArkUI'

@ComponentV2
struct Instrument {
  @Local userInfo: login_result_data = AppStorageV2.connect(login_result_data, USER_INFO, () => new login_result_data()) as login_result_data

  build() {
    Column({ space: 10 }) {
      Row() {
        Column({ space: 10 }) {
          Row() {
            Divider()
              .vertical(true)
              .strokeWidth(4)
              .color('#FF9039')
              .height(20)
              .margin({ right: 10 })
            Text('销售工具').box_title()
          }.width('100%')

          Flex({ wrap: FlexWrap.Wrap }) {
            if (this.userInfo?.jurisdiction?.includes('sales-task')) {
              Column() {
                Image($r('app.media.task')).box_image()
                Text('销售任务').box_text_name()
              }.width('25%')
            }

            if (this.userInfo?.jurisdiction?.includes('phone-assistant')) {
              Column() {
                Image($r('app.media.phone')).box_image()
                Text('电话助手').fontSize(14)
              }.width('25%')

            }

            if (this.userInfo?.jurisdiction?.includes('sip-phone')) {
              Column() {
                Image($r('app.media.SIP')).box_image()
                Text('SIP电话').box_text_name()
              }.width('25%')
            }

          }
        }
        .align(Alignment.TopStart)
        .justifyContent(FlexAlign.Start)
      }.box()

      Row() {
        Column({ space: 10 }) {
          Row() {
            Divider()
              .vertical(true)
              .strokeWidth(4)
              .color('#FF9039')
              .height(20)
              .margin({ right: 10 })
            Text('管理工具').box_title()
          }.width('100%')

          Flex({ wrap: FlexWrap.Wrap }) {

            if (this.userInfo?.jurisdiction?.includes('call-statistics')) {
              Column() {
                Image($r('app.media.call_records')).box_image()
                Text('通话统计').box_text_name()
              }.width('25%')
            }
            if (this.userInfo?.jurisdiction?.includes('customer-statistics')) {
              Column() {
                Image($r('app.media.customer_statistics')).box_image()
                Text('客户统计').fontSize(14)
              }.width('25%')

            }
            if (this.userInfo?.jurisdiction?.includes('contact-statistical')) {
              Column() {
                Image($r('app.media.statistical_form')).box_image()
                Text('联系统计').box_text_name()
              }.width('25%')

            }
            if (this.userInfo?.jurisdiction?.includes('relationship-record')) {
              Column() {
                Image($r('app.media.relationship_record')).box_image()
                Text('联系记录').box_text_name()
              }.width('25%')

            }
            if (this.userInfo?.jurisdiction?.includes('task-management')) {
              Column() {
                Image($r('app.media.task_management')).box_image()
                Text('任务管理').box_text_name()
              }.width('25%')
            }
          }
        }
        .align(Alignment.TopStart)
        .justifyContent(FlexAlign.Start)
      }.box()
    }.alignItems(HorizontalAlign.Start)
    .width('100%').height('100%').backgroundColor($r('app.color.page_background'))
  }
}

@Styles
function box() {
  .width('100%')
  .padding(20)
}

@Extend(Text)
function box_title() {
  .fontSize(18)
}

@Extend(Text)
function box_text_name() {
  .fontSize(14)
}

@Extend(Image)
function box_image() {
  .width(24).height(24).margin({ bottom: 8, top: 30 })
}

export default Instrument