import { IS_LAUNCH_KEY, PREFERENCES_KEY } from '../constants'
import router from '@ohos.router';
import { PreferencesUtil } from '@pura/harmony-utils';
import { PersistenceV2 } from '@kit.ArkUI';
import { is_launch } from '../models';

import('./Login')

@Entry({ routeName: 'diagram' })
@ComponentV2
struct Index {
  handleClick = () => {
    router.replaceNamedRoute({
      name: 'login'
    })
  }

  async aboutToAppear() {
    let store = PersistenceV2.connect(is_launch, IS_LAUNCH_KEY, () => new is_launch(false)) as is_launch
    console.log('isLaunch', store?.isLaunch)
    if (!store?.isLaunch) {
      store.isLaunch = true
      PersistenceV2.save(IS_LAUNCH_KEY)
    } else {
      this.handleClick()
    }
  }

  @Local index: number = 0
  images = ['diagram0', 'diagram1', 'diagram2', 'diagram3']

  build() {
    Stack() {
      Swiper() {
        ForEach(this.images, (item: string) => {
          Image($r(`app.media.diagram.${item}`)).width('100%').height('100%').objectFit(ImageFit.Contain)
        })
      }.width('100%').height('100%').padding(10).onChange((index: number) => {
        this.index = index
      })

      Button('进入APP', { type: ButtonType.Capsule })
        .position({ top: 20, right: 10 }).backgroundColor("rgba(0, 0, 0, 0.8)")
        .onClick(this.handleClick)
      if (this.index === 3) {
        Button('进入APP', { type: ButtonType.Capsule })
          .width('70%')
          .height(50)
          .position({ bottom: 50, left: '50%' })
          .translate({ x: '-50%' })
          .onClick(this.handleClick)

      }
    }.width('100%').height('100%')
  }
}