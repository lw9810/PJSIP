import { router } from '@kit.ArkUI'

@Preview
@ComponentV2
struct NavBar {
  @Param
  type: number = 0 //左侧返回类型 0 router 1 navigation
  @Param
  title: string = "标题" //标题内容
  @Param
  titleBold: boolean = true //标题是否加粗
  @Param
  backgroundColorResource: ResourceColor = Color.White
  @Param
  leftImage: PixelMap | ResourceStr | DrawableDescriptor | null = $r("app.media.chevron_left") //左边箭头
  @Param
  right: string = "" //右边内容
  @Param
  rightImage: PixelMap | ResourceStr | DrawableDescriptor | null = null
  rightClick: () => void = () => {
  }
  pageInfos: NavPathStack = new NavPathStack()

  build() {
    Stack() {
      // 返回键
      Row() {
        Image(this.leftImage)
          .width(25)
          .height(25)
      }
      .width(30)
      .height(30)
      .borderRadius(15)
      .visibility(this.leftImage ? Visibility.Visible : Visibility.Hidden)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        if (this.type === 0) {
          router.back()
        } else {
          this.pageInfos.pop()
        }
      })
      .zIndex(2)

      Text(this.title)
        .layoutWeight(1)
        .fontWeight(this.titleBold ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(Color.Black)
        .fontSize(16)
        .textAlign(TextAlign.Center)
        .visibility(this.title ? Visibility.Visible : Visibility.Hidden)
        .width("100%")


      if (!this.rightImage) {
        Text(this.right ? this.right : "清空")
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .visibility(this.right ? Visibility.Visible : Visibility.Hidden)
          .fontSize(14)
          .width("100%")
          .textAlign(TextAlign.End)
          .onClick(() => {
            this.rightClick && this.rightClick()
          })
          .zIndex(1)
      }
      if (this.rightImage) {
        Row() {
          Image(this.rightImage)
            .height(25)
            .onClick(() => {
              this.rightClick && this.rightClick()
            }).zIndex(1)
        }.width("100%")
        .onClick(() => {
          this.rightClick && this.rightClick()
        })
        .justifyContent(FlexAlign.End)
      }
    }
    .backgroundColor(this.backgroundColorResource)
    .width('100%')
    .alignContent(Alignment.Start)
    .height(56)
    .padding({
      right: 13,
      left: 12
    })
  }
}

export default NavBar
