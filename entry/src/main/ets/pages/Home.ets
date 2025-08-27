import { AppStorageV2, router } from '@kit.ArkUI'
import { appCallStatistics, appCallTaskStatistics, selectAppNoReadCount, selectNoReadAppNotice } from '../api/home'
import { USER_INFO } from '../constants'
import { login_result_data } from '../models/login'
import { Result } from '../models'
import { call_statistics_result_data, call_task_statistics_result_data, note_result_data } from '../models/home'
import dayjs from 'dayjs'
import { scanBarcode, scanCore } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit'

@ComponentV2
struct Home {
  @Local userInfo: login_result_data = AppStorageV2.connect(login_result_data, USER_INFO, () => new login_result_data()) as login_result_data
  @Local note: number = 0
  @Local noteData: note_result_data = {
    msgBody: '暂无数据'
  }
  @Local callStatistics: call_statistics_result_data = {
    addedCustomerNum: 100,
    contactCount: 100,
    followUpCount: 100,
    callCustomerCount: 100,
    callCount: 100,
    answerCount: 100,
    callDuration: '01:05:18',
    answerRate: 0.68
  }
  @Local taskStatistics: call_task_statistics_result_data = {
    callTaskTotal: 100,
    unFinishCount: 100,
    finishCount: 100
  }

  onLoginPage() {
    router.pushUrl({
      url: 'pages/Login'
    })
  }

  async scanCode() {
    // 定义扫码参数options
    let options: scanBarcode.ScanOptions =
      { scanTypes: [scanCore.ScanType.ALL], enableMultiMode: true, enableAlbum: true };
    console.log('扫码')
    scanBarcode.startScanForResult(getContext(this), options).then((result: scanBarcode.ScanResult) => {
      console.log(`Succeeded in getting ScanResult by promise with options, result is ${JSON.stringify(result)}`)

    }).catch((error: BusinessError) => {
      console.log(`Failed to get ScanResult by promise with options. Code: ${error.code}, message: ${error.message}`)
    })
  }

  async getStatistics() {
    try {
      const result = await appCallStatistics() as Result<call_statistics_result_data>
      this.callStatistics = result.data as call_statistics_result_data
    } catch (e) {
    }
    try {
      const result = await appCallTaskStatistics() as Result<call_task_statistics_result_data>
      this.taskStatistics = result.data as call_task_statistics_result_data
    } catch (e) {
    }
  }

  async getNotes() {
    try {
      const result = await selectAppNoReadCount() as Result<number>
      this.note = result.data || 0
    } catch (e) {
    }
    try {
      const result = await selectNoReadAppNotice() as Result<note_result_data | null>
      this.noteData = result.data || { msgBody: '暂无数据' }
    } catch (e) {
    }
  }

  init() {
    if (!this.userInfo?.register) {
      this.getNotes()
      this.getStatistics()
    }
  }

  aboutToAppear(): void {
    this.init()
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text(`欢迎你，${this.userInfo?.username || '尊敬的客户'}`).fontSize(24).fontWeight(FontWeight.Bold)
        Image($r('app.media.line_viewfinder')).width(24).height(24).onClick(this.scanCode)
      }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Bottom)
      .width('100%').padding({ right: 20, left: 20 })

      Row() {
        Column({ space: 10 }) {
          Row() {
            Divider()
              .vertical(true)
              .strokeWidth(4)
              .color('#FF9039')
              .height(20)
              .margin({ right: 10 })
            Text('今日数据统计').box_title()
          }.width('100%')

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Column() {
              Text(this.callStatistics.addedCustomerNum.toString()).box_text_value()
              Text('新增客户数').box_text_name()
            }.width('25%')

            Column() {
              Text(this.callStatistics.contactCount.toString()).box_text_value()
              Text('联系客户数').fontSize(14)
            }.width('25%')

            Column() {
              Text(this.callStatistics.followUpCount.toString()).box_text_value()
              Text('写跟进次数').box_text_name()
            }.width('25%')

            Column() {
              Text(this.callStatistics.callCount.toString()).box_text_value()
              Text('打电话次数').box_text_name()
            }.width('25%')
          }
        }
        .align(Alignment.TopStart)
        .justifyContent(FlexAlign.Start)
      }.box()

      Row() {
        Column({ space: 10 }) {
          Row() {
            Image($r('app.media.synoptic_view')).fillColor('#01b652').width(20).height(20).margin({ right: 5 })
            Text('今日电话接通概览').box_title()
          }.width('100%')

          Row() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Column() {
                Row() {
                  Text(`${Math.round((this.callStatistics.answerRate * 100) * 1000) / 1000 || 0}%`)
                    .fontWeight(FontWeight.Bold)
                    .fontSize(20)
                    .fontColor('#01b652')
                  Text('今日电话接通率').box_text_top_name().padding({ left: 10 })
                }.width('100%').padding({ bottom: 10 })

                Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                  Column() {
                    Text(`今日拨打电话总数`).box_text_top_name()
                    Text(this.callStatistics.callCount.toString()).box_text_name()
                  }

                  Column() {
                    Text(`今日通话总时长`).box_text_top_name()
                    Text(this.callStatistics.callDuration.toString()).fontSize(14)
                  }

                }
              }.padding({ right: 10 })

              Progress({ value: this.callStatistics.answerRate * 100, total: 100, type: ProgressType.Ring })
                .width(120).color('#01b652')
                .style({ strokeWidth: 10, shadow: true })
            }
          }
        }
        .align(Alignment.TopStart)
        .justifyContent(FlexAlign.Start)
      }.box()

      Row() {
        Column({ space: 10 }) {
          Row() {
            Image($r('app.media.performance')).fillColor(Color.Blue).width(20).height(20).margin({ right: 5 })
            Text('任务完成情况').box_title()
          }.width('100%')

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Column() {
              Text(this.taskStatistics.callTaskTotal.toString()).box_text_value()
              Text('任务总数').box_text_name()
            }.width('33.3%')

            Column() {
              Text(this.taskStatistics.unFinishCount.toString()).box_text_value()
              Text('待完成').fontSize(14)
            }.width('33.3%')

            Column() {
              Text(this.taskStatistics.finishCount.toString()).box_text_value()
              Text('已完成').box_text_name()
            }.width('33.3%')
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
            Text('消息通知').box_title()
          }.width('100%')

          Row() {
            Badge({
              count: this.note,
              style: {},
              position: BadgePosition.RightTop
            }) {
              Image($r('app.media.inform')).width(30).height(30)
            }.margin({ right: 10 })

            Column({ space: 5 }) {
              Row() {
                Text('系统通知').box_title()
                Text(dayjs().format('YYYY/MM/DD')).box_text_top_name()
              }.width('100%').justifyContent(FlexAlign.SpaceBetween)

              Row() {
                Text(this.noteData.msgBody).box_text_top_name().width('100%')
              }.width('100%')
            }
            .flexShrink(1)
          }.width('100%')
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
  .backgroundColor(Color.White)
  .padding(20)
}


@Extend(Text)
function box_title() {
  .fontSize(18)
}

@Extend(Text)
function box_text_value() {
  .fontWeight(FontWeight.Bold)
  .fontSize(20)
  .fontColor(Color.Blue)
  .padding({ bottom: 6 })
}

@Extend(Text)
function box_text_name() {
  .fontSize(14)
}

@Extend(Text)
function box_text_top_name() {
  .fontSize(14).fontColor('#909193').padding({ bottom: 6 })
}

export default Home