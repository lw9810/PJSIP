import { TOKEN_HEADER_KEY, TOKEN_INFO, TOKEN_KEY, USER_INFO } from '../constants'
import { login_result_data } from '../models/login'
import { Result } from '../models'
import { AppStorageV2, ComposeListItem, IconType, PersistenceV2, promptAction, router } from '@kit.ArkUI'
import { deviceInfo } from '@kit.BasicServicesKit';
import { AppUtil } from '@pura/harmony-utils';
import { logout } from '../api/login';
import { CustomDialogLoading } from '../common/utils/loading'

@ComponentV2
struct My {
  @Local userInfo: login_result_data =
    AppStorageV2.connect(login_result_data, USER_INFO, () => new login_result_data()) as login_result_data
  @Local versionName: string = '1.0.0'
  dialogControllerLoading: CustomDialogController = new CustomDialogController({
    builder: CustomDialogLoading(),
    cornerRadius: 10,
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: false,
    maskColor: Color.Transparent,
    backgroundColor: Color.Transparent
  })

  handleClickAvatar() {
    if (!this?.userInfo) {
      router.replaceNamedRoute({
        name: 'login'
      })
    }
  }

  onLoginOut = () => {
    AlertDialog.show({
      title: '提示',
      message: '是否切换账号登录？',
      alignment: DialogAlignment.Bottom,
      primaryButton: {
        value: '取消',
        action: () => {
        }
      },
      secondaryButton: {
        value: '确定',
        action: async () => {
          try {
            this.dialogControllerLoading.open()
            const data: Result<null> = await logout() // 退出登录
            this.userInfo = null
            PersistenceV2.remove(TOKEN_INFO) // 删除token
            router.replaceNamedRoute({
              name: 'login'
            })
          } catch (e) {
          }
          this.dialogControllerLoading.close()
        }
      }
    })
    // router.replaceNamedRoute({
    //   name: 'login'
    // })
  }

  async init() {
    let versionName = await AppUtil.getVersionName();
    this.versionName = versionName ?? '1.0.0';
  }

  async aboutToAppear(): Promise<void> {
    await this.init()
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Image(this.userInfo?.avatarUrl || $r('app.media.person_crop_circle_fill'))
          .width(60)
          .height(60)
          .margin({ right: 10 })
        // .onClick(this.handleClickAvatar)
        Column({ space: 4 }) {
          Text(this.userInfo?.username || '未登录').fontSize(17).width('100%')
          Text(this.userInfo?.tenantInfo?.tenantName || '暂无租户').fontSize(14).fontColor('#909193').width('100%')
        }.flexShrink(1)
      }.box()

      List() {
        ListItem() {
          ComposeListItem({
            contentItem: ({
              iconStyle: IconType.SYSTEM_ICON,
              icon: $r('app.media.addressBook'),
              primaryText: '企业通讯录'
            }),
            operateItem: ({
              arrow: {
                value: $r('app.media.chevron_right')
              },
            })
          })
        }

        if (this.userInfo && this.userInfo.userId === this.userInfo.tenantInfo.managerId) {
          ListItem() {
            ComposeListItem({
              contentItem: ({
                iconStyle: IconType.SYSTEM_ICON,
                icon: $r('app.media.invite'),
                primaryText: '邀请同事'
              }),
              operateItem: ({
                arrow: {
                  value: $r('app.media.chevron_right')
                },
              })
            })
          }
        }

        ListItem() {
          ComposeListItem({
            contentItem: ({
              iconStyle: IconType.SYSTEM_ICON,
              icon: $r('app.media.setUp'),
              primaryText: '设置'
            }),
            operateItem: ({
              arrow: {
                value: $r('app.media.chevron_right')
              },
            })
          })
        }

        ListItem() {
          ComposeListItem({
            contentItem: ({
              iconStyle: IconType.SYSTEM_ICON,
              icon: $r('app.media.refresh'),
              primaryText: '当前版本'
            }),
            operateItem: ({
              text: `${this.versionName}(${this.userInfo?.seatInfo?.mode || '无'})`
            })
          })
        }

        ListItem() {
          ComposeListItem({
            contentItem: ({
              iconStyle: IconType.SYSTEM_ICON,
              icon: $r('app.media.switch'),
              primaryText: '退出登录'
            }),
          })
        }.onClick(this.onLoginOut)
      }
      .divider({
        strokeWidth: 1,
      }) // 每行之间的分界线
      .padding({
        top: 0,
        bottom: 0,
        left: 20,
        right: 20
      })
      .backgroundColor(Color.White)

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

export default My