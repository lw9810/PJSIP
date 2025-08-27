@ObservedV2
export class reset_password_form {
  userPhone: string
  code: string
  newPassword: string
  notarizePassword: string

  constructor(userPhone: string, code: string, newPassword: string, notarizePassword: string) {
    this.userPhone = userPhone
    this.code = code
    this.newPassword = newPassword
    this.notarizePassword = notarizePassword
  }
}