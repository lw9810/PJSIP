import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { webview_params } from '../models/login';
import NavBar from '../components/NavBar';


@Entry
@ComponentV2
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  @Local url: string = '';
  @Local title: string = '';

  aboutToAppear(): void {
    const params = router.getParams() as webview_params;
    this.url = params.url
    this.title = params.title
    // webview.WebviewController.setWebDebuggingAccess(true);
  }

  build() {
    Column() {
      NavBar({ title: this.title })
      Web({ src: this.url, controller: this.controller })
    }
  }
}