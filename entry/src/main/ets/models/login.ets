import { Result } from '.'

@ObservedV2
export class login_form {
  @Trace username: string = ''
  @Trace password: string = ''
  @Trace deviceId: string = ''
  @Trace loginType: number = 1
  @Trace smsCode: string = ''
  @Trace protocol: string[] = []

  constructor(username?: string, password?: string, deviceId?: string, loginType?: number, smsCode?: string,
    protocol?: string[]) {
    if (username) {
      this.username = username
    }
    if (password) {
      this.password = password
    }
    if (deviceId) {
      this.deviceId = deviceId
    }
    if (loginType) {
      this.loginType = loginType
    }
    if (smsCode) {
      this.smsCode = smsCode
    }
    if (protocol) {
      this.protocol = protocol
    }
  }
}

export class TenantInfo {
  id!: number;
  tenantNo!: string;
  corpId!: string;
  uuid!: string;
  tenantName!: string;
  createTime!: string;
  status!: number;
  managerId!: number;
  remainingCallAmount!: string;
  remainingCallTime?: string | null;
  level!: number;
  agencyId?: number | null;
  companyId!: number;
  record!: number;
  settlementType!: number;
  settlementDate!: string;
  contractSeatNum!: number;
  contractMonthNum!: number;
  usableSeatNum!: number;
  ccGroupId!: number;
  followerUpIds?: string | null;
  billingMethod!: number;
  customerIndustry!: string;
  lowCostType!: number;
  chargeByMinute?: number | null;
  chargeMinutes?: number | null;
  chargeTime!: string;
  minimumRechargeAmount?: number | null;
}

export class AgencyInfo {
  id?: number | null;
  tenantNo?: string | null;
  corpId?: string | null;
  uuid?: string | null;
  tenantName?: string | null;
  createTime?: string | null;
  status?: number | null;
  managerId?: number | null;
  remainingCallAmount?: string | null;
  remainingCallTime?: string | null;
  level?: number | null;
  agencyId?: number | null;
  companyId?: number | null;
  record?: number | null;
  settlementType?: number | null;
  settlementDate?: string | null;
  contractSeatNum?: number | null;
  contractMonthNum?: number | null;
  usableSeatNum?: number | null;
  ccGroupId?: number | null;
  followerUpIds?: string | null;
  billingMethod?: number | null;
  customerIndustry?: string | null;
  lowCostType?: number;
  chargeByMinute?: number | null;
  chargeMinutes?: number | null;
  chargeTime?: string | null;
  minimumRechargeAmount?: number | null;
}

export class CompanyInfo {
  id!: number;
  tenantNo!: string;
  corpId!: string;
  uuid!: string;
  tenantName!: string;
  createTime!: string;
  status!: number;
  managerId!: number;
  remainingCallAmount!: string;
  remainingCallTime?: string | null;
  level!: number;
  agencyId?: number | null;
  companyId!: number;
  record!: number;
  settlementType!: number;
  settlementDate!: string;
  contractSeatNum!: number;
  contractMonthNum!: number;
  usableSeatNum!: number;
  ccGroupId?: number | null;
  followerUpIds?: string | null;
  billingMethod!: number;
  customerIndustry?: string | null;
  lowCostType?: number;
  chargeByMinute?: number | null;
  chargeMinutes?: number | null;
  chargeTime?: string | null;
  minimumRechargeAmount?: number | null;
}

export class DeptInfo {
  id!: number;
  pid!: number;
  deptName!: string;
  createTime!: string;
  status!: number;
  ownerUserIds!: string;
  tenantId!: number;
  path?: string | null;
}

export class SeatInfo {
  id?: number | null;
  seatNo?: string | null;
  setMealId?: number | null;
  productId?: number | null;
  mode?: number | null;
  supplierId?: number | null;
  circuitId?: number | null;
  sipExtensionId?: number | null;
  sipCallType?: string | null;
  sipExtensionNumber?: string | null;
  sipExtensionStatus?: string | null;
  sipExtensionPwd?: string | null;
  sipExtensionIp?: string | null;
  sipExtensionPort?: number | null;
  shareDate?: string | null;
}

export class AdminRole {
  tenantId?: number | null;
  createTime?: string | null;
  createBy?: string | null;
  updateTime?: string | null;
  updateBy?: string | null;
  deleted!: boolean;
  id!: number;
  roleName!: string;
  remark?: string | null;
  status!: number;
  dataType!: number;
  isHidden!: boolean;
  currentNum?: number | null;
  rules?: string | null;
  menuIds?: number[] | null;
  managerType!: number;
  level?: number | null;
}

@ObservedV2
export class login_result_data {
  @Trace userId!: number;
  @Trace username!: string;
  @Trace userPhone!: string;
  @Trace tokenName!: string;
  @Trace tokenValue!: string;
  @Trace register!: boolean;
  @Trace isManager!: boolean;
  @Trace isBlack!: boolean;
  @Trace tenantId!: number;
  @Trace tenantInfo!: TenantInfo;
  @Trace agencyInfo!: AgencyInfo;
  @Trace companyInfo!: CompanyInfo;
  @Trace deptId!: number;
  @Trace deptInfo!: DeptInfo;
  @Trace seat!: boolean;
  @Trace seatInfo!: SeatInfo;
  @Trace adminRoleList!: AdminRole[];
  @Trace avatarUrl?: string;
  @Trace isLocal?: boolean;
  @Trace isShowLabel?: boolean;
  @Trace jurisdiction?: string[];
  @Trace isPermissions?: number;
}

export class login_result extends Result<login_result_data> {
}

@Observed
export class getByType_form {
  public type: number

  constructor(type: number) {
    this.type = type
  }
}

export class getByType_result {
  id: number
  type: number
  context: string

  constructor(id: number, type: number, context: string) {
    this.id = id
    this.type = type
    this.context = context
  }
}

export class webview_params {
  url: string;
  title: string;

  constructor(url: string, title: string) {
    this.url = url;
    this.title = title;
  }
}

export interface send_code_form {
  mobile: string;
  type: string;
}
