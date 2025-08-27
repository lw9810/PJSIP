/*
 * 验证规则
 */
export interface FormRuleItem {
  required?: boolean
  message?: string
  validator?: (value: string) => boolean | string | Promise<boolean | string>
  min?: number
  max?: number
}

export type FormRules = Record<string, FormRuleItem[]>


export class FormController {
  form: object
  rules: FormRules | null

  constructor(form: object, rules: FormRules | null = null) {
    this.form = form
    this.rules = rules
  }

  async validate(): Promise<boolean | string> {
    return new Promise(async (resolve) => {
      if (!this.rules) {
        resolve(true)
      } else {
        const form_keys = Object.keys(this.form)
        for (let i = 0; i < form_keys.length; i++) {
          const field = form_keys[i]
          if (this.rules[field]) {
            const rules = this.rules[field]
            if (rules.length > 0) {
              for (let j = 0; j < rules.length; j++) {
                const rule = rules[j]
                try {
                  await this.validateField(field, rule)
                } catch (e) {
                  resolve(e as string)
                }
              }
            }
          }
        }
        resolve(true)
      }
    })
  }

  async validateField(field: string, rule: FormRuleItem): Promise<boolean | string> {
    return new Promise(async (resolve, reject) => {
      if (rule.required) {
        if (!this.form[field]) {
          reject(rule.message)
          return
        }
      }
      if (rule.validator) {
        const result = await rule.validator(this.form[field])
        if (typeof result === 'string') {
          reject(result)
          return
        }
      }
      if (rule.min) {
        if (this.form[field].length < rule.min) {
          reject(rule.message)
          return
        }
      }
      if (rule.max) {
        if (this.form[field].length > rule.max) {
          reject(rule.message)
          return
        }
      }
      resolve(true)
    })
  }
}