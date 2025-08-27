@ComponentV2
export struct Card {
  @BuilderParam content: () => void

  build() {
    Column({ space: 10 }) {
      this.content()
    }
    .width('100%')
    .height('100%')
    .borderRadius(10)
    .shadow({ radius: 20 })
    .backgroundColor(Color.White)
  }
}
