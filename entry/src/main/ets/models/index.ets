export class Result<T> {
  code: number = 0
  msg: string = ""
  data: T | null = null
}

@ObservedV2
export class token_info {
  @Trace token?: string;
  @Trace token_header?: string;
}

@ObservedV2
export class login_info {
  @Trace username: string;
  @Trace password: string;

  constructor(username: string, password: string) {
    this.username = username;
    this.password = password;
  }
}
@ObservedV2
export class is_launch {
  @Trace isLaunch: boolean;

  constructor(isLaunch: boolean) {
    this.isLaunch = isLaunch;
  }
}

@ObservedV2
export class config_form {
  @Trace configCode: string

  constructor(configCode: string) {
    this.configCode = configCode
  }
}

export class config_result_data {
  configCode!: string
  values!: string[]
}

export class config_result extends Result<config_result_data> {
}

@Observed
export class seat_form {
  public seatId: number

  constructor(seatId: number) {
    this.seatId = seatId
  }
}

export class seat_result_data {
  id!: number;
  seatNo!: string
  setMealId!: number;
  productId!: number;
  mode!: number;
  supplierId!: number;
  circuitId!: number;
  sipExtensionId!: number;
  sipCallType!: string;
  sipExtensionNumber?: string;
  sipExtensionStatus!: string;
  sipExtensionPwd!: string;
  sipExtensionIp!: string;
  sipExtensionPort!: number;
  shareDate!: string;
}

export class seat_result extends Result<seat_result_data> {
}

@ObservedV2
export class sip_data {
  @Trace isEnable?: boolean;
  @Trace sipAccount?: string;
  @Trace sipIp?: string;
  @Trace sipPassword?: string;
  @Trace userPhone?: string;
}

@Observed
export class permissions_form {
  public clientType: number

  constructor(clientType: number) {
    this.clientType = clientType
  }
}

export interface permissions_result_data {
  id: number;
  parentId: number;
  sort: number;
  clientType: number;
  menuName: string;
  menuIcon: string;
  realm: string;
  realmUrl: string;
  component: string;
  menuType: number;
  remarks: string;
  childMenu: permissions_result_data[];
}


export class permissions_result extends Result<permissions_result_data[]> {
}

@ObservedV2
export class config {
  @Trace phone?: number;
  @Trace name?: number;
}

export interface update_password_form {
  oldPassword: string;
  newPassword: string;
}

export interface app_device_model {
  deviceModel: string;
  brand: string;
  romName: string;
  system: string;
  userPhone: string;
  tenantId: number;
  appVersion: string;
}

export interface query_form {
  page: number;
  pageSize: number;
  pageType: number;
  total?: number;
}

@ObservedV2
export class query_page {
  @Trace page: number;
  @Trace pageSize: number;
  @Trace pageType: number;
  @Trace total?: number;

  constructor(page: number, pageSize: number, pageType: number, total?: number) {
    this.page = page;
    this.pageSize = pageSize;
    this.pageType = pageType;

    if (total) {
      this.total = total;
    }
  }
}

export interface page<T> {
  page: number;
  pageSize: number;
  list: T[] | null;
  total: number;
}

export interface user_list_info {
  id: number;
  employeeNo: string;
  username: string;
  userPhone: string;
  deptId: number;
  tenantId: number;
  agencyId: number | null;
  companyId: number;
  status: number;
  createTime: string;
}

export interface user_list_form {
  userInfo?: string;
  excludeUserId?: number;
  pageType?: number;
  status?: number;
}

export interface label_list_info {
  tenantId: number;
  createTime: string;
  createBy: number;
  updateTime: string;
  updateBy: number;
  deleted: boolean;
  id: number;
  labelName: string;
  groupId: number;
  isChoose: number | null;
}