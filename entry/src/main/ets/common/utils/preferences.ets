import preferences from '@ohos.data.preferences';

const prefMap: Map<string, preferences.Preferences> = new Map()

class PreferencesUtil {
  async loadPreference(context: Context, name: string) {
    try { // 加载preferences
      console.log('testTag', `加载Preferences[${name}]中...`)
      let pref = await preferences.getPreferences(context, name)
      prefMap.set(name, pref)
      console.log('testTag', `加载Preferences[${name}]成功`)
    } catch (e) {
      console.log('testTag', `加载Preferences[${name}]失败`, JSON.stringify(e))
    }
  }

  async putPreferenceValue(name: string, key: string, value: preferences.ValueType) {
    await this.hasPreference(name)
    try {
      let pref = prefMap.get(name)
      // 写入数据
      await (pref as preferences.Preferences).putSync(key, value)
      // 刷盘
      await (pref as preferences.Preferences).flush()
      console.log('testTag', `保存Preferences[${name}.${key} = ${value}]成功`)
    } catch (e) {
      console.log('testTag', `保存Preferences[${name}.${key} = ${value}]失败`, JSON.stringify(e))
    }
  }

  async getPreferenceValue(name: string, key: string,
    defaultValue: preferences.ValueType): Promise<preferences.ValueType | void> {
    await this.hasPreference(name)
    try {
      let pref = prefMap.get(name)
      // 读数据
      let value = await (pref as preferences.Preferences).getSync(key, defaultValue)
      console.log('testTag', `读取Preferences[${name}.${key} = ${value}]成功`)
      return value
    } catch (e) {
      console.log('testTag', `读取Preferences[${name}.${key} ]失败`, JSON.stringify(e))
    }
  }

  async deletePreferenceValue(name: string, key: string) {
    await this.hasPreference(name)
    try {
      let pref = prefMap.get(name)
      // 删除数据
      await (pref as preferences.Preferences).deleteSync(key)
      // 刷盘
      await (pref as preferences.Preferences).flush()
    } catch (e) {
      console.log('testTag', `删除Preferences[${name}.${key} ]失败`, JSON.stringify(e))
    }
  }

  async clearPreferenceValue(name: string) {
    await this.hasPreference(name)

    try {
      let pref = prefMap.get(name)
      // 清空数据
      await (pref as preferences.Preferences).clearSync()
      // 刷盘
      await (pref as preferences.Preferences).flush()
    } catch (e) {
      console.log('testTag', `清空Preferences[${name}]失败`, JSON.stringify(e))
    }
  }

  async clearAllPreference() {
    prefMap.forEach((pref, key) => {
      try {
        // 清空数据
        pref.clearSync()
        // 刷盘
        pref.flush()
      } catch (e) {
        console.log('testTag', `清空Preferences[${key}]失败`, JSON.stringify(e))
      }
    })
  }

  async hasPreference(name: string) {
    const isExist = prefMap.has(name)
    if (!isExist) {
      console.log('testTag', `Preferences[${name}]尚未初始化！`)
      await this.loadPreference(getContext(), name)
    }
  }
}

const preferencesUtil = new PreferencesUtil()

export default preferencesUtil as PreferencesUtil
