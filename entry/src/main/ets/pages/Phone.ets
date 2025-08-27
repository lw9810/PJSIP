import { ListView, LoadMoreFooterAttr, RefreshController, RefreshDataSource } from "@abner/refresh"
import { appDataReportList } from "../api/phone"
import { USER_INFO } from "../constants"
import { page, query_form, Result } from "../models"
import { login_result_data } from "../models/login"
import { phone_list_data, position } from "../models/phone"
import { AppStorageV2, LengthMetrics, promptAction } from "@kit.ArkUI"
import { pasteboard } from '@kit.BasicServicesKit';

@ComponentV2
struct Phone {
  @Local userInfo: login_result_data = AppStorageV2.connect(login_result_data, USER_INFO, () => new login_result_data()) as login_result_data
  @Local showEmptyLayout: boolean = true
  controller: RefreshController = new RefreshController() //刷新控制器，声明全局变量
  dataSource: RefreshDataSource = new RefreshDataSource() //数据懒加载操作对象，执行数据增删改查
  @Local loadMoreFooterAttr: LoadMoreFooterAttr = new LoadMoreFooterAttr()
  @Local total: number = 0
  @Local query: query_form = {
    page: 1,
    pageSize: 10,
    pageType: 1
  }
  @Local dataList: phone_list_data[] = []
  @Local callPhone: string = ''
  @Local buttonPosition: position = { x: -10, y: 380 }
  @Local startX: number = 0 // 开始移动触摸点x坐标，相对窗口左上角
  @Local startY: number = 0 // 开始移动触摸点y坐标，相对窗口左上角
  // 当前透明度
  @Local startLeft: number = 0 // 开始移动那一刻悬浮按钮距离窗口左边距离
  @Local startTop: number = 0
  @Local keyboardShow: boolean = false
  search = async () => {
    if (this.userInfo?.register) {
      this.dataSource.initData(this.dataList)
      this.initLoadMoreFooterAttr()
      return
    }
    const form: query_form = JSON.parse(JSON.stringify(this.query))
    try {
      const result: Result<page<phone_list_data>> = await appDataReportList(form)
      const data = result.data as page<phone_list_data>
      this.total = data.total
      if (this.query.page === 1) {
        this.dataSource.initData(data.list)
      } else {
        this.dataSource.pushDataArray(data.list)
      }
      this.initLoadMoreFooterAttr()
    } catch (e) {
    }
  }

  initLoadMoreFooterAttr() {
    this.showEmptyLayout = this.dataSource.totalCount() === 0
    if (this.total <= this.dataSource.totalCount()) {
      this.loadMoreFooterAttr.footerReleaseText = '没有更多了'
      this.loadMoreFooterAttr.footerFinishText = '没有更多了'
      this.loadMoreFooterAttr.footerLoadingText = '没有更多了'
    } else {
      this.loadMoreFooterAttr.footerReleaseText = '释放立即加载'
      this.loadMoreFooterAttr.footerFinishText = '加载完成'
      this.loadMoreFooterAttr.footerLoadingText = '正在加载中...'
    }
  }

  initCallPhone = async () => {
    const systemPasteboard = pasteboard.getSystemPasteboard()
    try {
      const pasteData = await systemPasteboard.getData()
      const text: string = pasteData.getPrimaryText()
      if (text && /^((\+?86)|(\(\+86\)))?(1[3456789][0123456789][0-9]{8})$/.test(text)) {
        this.callPhone = text
      }
    } catch (e) {
    }
  }

  aboutToAppear(): void {
    this.search()
    this.initCallPhone()
    if (!this.userInfo) {
      return
    }
  }

  @Builder
  keyboard() {
    Column() {
      Text(this.callPhone)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 20, bottom: 10 })
      Grid() {
        ForEach(['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'], (item: string) => {
          GridItem() {
            Button() {
              if (item === '*') {
                Text() {
                  SymbolSpan($r('sys.symbol.chevron_down')).fontSize(24)
                }.fontWeight(FontWeight.Bold)
              } else if (item === '#') {
                Text() {
                  SymbolSpan($r('sys.symbol.delete_left')).fontSize(24)
                }.fontWeight(FontWeight.Bold)
              } else {
                Text(item)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
              }
            }
            .width('100%')
            .height(60)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .onClick(() => {
              if (item === '*') {
                this.keyboardShow = false
              } else if (item === '#') {
                this.callPhone = this.callPhone.substring(0, this.callPhone.length - 1)
              } else {
                this.callPhone += item
              }
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .height(340)
      .padding(20)

      Button() {
        Text('拨打')
          .fontSize(18)
          .fontColor(Color.White)
      }
      .width('90%')
      .height(50)
      .backgroundColor('#165DFF')
      .borderRadius(25)
      .margin({ top: 20, bottom: 20 })
      .onClick(() => {
        if (this.callPhone) {
          this.keyboardShow = false
        }
      })
    }.width('100%')
    .height('100%')
  }

  @Builder
  emptyLayout() {
    Column() {
      Image($r('app.media.empty')).width(200)
      Text('暂无数据').fontSize(18).fontColor('#BCBCBC')
    }.width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  itemLayout(item: phone_list_data, index: number) {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Text(item.callNumber).fontWeight(FontWeight.Bold).fontSize(16)
        Image(item.callStatus == 0 ? $r('app.media.phones1') : $r('app.media.phones2'))
          .width(20)
          .height(20)
          .margin({ left: 5 })
      }
      .alignItems(VerticalAlign.Center)

      Row() {
        Text(item.callTime).fontColor('#909193').fontSize(13)
        Image($r('app.media.chevron_right'))
          .width(10)
          .height(10)
          .fillColor('#909193')
      }
      .alignItems(VerticalAlign.Center)
    }
    .flexShrink(1)
    .width('100%')
    .padding(16)
    .margin({ bottom: 10 })
    .backgroundColor(Color.White)
    .borderRadius(5)
    .gesture(LongPressGesture({ repeat: true }).onAction(() => {
      const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, item.callNumber)
      const systemPasteboard = pasteboard.getSystemPasteboard()
      systemPasteboard.setData(pasteboardData)
      promptAction.showToast({ message: '复制成功' })
    }))

  }

  build() {
    Column() {
      ListView({
        lazyDataSource: this.dataSource,
        itemLayout: (item, index) => this.itemLayout(item as phone_list_data, index),
        controller: this.controller,
        showEmptyLayout: this.showEmptyLayout,
        emptyLayout: this.emptyLayout,
        loadMoreFooterAttribute: (attribute: LoadMoreFooterAttr) => {
          this.loadMoreFooterAttr = attribute
        },
        onRefresh: async () => {
          await this.search()
          this.query.page = 1
          //刷新回调
          console.log('刷新回调')
          this.controller.finishRefresh()
        },
        onLoadMore: async () => {
          //加载更多回调
          console.log('加载更多回调')
          if (this.total > this.dataSource.totalCount()) {
            this.query.page++
            await this.search()
          }
          this.controller.finishLoadMore()
        }
      })
        .width('100%')
        .height('100%')

      Button({ type: ButtonType.Circle }) {
        Text() {
          SymbolSpan($r('sys.symbol.keyboard_circle')).fontSize(42)
        }.fontColor(Color.White)
      }
      .position({ x: this.buttonPosition.x, y: this.buttonPosition.y })
      .backgroundColor('#165DFF')
      .width(60)
      .height(60)
      .shadow({
        radius: 8,
        color: '#165DFF',
        offsetX: 0,
        offsetY: 4
      })
      .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
      .draggable(true)
      .onClick(() => {
        this.keyboardShow = true
      })
      .onTouch((event: TouchEvent) => {
        const touch = event.touches[0]
        if (event.type === TouchType.Down) {
          this.startX = touch.windowX
          this.startY = touch.windowY
          this.startLeft = this.buttonPosition.x
          this.startTop = this.buttonPosition.y

        } else if (event.type === TouchType.Move) {
          this.buttonPosition.x = this.startLeft + (touch.windowX - this.startX)
          this.buttonPosition.y = this.startTop + (touch.windowY - this.startY)
        }
      })
      .bindSheet(this.keyboardShow, this.keyboard, {
        height: 500,
        showClose: false,
        radius: LengthMetrics.vp(20),
        keyboardAvoidMode: SheetKeyboardAvoidMode.NONE,
        onWillAppear: () => {
          console.log("BindSheet onWillAppear.")
        },
        onAppear: () => {
          console.log("BindSheet onAppear.")
        },
        onWillDisappear: () => {
          console.log("BindSheet onWillDisappear.")
        },
        onDisappear: () => {
          this.keyboardShow = false
          this.callPhone = ''
          console.log("BindSheet onDisappear.")
        }
      })

    }.width('100%').height('100%')
    .padding(20)
    .backgroundColor($r('app.color.page_background'))
  }
}

export default Phone