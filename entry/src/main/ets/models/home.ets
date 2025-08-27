import { Result } from './index'

export interface note_result_data {
  msgBody: string;
}

export interface call_statistics_result_data {
  addedCustomerNum: number;
  contactCount: number;
  followUpCount: number;
  callCustomerCount: number;
  callCount: number;
  answerCount: number;
  callDuration: string;
  answerRate: number;
}

export interface call_task_statistics_result_data {
  callTaskTotal: number;
  unFinishCount: number;
  finishCount: number;
}