import { query_form, query_page } from './index'

@ObservedV2
export class customer_list_form extends query_page {
  @Trace collaboratorIdList: number[]
  @Trace customerInfo: string
  @Trace followup: null | number
  @Trace labelIdList: number[]
  @Trace lastTimeType: string
  @Trace ownerUserIdList: number[]
  @Trace poolTimeType: string
  @Trace poolType: null | number
  @Trace position: null | number
  @Trace queryType: null | number
  @Trace sortType: null | number

  constructor(page: number, pageSize: number, pageType: number,
    total: number | undefined, collaboratorIdList: number[], customerInfo: string, followup: null | number,
    labelIdList: number[], lastTimeType: string, ownerUserIdList: number[], poolTimeType: string,
    poolType: null | number, position: null | number, queryType: null | number, sortType: null | number) {
    super(page, pageSize, pageType, total)
    this.collaboratorIdList = collaboratorIdList
    this.customerInfo = customerInfo
    this.followup = followup
    this.labelIdList = labelIdList
    this.lastTimeType = lastTimeType
    this.ownerUserIdList = ownerUserIdList
    this.poolTimeType = poolTimeType
    this.poolType = poolType
    this.position = position
    this.queryType = queryType
    this.sortType = sortType
  }
}

export interface ContactsTelephone {
  contactTelephoneId: string;
  telephone: string;
  otherPhone: null;
  attribution: string;
  isBlack: null;
  tenantId: number;
  position: null;
  ownerUserId: null;
  dataType: null;
}

export interface Contact {
  telephones: ContactsTelephone[];
  contactsId: string;
  customerId: string;
  name: string;
  sex: null | number;
  email: null | string;
  post: null | string;
  wechatQq: null | string;
  companyName: null;
  address: string;
  addressStr: null;
  detailAddress: string;
  remark: string;
  createTime: string;
}

export interface customer_list_data {
  customerId: string;
  position: number;
  customerName: string;
  telephone: null;
  sourceName: null;
  sourceId: null;
  industry: null | string;
  industryStr: null;
  contacts: Contact[];
  followup: null | number;
  nextTime: null;
  dealStatus: number;
  labelIds: null | number[];
  labelNames: null | string[];
  ownerUserId?: null | number;
  ownerUserName: null | string;
  collaboratorIds: null;
  collaboratorNames: null;
  status: number;
  giveUpTime: null;
  giveUpReason: string;
  lastTime: null | string;
  poolTime: null | string;
  isReceive: null | number;
  lastContent: null;
  receiveTime: null | string;
  preOwnerUserId: null | number;
  preOwnerUserName: string;
  recycleTime: null;
  remark: null | string;
  createTime: null | string;
  createBy: null | number;
  creator: null;
}