import { AppStorageV2, LengthMetrics, promptAction } from '@kit.ArkUI'
import { ListView, LoadMoreFooterAttr, RefreshController, RefreshDataSource } from '@abner/refresh'
import { customer_list_data, customer_list_form } from '../models/client'
import { convertKeysToCamelCase, dataHasp } from '../common/utils'
import { customerAppList } from '../api/client'
import { label_list_info, page, Result, user_list_form, user_list_info } from '../models'
import { login_result_data } from '../models/login'
import { USER_INFO } from '../constants'
import { listAllLabel, userList } from '../api'

interface filter_option {
  title: string;
  id: string | number;
}

@ComponentV2
struct Client {
  @Local userInfo: login_result_data =
    AppStorageV2.connect(login_result_data, USER_INFO, () => new login_result_data()) as login_result_data
  @Local currentIndex: number = 0
  controller: RefreshController = new RefreshController() //刷新控制器，声明全局变量
  dataSource: RefreshDataSource = new RefreshDataSource() //数据懒加载操作对象，执行数据增删改查
  @Local dataList: customer_list_data[] = [
    {
      "customerId": "1806980986102099968",
      "position": 1,
      "customerName": "测试",
      "telephone": null,
      "sourceName": null,
      "sourceId": null,
      "industry": "",
      "industryStr": null,
      "contacts": [
        {
          "telephones": [
            {
              "contactTelephoneId": "1806980986102099970",
              "telephone": "12345678909",
              "otherPhone": null,
              "attribution": "",
              "isBlack": null,
              "tenantId": 1000213,
              "position": null,
              "ownerUserId": null,
              "dataType": null
            }
          ],
          "contactsId": "1806980986102099969",
          "customerId": "1806980986102099968",
          "name": "",
          "sex": 2,
          "email": "",
          "post": "",
          "wechatQq": "",
          "companyName": null,
          "address": "",
          "addressStr": null,
          "detailAddress": "",
          "remark": "",
          "createTime": "2024-06-29 17:20:13"
        }
      ],
      "followup": 0,
      "nextTime": null,
      "dealStatus": 0,
      "labelIds": null,
      "labelNames": ["测试", '测测测', '策策', '啦啦啦'],
      "ownerUserId": 433025,
      "ownerUserName": "15387577170",
      "collaboratorIds": null,
      "collaboratorNames": null,
      "status": 1,
      "giveUpTime": null,
      "giveUpReason": "2天未联系回收",
      "lastTime": null,
      "poolTime": "2024-08-01 02:01:51",
      "isReceive": 2,
      "lastContent": null,
      "receiveTime": "2024-09-10 14:02:09",
      "preOwnerUserId": 535822,
      "preOwnerUserName": "彬",
      "recycleTime": null,
      "remark": "",
      "createTime": "2024-06-29 17:20:14",
      "createBy": 517856,
      "creator": null
    }
  ]
  @Local total: number = 0
  @Local query: customer_list_form = new customer_list_form(1, 10, 1, 0, [], '', null, [], '', [], '', null, 1, 1, 1)
  @Local showEmptyLayout: boolean = true
  @Local loadMoreFooterAttr: LoadMoreFooterAttr = new LoadMoreFooterAttr()
  @Local abandon: Array<filter_option> = [
    { title: '今天', id: 'today' },
    { title: '昨天', id: 'yesterday' },
    { title: '本周', id: 'thisWeek' },
    { title: '上周', id: 'lastWeek' },
    { title: '本月', id: 'thisMonth' },
    { title: '上月', id: 'lastMonth' }]
  @Local lastTimeTypeList: Array<filter_option> = [
    { title: '今天', id: 'today' },
    { title: '昨天', id: 'yesterday' },
    { title: '本周', id: 'thisWeek' },
    { title: '上周', id: 'lastWeek' },
    { title: '本月', id: 'thisMonth' },
    { title: '上月', id: 'lastMonth' }]
  @Local resource: Array<filter_option> = [
    { title: '新增', id: 1 },
    { title: '回收资源', id: 2 }]
  @Local queryTypeList: Array<filter_option> = [
    { title: '我负责的', id: 1 },
    { title: '我协作的', id: 2 },
    { title: '本部门及下级部门的', id: 3 }]
  @Local followupList: Array<filter_option> = [
    { title: '未跟进', id: 0 },
    { title: '跟进中', id: 1 }]
  @Local labelIdListArr: Array<filter_option> = []
  @Local userListArr: Array<filter_option> = []
  @Local showFilter: boolean = false
  @Local showEdits: boolean = false
  @Local selectedKeys: Array<customer_list_data> = []
  scroller: Scroller = new Scroller()

  @Builder
  FilterExample() {

    Column({ space: 0 }) {
      Row() {
        Text('筛选').fontSize(16)
      }.width('100%').justifyContent(FlexAlign.Center).margin({ bottom: 20 })

      Scroll() {
        Column({ space: 16 }) {
          if (this.query.position === 2) {
            Text('资源类型').label_title()
            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(10), cross: LengthMetrics.lpx(10) } }) {
              ForEach(this.resource, (item: filter_option) => {
                Text(item.title).onClick(() => {
                  this.query.poolType = item.id as number
                })
                  .label_tag(this.query.poolType === item.id)
              })
            }
          } else if (this.query.position === 1) {
            Text('属性').label_title()
            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(10), cross: LengthMetrics.lpx(10) } }) {
              ForEach(this.queryTypeList, (item: filter_option) => {
                Text(item.title).onClick(() => {
                  this.query.queryType = item.id as number
                })
                  .label_tag(this.query.queryType === item.id)
              })
            }

            Text('跟进状态').label_title()
            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(10), cross: LengthMetrics.lpx(10) } }) {
              ForEach(this.followupList, (item: filter_option) => {
                Text(item.title).onClick(() => {
                  if (this.query.followup === item.id) {
                    this.query.followup = -1
                  } else {
                    this.query.followup = item.id as number
                  }
                })
                  .label_tag(this.query.followup === item.id)
              })
            }

            if (this.userInfo?.userId && this.userInfo?.userId === this.userInfo?.tenantInfo?.managerId) {
              Text('所属人').label_title()
              Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(10), cross: LengthMetrics.lpx(10) } }) {

                Row() {
                  Image($r('app.media.plus')).width(16)
                    .height(16).fillColor(Color.Black).margin({ right: 4 })
                  Text('添加').fontColor(Color.Black)
                }
                .label_row_tag().backgroundColor('#E2F0FF')
                .onClick(async () => {
                  try {
                    const result =
                      await userList({ pageType: 0, status: 1 } as user_list_form) as Result<page<user_list_info>>
                    if (!result.data?.list?.length) {
                      promptAction.showToast({ message: '暂无可选人员' })
                    } else {
                      let list = result.data.list
                      TextPickerDialog.show({
                        range: list.map(item => item.username),
                        onAccept: (value: TextPickerResult) => {
                          this.query.ownerUserIdList.push(list[value.index as number].id)
                        }
                      })
                    }
                  } catch (e) {
                  }
                })

                ForEach(this.userListArr, (item: filter_option) => {
                  if (this.query.ownerUserIdList?.includes(item.id as number)) {
                    Row() {
                      Text(item.title).fontColor(Color.White)
                      Image($r('app.media.xmark'))
                        .width(16)
                        .height(16)
                        .fillColor(Color.White)
                        .margin({ left: 4 })
                        .onClick(() => {
                          this.query.ownerUserIdList = this.query.ownerUserIdList.filter(ite => ite !== item.id)
                        })
                    }
                    .label_row_tag()
                  }
                })
              }

              Text('协作人').label_title()
              Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(10), cross: LengthMetrics.lpx(10) } }) {
                Row() {
                  Image($r('app.media.plus')).width(16)
                    .height(16).fillColor(Color.Black).margin({ right: 4 })
                  Text('添加').fontColor(Color.Black)
                }
                .label_row_tag().backgroundColor('#E2F0FF')
                .onClick(async () => {
                  try {
                    const result =
                      await userList({ pageType: 0, status: 1 } as user_list_form) as Result<page<user_list_info>>
                    if (!result.data?.list?.length) {
                      promptAction.showToast({ message: '暂无可选人员' })
                    } else {
                      let list = result.data.list
                      TextPickerDialog.show({
                        range: list.map(item => item.username),
                        onAccept: (value: TextPickerResult) => {
                          this.query.collaboratorIdList.push(list[value.index as number].id)
                        }
                      })
                    }
                  } catch (e) {
                  }
                })

                ForEach(this.userListArr, (item: filter_option) => {
                  if (this.query.collaboratorIdList?.includes(item.id as number)) {
                    Row() {
                      Text(item.title).fontColor(Color.White)
                      Image($r('app.media.xmark'))
                        .width(16)
                        .height(16)
                        .fillColor(Color.White)
                        .margin({ left: 4 })
                        .onClick(() => {
                          this.query.collaboratorIdList = this.query.collaboratorIdList.filter(ite => ite !== item.id)
                        })
                    }
                    .label_row_tag()
                  }
                })
              }
            }

            Text('默认分组').label_title()
            Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(10), cross: LengthMetrics.lpx(10) } }) {
              Repeat(this.labelIdListArr).each((obj: RepeatItem<filter_option>) => {
                Text(obj.item.title)
                  .onClick(() => {
                    const i = this.query.labelIdList.findIndex(ite => ite === obj.item.id)
                    if (i > -1) {
                      this.query.labelIdList.splice(i, 1)
                    } else {
                      this.query.labelIdList.push(obj.item.id as number)
                    }
                  })
                  .label_tag(this.query.labelIdList.includes(obj.item.id as number))
              })

            }

            if (this.query.position == 1) {
              Text('最近跟进时间').label_title()
              Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(10), cross: LengthMetrics.lpx(10) } }) {
                ForEach(this.lastTimeTypeList, (item: filter_option) => {
                  Text(item.title).onClick(() => {
                    if (this.query.lastTimeType === item.id) {
                      this.query.lastTimeType = ''
                    } else {
                      this.query.lastTimeType = item.id as string
                    }
                  })
                    .label_tag(this.query.lastTimeType === item.id)
                })
              }
            } else {
              Text('放弃时间').label_title()
              Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(10), cross: LengthMetrics.lpx(10) } }) {
                ForEach(this.lastTimeTypeList, (item: filter_option) => {
                  Text(item.title).onClick(() => {
                    if (this.query.poolTimeType === item.id) {
                      this.query.poolTimeType = ''
                    } else {
                      this.query.poolTimeType = item.id as string
                    }
                  })
                    .label_tag(this.query.poolTimeType === item.id)
                })
              }
            }
          }
        }
      }.width("100%").margin({ bottom: 70 }).layoutWeight(1)
      .align(Alignment.TopStart)

      Row() {
        Column({ space: 6 }) {
          Image($r('app.media.trash_fill')).width(20).height(20)
          Text('清除')
        }.justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.query.queryType = 1
          this.query.followup = -1
          this.query.ownerUserIdList = []
          this.query.collaboratorIdList = []
          this.query.labelIdList = []
          this.query.lastTimeType = ''
          this.query.poolType = null
          this.query.poolTimeType = ''
          this.showFilter = false
        })

        Button('确定', { type: ButtonType.Normal })
          .onClick(() => {
            this.showFilter = false
            this.search()
          })
          .margin({ left: 20 })
          .flexShrink(1)
          .layoutWeight(1)
      }.width("100%").height(70)
    }.width("100%").height('100%').padding(20)

  }

  onChangeTab(index: number) {
    this.query.position = index
    this.query.sortType = this.query.position === 1 ? 1 : 4
    this.selectedKeys = []
    this.search()
  }

  search = async () => {
    if (this.userInfo?.register) {
      this.dataSource.initData(this.dataList)
      this.initLoadMoreFooterAttr()
      return
    }
    const form: customer_list_form = JSON.parse(JSON.stringify(convertKeysToCamelCase(this.query)))
    if (form.followup === -1) {
      form.followup = null
    }
    if (form.position === 2) {
      form.queryType = null
    }
    try {
      const result: Result<page<customer_list_data>> = await customerAppList(form)
      const data = result.data as page<customer_list_data>
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
  getUserListAll = async () => {
    try {
      const result =
        await userList({ pageType: 0, status: 1 } as user_list_form) as Result<page<user_list_info>>
      if (result.data?.list?.length) {
        this.userListArr = result.data.list.map(item => ({ title: item.username, id: item.id } as filter_option))
      }
    } catch (e) {
    }

  }
  getListAllLabel = async () => {
    try {
      const result =
        await listAllLabel() as Result<label_list_info[]>
      if (result.data?.length) {
        this.labelIdListArr =
          result.data.map(item => ({ title: item.labelName, id: item.id } as filter_option))
      }
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

  aboutToAppear(): void {
    this.search()
    if (!this.userInfo) {
      return
    }
    if (this.userInfo?.tenantInfo?.level === 3) {
      this.queryTypeList.splice(2)
    }
    this.getUserListAll()
    this.getListAllLabel()
  }

  @Builder
  itemLayout(item: customer_list_data, index: number) {
    Row() {
      if (this.showEdits) {
        Checkbox({}).select(this.selectedKeys.map(ite => ite.customerId).includes(item.customerId))
          .onChange((checked: boolean) => {
            if (checked && !this.selectedKeys.map(ite => ite.customerId).includes(item.customerId)) {
              this.selectedKeys.push(item)
            } else if (!checked) {
              this.selectedKeys = this.selectedKeys.filter(ite => ite.customerId !== item.customerId)
            }
          })
          .shape(CheckBoxShape.ROUNDED_SQUARE)
      }
      Image(item.contacts[0].sex == 2 ? $r('app.media.woman') : $r('app.media.man'))
        .width(34)
        .height(34)
        .margin({ right: 10 })
      Column({ space: 8 }) {
        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          Text(dataHasp(item.contacts[0].name, 'name'))
          Text(dataHasp(item.contacts[0].telephones[0].telephone, 'phone'))
          if (this.query.position === 1) {
            Text(item.poolTime ? '未跟进' : '已跟进').fontColor(item.followup === 0 ? '#FF9039' : '#208CFF')
          } else {
            Text(item.poolTime ? '新增' : '回收').fontColor(item.followup === 0 ? '#FF9039' : '#208CFF')
          }
        }.flexShrink(1)

        Text(item.customerName)
          .fontColor('#BCBCBC')
          .width('100%')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.lpx(20), cross: LengthMetrics.lpx(20) } }) {
          ForEach(item.labelNames, (label: string, index) => {
            if (index <= 2) {
              Text(label)
                .fontColor('#208CFF')
                .backgroundColor('#E2F0FF')
                .borderColor('#E2F0FF')
                .borderWidth(1)
                .borderRadius(4)
                .padding(6)
            }
          })
        }
      }.flexShrink(1)

    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .padding(16)
    .margin({ bottom: 20 })
    .backgroundColor(Color.White)
    .borderRadius(10)
  }

  @Builder
  emptyLayout() {
    Column() {
      Image($r('app.media.empty')).width(200)
      Text('暂无数据').fontSize(18).fontColor('#BCBCBC')
    }.width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column({ space: 10 }) {
      Flex({ alignItems: ItemAlign.Baseline, space: { main: LengthMetrics.lpx(50) } }) {
        Text('我的客户').fontSize(this.query.position === 1 ? 20 : 18)
          .fontColor(this.query.position === 1 ? Color.Blue : Color.Black)
          .onClick(() => this.onChangeTab(1))
        Text('客户公海').fontSize(this.query.position === 2 ? 20 : 18)
          .fontColor(this.query.position === 2 ? Color.Blue : Color.Black)
          .onClick(() => this.onChangeTab(2))
      }

      Search({ value: this.query.customerInfo, placeholder: '搜索客户名称' }).onChange((value: string) => {
        this.query.customerInfo = value
        this.query.page = 1
        this.search()
      })
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        if (this.showEdits) {
          Text('取消').padding({ right: 4 }).onClick(() => {
            this.showEdits = false
            this.selectedKeys = []
          })
          Text(`全选（${this.selectedKeys.length}）`).padding({ right: 4 }).onClick(() => {
            // this.showEdits = false
            if (this.selectedKeys.length === this.dataSource.totalCount()) {
              this.selectedKeys = []
            } else {
              const data = this.dataSource.getDataAll() as customer_list_data[]
              this.selectedKeys = [...data]
              console.log(this.selectedKeys.toString())
            }
          })
        } else {
          Row() {
            Text('筛选').padding({ right: 4 })
            Image($r('app.media.arrow_triangle_down_fill')).width(16)
          }.alignItems(VerticalAlign.Center)
          .onClick(() => {
            this.showFilter = true
          }).bindContentCover(this.showFilter, this.FilterExample(), {
            modalTransition: ModalTransition.DEFAULT,
            backgroundColor: Color.White,
            onWillDismiss: ((dismissContentCoverAction: DismissContentCoverAction) => {
              this.query.queryType = 1
              this.query.followup = -1
              this.query.ownerUserIdList = []
              this.query.collaboratorIdList = []
              this.query.labelIdList = []
              this.query.lastTimeType = ''
              this.query.poolType = null
              this.query.poolTimeType = ''
              dismissContentCoverAction.dismiss()
            }),
          })

          Row() {
            Text('批量').padding({ right: 4 })
            Image($r('app.media.plus_square_on_square_fill')).width(16)
          }.alignItems(VerticalAlign.Center).onClick(() => {
            this.selectedKeys = []
            this.showEdits = true
          })
        }
      }

      ListView({
        lazyDataSource: this.dataSource,
        itemLayout: (item, index) => this.itemLayout(item as customer_list_data, index),
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
      if (this.showEdits) {
        Scroll(this.scroller) {
          Row({ space: 20 }) {
            if (this.query.position === 1) {
              Button() {
                Text('转移').fontSize(18).fontColor(Color.White)
              }
              .bom_button(!!this.selectedKeys.length)

              Button() {
                Text('添加协作人').fontSize(18).fontColor(Color.White)
              }
              .bom_button(!!this.selectedKeys.length)

              Button() {
                Text('放弃公海').fontSize(18).fontColor(Color.White)
              }
              .bom_button(!!this.selectedKeys.length)
            } else {
              Button() {
                Text('领取').fontSize(18).fontColor(Color.White)
              }
              .bom_button(!!this.selectedKeys.length)

              Button() {
                Text('分配').fontSize(18).fontColor(Color.White)
              }
              .bom_button(!!this.selectedKeys.length)
            }
            Button() {
              Text('删除').fontSize(18).fontColor(Color.White)
            }
            .backgroundColor('#F53F3F')
            .bom_button(!!this.selectedKeys.length)
          }
          .backgroundColor(Color.White)
          .padding({ top: 20, bottom: 20 })
        }.scrollable(ScrollDirection.Horizontal)
        .fadingEdge(true, { fadingEdgeLength: LengthMetrics.lpx(20) })
        .position({ bottom: -20, left: 0 })
      }

    }.width('100%').height('100%')
    .padding({
      right: 20,
      left: 20,
      bottom: 20,
      top: 20
    })
    .backgroundColor($r('app.color.page_background'))
  }
}

@Extend(Text)
function label_title() {
  .fontSize(15)
  .width('100%')
}

@Extend(Text)
function label_tag(type: boolean) {
  .fontColor(type ? Color.White : Color.Black)
  .backgroundColor(type ? '#208CFF' : '#E2F0FF')
  .borderRadius(4)
  .padding(6)
}

@Extend(Row)
function label_row_tag() {
  .backgroundColor('#208CFF')
  .borderRadius(4)
  .padding(6)
}

@Extend(Button)
function bom_button(bol: boolean) {
  .type(ButtonType.ROUNDED_RECTANGLE)
  .width(100)
  .height(40)
  .borderRadius(5)
  .enabled(bol)
}

export default Client