@CustomDialog
export struct CustomDialogLoading {
  controller?: CustomDialogController
  content: string = '努力加载中...'
  theme: CustomTheme = {
    colors: {
      fontPrimary: Color.Black,
      iconSecondary: Color.Blue
    }
  }

  build() {
    Column() {
      LoadingProgress()
        .color(this.theme?.colors?.iconSecondary || Color.Blue)
        .size({ width: 80, height: 80 })
      Text(this.content)
        .fontColor(this.theme?.colors?.fontPrimary || Color.Black)

    }
  }
}
