/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80036
 Source Host           : localhost:3306
 Source Schema         : yh_kos_release

 Target Server Type    : MySQL
 Target Server Version : 80036
 File Encoding         : 65001

 Date: 26/08/2025 14:59:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bind_log
-- ----------------------------
DROP TABLE IF EXISTS `bind_log`;
CREATE TABLE `bind_log`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `call_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '呼叫id',
  `tel_a` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫',
  `tel_b` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '被叫',
  `tel_x` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中间号',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `result_code` int(0) NULL DEFAULT NULL COMMENT '结果代码',
  `bind_result` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '绑定结果(成功200，超频 403008,其他,-1)',
  `supplier_id` int(0) NULL DEFAULT NULL COMMENT '供应商id',
  `caller_before_time` datetime(0) NULL DEFAULT NULL COMMENT '主叫前时间',
  `caller_time` datetime(0) NULL DEFAULT NULL COMMENT '主叫中时间',
  `caller_after_time` datetime(0) NULL DEFAULT NULL COMMENT '主叫后时间',
  `callee_before_time` datetime(0) NULL DEFAULT NULL COMMENT '被叫前时间',
  `callee_time` datetime(0) NULL DEFAULT NULL COMMENT '被叫中时间',
  `callee_after_time` datetime(0) NULL DEFAULT NULL COMMENT '被叫后时间',
  `caller_connecting` datetime(0) NULL DEFAULT NULL,
  `caller_waiting` datetime(0) NULL DEFAULT NULL,
  `caller_ringing` datetime(0) NULL DEFAULT NULL,
  `caller_noanswer` datetime(0) NULL DEFAULT NULL,
  `caller_online` datetime(0) NULL DEFAULT NULL,
  `caller_leave` datetime(0) NULL DEFAULT NULL,
  `callee_connecting` datetime(0) NULL DEFAULT NULL,
  `callee_waiting` datetime(0) NULL DEFAULT NULL,
  `callee_ringing` datetime(0) NULL DEFAULT NULL,
  `callee_noanswer` datetime(0) NULL DEFAULT NULL,
  `callee_busy` datetime(0) NULL DEFAULT NULL,
  `callee_online` datetime(0) NULL DEFAULT NULL,
  `callee_leave` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3166190 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_exter_trunk
-- ----------------------------
DROP TABLE IF EXISTS `config_exter_trunk`;
CREATE TABLE `config_exter_trunk`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `trunk_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_external_inbound
-- ----------------------------
DROP TABLE IF EXISTS `config_external_inbound`;
CREATE TABLE `config_external_inbound`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `sip_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sip信令端口',
  `tls_sip_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'tls信令端口',
  `rtp_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '内网rtpIp',
  `sip_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '内网sipIp',
  `ext_rtp_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外网rtpIp',
  `ext_sip_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外网sipIp',
  `type` int(0) NULL DEFAULT NULL COMMENT '类型:1呼入，2呼出',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '网络参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_switch
-- ----------------------------
DROP TABLE IF EXISTS `config_switch`;
CREATE TABLE `config_switch`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `max_sessions` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统支持并发数 ',
  `rtp_start_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'rtp起始端口',
  `rtp_end_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'rtp结束端口',
  `redis_host` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'redis主机名',
  `redis_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'redis端口',
  `redis_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'redis密码',
  `ims` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Ims接口',
  `callin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'A路callIn接口',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for data_report
-- ----------------------------
DROP TABLE IF EXISTS `data_report`;
CREATE TABLE `data_report`  (
  `id` bigint(0) NOT NULL,
  `supplier_id` int(0) NULL DEFAULT NULL COMMENT '供应商id',
  `dept_id` int(0) NULL DEFAULT NULL COMMENT '部门id',
  `set_meal_id` int(0) NULL DEFAULT NULL COMMENT '套餐id',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `bind_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '绑定id',
  `call_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '话单唯一标识',
  `call_time` datetime(0) NULL DEFAULT NULL COMMENT '拨打时间',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '主叫接听时间',
  `answer_time` datetime(0) NULL DEFAULT NULL COMMENT '被叫接听时间',
  `finish_time` datetime(0) NULL DEFAULT NULL COMMENT '挂机时间',
  `call_duration` int(0) NULL DEFAULT NULL COMMENT '通话时长（秒）',
  `fee_duration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '扣费时长（分钟）',
  `call_status` int(0) NULL DEFAULT NULL COMMENT '接听状态：0未接听；1已接听',
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫号码',
  `tel_x` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中间号/能力号',
  `call_number` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '被叫号码',
  `place` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '号码归属地',
  `record_download_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '录音地址',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `user_id` int(0) NULL DEFAULT NULL COMMENT ' 员工标识',
  `create_by` int(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_delete` bit(1) NULL DEFAULT b'0',
  `called_duration` int(0) NULL DEFAULT NULL COMMENT '被叫接听时长',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  `sip_id` int(0) NULL DEFAULT NULL COMMENT '分机号sip id',
  `caller_duration` int(0) NULL DEFAULT NULL COMMENT '主叫接听时长',
  `in_out_type` tinyint(0) NULL DEFAULT 2 COMMENT '1:为呼入类型，2呼出类型',
  `job_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '工作号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `bind_index`(`bind_id`) USING BTREE,
  INDEX `idx_call_id`(`call_id`) USING BTREE,
  INDEX `idx_tenant_id_user_id`(`tenant_id`, `user_id`) USING BTREE,
  INDEX `idx_tenant_id_user_phone`(`tenant_id`, `user_phone`) USING BTREE,
  INDEX `idx_tenant_id_call_number`(`tenant_id`, `call_number`) USING BTREE,
  INDEX `index_0`(`tenant_id`, `is_delete`, `call_time`) USING BTREE,
  INDEX `index_2`(`tenant_id`, `user_phone`, `call_number`) USING BTREE,
  INDEX `index_3`(`create_time`) USING BTREE,
  INDEX `index_4`(`is_delete`, `user_id`, `tenant_id`, `call_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话单明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for data_report_copy
-- ----------------------------
DROP TABLE IF EXISTS `data_report_copy`;
CREATE TABLE `data_report_copy`  (
  `id` bigint(0) NOT NULL,
  `supplier_id` int(0) NULL DEFAULT NULL COMMENT '供应商id',
  `dept_id` int(0) NULL DEFAULT NULL COMMENT '部门id',
  `set_meal_id` int(0) NULL DEFAULT NULL COMMENT '套餐id',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `bind_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '绑定id',
  `call_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '话单唯一标识',
  `call_time` datetime(0) NULL DEFAULT NULL COMMENT '拨打时间',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '主叫接听时间',
  `answer_time` datetime(0) NULL DEFAULT NULL COMMENT '被叫接听时间',
  `finish_time` datetime(0) NULL DEFAULT NULL COMMENT '挂机时间',
  `call_duration` int(0) NULL DEFAULT NULL COMMENT '通话时长（秒）',
  `fee_duration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '扣费时长（分钟）',
  `call_status` int(0) NULL DEFAULT NULL COMMENT '接听状态：0未接听；1已接听',
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫号码',
  `tel_x` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中间号/能力号',
  `call_number` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '被叫号码',
  `place` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '号码归属地',
  `record_download_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '录音地址',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `user_id` int(0) NULL DEFAULT NULL COMMENT ' 员工标识',
  `create_by` int(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_delete` bit(1) NULL DEFAULT b'0',
  `called_duration` int(0) NULL DEFAULT NULL COMMENT '被叫接听时长',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  `sip_id` int(0) NULL DEFAULT NULL COMMENT '分机号sip id',
  `caller_duration` int(0) NULL DEFAULT NULL COMMENT '主叫接听时长',
  `in_out_type` tinyint(0) NULL DEFAULT 2 COMMENT '1:为呼入类型，2呼出类型',
  `job_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '工作号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `bind_index`(`bind_id`) USING BTREE,
  INDEX `idx_call_id`(`call_id`) USING BTREE,
  INDEX `idx_tenant_id_user_id`(`tenant_id`, `user_id`) USING BTREE,
  INDEX `idx_tenant_id_user_phone`(`tenant_id`, `user_phone`) USING BTREE,
  INDEX `idx_tenant_id_call_number`(`tenant_id`, `call_number`) USING BTREE,
  INDEX `index_0`(`tenant_id`, `is_delete`, `call_time`) USING BTREE,
  INDEX `index_2`(`tenant_id`, `user_phone`, `call_number`) USING BTREE,
  INDEX `index_3`(`create_time`) USING BTREE,
  INDEX `index_4`(`is_delete`, `user_id`, `tenant_id`, `call_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话单明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_config_data
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_config_data`;
CREATE TABLE `kx_admin_config_data`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `account_id` int(0) NOT NULL COMMENT '账户ID',
  `config_id` int(0) NOT NULL COMMENT '配置ID',
  `apart_value` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '配置值 逗号分隔',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通用配置数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_dept
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_dept`;
CREATE TABLE `kx_admin_dept`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `status` int(0) NOT NULL DEFAULT 1 COMMENT '状态 1-启用 0-禁用',
  `pid` int(0) NULL DEFAULT NULL COMMENT '父级ID',
  `dept_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '部门名称',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `owner_user_ids` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门负责人',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '删除状态：0->未删除；1->已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 126571 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_dict
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_dict`;
CREATE TABLE `kx_admin_dict`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `pid` int(0) NOT NULL DEFAULT 0 COMMENT '父级ID',
  `dict_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典编码',
  `dict_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字典名称',
  `dict_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典值',
  `sort` int(0) NULL DEFAULT NULL COMMENT '排序',
  `status` int(0) NULL DEFAULT 1 COMMENT '状态（1正常 0停用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NULL DEFAULT NULL COMMENT '逻辑删除标识',
  `dict_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '字典类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 565 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_dict_bf
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_dict_bf`;
CREATE TABLE `kx_admin_dict_bf`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `pid` int(0) NOT NULL DEFAULT 0 COMMENT '父级ID',
  `dict_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典编码',
  `dict_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字典名称',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典值',
  `sort` int(0) NULL DEFAULT NULL COMMENT '排序',
  `status` int(0) NULL DEFAULT 1 COMMENT '状态（1正常 0停用）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NULL DEFAULT NULL COMMENT '逻辑删除标识',
  `dict_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '字典类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 326 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_follow
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_follow`;
CREATE TABLE `kx_admin_follow`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `follow_id` int(0) NULL DEFAULT NULL COMMENT '跟进人id',
  `type` int(0) NULL DEFAULT 0 COMMENT '类型(1客服，2销售)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_tenatid`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4051 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '跟进人表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_general_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_general_config`;
CREATE TABLE `kx_admin_general_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编码',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_multi_selection` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否多选 0-单选 1-多选',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '\0' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '个性化公共配置类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_general_config_category
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_general_config_category`;
CREATE TABLE `kx_admin_general_config_category`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `config_id` int(0) NOT NULL COMMENT '公共配置ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性名称',
  `value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性值',
  `is_default` bit(1) NOT NULL COMMENT '是否默认 0-非默认 1-默认',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '个性化通用配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_menu
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_menu`;
CREATE TABLE `kx_admin_menu`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `client_type` int(0) NULL DEFAULT 1 COMMENT '客户端类型 1-PC端 2-移动端',
  `parent_id` int(0) NULL DEFAULT NULL COMMENT '父菜单ID',
  `menu_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `realm` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `realm_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限URL',
  `component` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '前端组件',
  `realm_module` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属模块',
  `menu_type` int(0) NOT NULL COMMENT '菜单类型  1目录 2 菜单 3 按钮 4特殊',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序（同级有效）',
  `status` int(0) NOT NULL DEFAULT 1 COMMENT '状态 1 启用 0 禁用',
  `remarks` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单说明',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` int(0) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(0) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `menu_icon` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单图标',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 298 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_register_user
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_register_user`;
CREATE TABLE `kx_admin_register_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `source` int(0) NULL DEFAULT 0 COMMENT '来源 0-未知 1-PC端 2-移动端 3-第三方4-抖音',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `is_deleted` tinyint(0) NULL DEFAULT 0 COMMENT '删除状态：0->未删除；1->已删除',
  `deleted_version` int(0) NULL DEFAULT 0 COMMENT '删除版本',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_user_phone_is_deleted`(`user_phone`, `is_deleted`, `deleted_version`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6651 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '注册用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_role
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_role`;
CREATE TABLE `kx_admin_role`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色描述',
  `status` tinyint(0) NOT NULL COMMENT '1 启用 0 禁用',
  `data_type` int(0) NULL DEFAULT 999 COMMENT '数据权限 1、本人，2、本人及下属，3、本部门，4、本部门及下属部门，999、全部',
  `is_hidden` tinyint(0) NOT NULL COMMENT '是否隐藏',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` int(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(0) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `manager_type` int(0) NULL DEFAULT 1 COMMENT '管理类型 1业务 2管理',
  `level` int(0) NULL DEFAULT NULL COMMENT '层级 1公司 2代理 3租户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1006904 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_role_auth
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_role_auth`;
CREATE TABLE `kx_admin_role_auth`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `role_id` int(0) NOT NULL COMMENT '角色ID',
  `menu_id` int(0) NOT NULL COMMENT '菜单ID',
  `auth_role_id` int(0) NOT NULL COMMENT '能查询的角色ID',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_role_menu`;
CREATE TABLE `kx_admin_role_menu`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `role_id` int(0) NOT NULL COMMENT '角色ID',
  `menu_id` int(0) NULL DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_kx_admin_role_menu_kx_admin_role_1`(`role_id`) USING BTREE,
  INDEX `fk_kx_admin_role_menu_kx_admin_menu_1`(`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 545761 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant`;
CREATE TABLE `kx_admin_tenant`  (
  `id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_no` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '租户编号',
  `corp_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '企业号',
  `uuid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'uuid',
  `tenant_name` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '租户名称',
  `status` int(0) NOT NULL COMMENT '状态 0-停用 1-启用 999-销户 10-违规关停',
  `deposit` decimal(10, 4) NOT NULL COMMENT '押金',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `manager_id` int(0) NOT NULL COMMENT '管理员ID',
  `level` int(0) NOT NULL COMMENT '企业层级 0-平台 1-公司 2-代理 3-租户',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理ID',
  `company_id` int(0) NOT NULL COMMENT '公司ID',
  `is_record` int(0) NOT NULL DEFAULT 0 COMMENT '是否录音',
  `settlement_date` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '月结日',
  `settlement_type` int(0) NULL DEFAULT 1 COMMENT '结算类型 1-自然月共享 2-动态月共享 3-坐席周期 4-自然月不共享 5-动态月不共享',
  `industry_id` int(0) NULL DEFAULT NULL COMMENT '行业ID',
  `follow_up_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '跟进人ID',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(0) NOT NULL DEFAULT 0 COMMENT '删除状态',
  `contract_seat_num` int(0) NULL DEFAULT 0 COMMENT '合同坐席数限制',
  `contract_month_num` int(0) NULL DEFAULT 1 COMMENT '合同月份数',
  `usable_seat_num` int(0) NULL DEFAULT 0 COMMENT '可加坐席数',
  `cc_group_id` int(0) NULL DEFAULT NULL COMMENT '软交换线路编号',
  `billing_method` int(0) NULL DEFAULT 1 COMMENT '计费方式 1主叫侧 2被叫侧',
  `customer_industry` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户行业',
  `low_cost_type` int(0) NULL DEFAULT 0 COMMENT '低消模式0关联租户套餐分钟数，1不关联租户套餐分钟数',
  `charge_by_minute` int(0) NULL DEFAULT 0 COMMENT '是否实打实销 0否1是',
  `charge_minutes` int(0) NULL DEFAULT 0 COMMENT '实打实销分钟数',
  `charge_time` datetime(0) NULL DEFAULT NULL COMMENT '实打实销配置时间',
  `logout_time` datetime(0) NULL DEFAULT NULL COMMENT '销户时间',
  `minimum_recharge_amount` decimal(10, 3) NULL DEFAULT NULL COMMENT '最低充值金额',
  `tenant_identification` tinyint(1) NOT NULL DEFAULT 1 COMMENT '单坐席是否停用（0否、1是）',
  `kos_tenant_id` int(0) NULL DEFAULT NULL COMMENT 'kos客户id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_agency_id`(`agency_id`) USING BTREE,
  INDEX `idx_company_id`(`company_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1055367 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_balance_bak
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_balance_bak`;
CREATE TABLE `kx_admin_tenant_balance_bak`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `balance_amount` decimal(12, 3) NOT NULL COMMENT '余额',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁标识',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `kx_admin_tenant_balance_bak`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 199561 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户余额表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_change_data
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_change_data`;
CREATE TABLE `kx_admin_tenant_change_data`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `no_call_day_count` int(0) NULL DEFAULT NULL COMMENT '无通话的天数',
  `last_day_seat_count` int(0) NULL DEFAULT NULL COMMENT '昨天坐席的数量',
  `seat_change_count` int(0) NULL DEFAULT NULL COMMENT '坐席变化数量',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20022417 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_config`;
CREATE TABLE `kx_admin_tenant_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `config_id` int(0) NOT NULL COMMENT '个性化配置ID',
  `config_category_id` int(0) NOT NULL COMMENT '配置类别ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 279 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户个性化配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_data
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_data`;
CREATE TABLE `kx_admin_tenant_data`  (
  `id` int(0) NOT NULL,
  `is_record` bit(1) NULL DEFAULT b'0' COMMENT '是否录音',
  `is_sip` bit(1) NULL DEFAULT b'0' COMMENT '是否支持SIP模式',
  `call_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '话术模板',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户扩展表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_dynamics
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_dynamics`;
CREATE TABLE `kx_admin_tenant_dynamics`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `content` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '动态内容',
  `content_type` int(0) NULL DEFAULT 10 COMMENT '动态类型 10企业动态',
  `create_user` int(0) NULL DEFAULT NULL COMMENT '操作人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29119 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_ext
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_ext`;
CREATE TABLE `kx_admin_tenant_ext`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `did` int(0) NULL DEFAULT NULL COMMENT '仟客公司id',
  `create_date` datetime(0) NULL DEFAULT NULL,
  `pid` int(0) NULL DEFAULT 0 COMMENT '管理员id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uni_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_operation_record
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_operation_record`;
CREATE TABLE `kx_admin_tenant_operation_record`  (
  `record_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `operation_type` int(0) NOT NULL COMMENT '操作类型 1-是 0-否',
  `operation_by` int(0) NOT NULL COMMENT '操作人ID',
  `operation_time` datetime(0) NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_operation_time`(`operation_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户操作记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_remaining
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_remaining`;
CREATE TABLE `kx_admin_tenant_remaining`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `call_amount` decimal(12, 3) NOT NULL COMMENT '话费余额',
  `call_duration` int(0) NOT NULL DEFAULT 0 COMMENT '剩余时长',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁标识',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_kx_admin_tenant_remaining_kx_admin_tenant_1`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14527 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户余量表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_tenant_remaining_bak
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_tenant_remaining_bak`;
CREATE TABLE `kx_admin_tenant_remaining_bak`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `call_amount` decimal(12, 3) NOT NULL COMMENT '话费余额',
  `call_duration` int(0) NOT NULL DEFAULT 0 COMMENT '剩余时长',
  `version` int(0) NOT NULL DEFAULT 0 COMMENT '乐观锁标识',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_kx_admin_tenant_remaining_kx_admin_tenant_1`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13514 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户余量表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_user
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_user`;
CREATE TABLE `kx_admin_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `employee_no` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '员工编号',
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `status` int(0) NULL DEFAULT NULL COMMENT '状态 0-禁用 1-正常 2-未激活',
  `last_login_time` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `seat_id` int(0) NULL DEFAULT 0 COMMENT '坐席ID',
  `dept_id` int(0) NOT NULL COMMENT '部门ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(0) NULL DEFAULT 0 COMMENT '删除状态：0->未删除；1->已删除',
  `deleted_version` int(0) NULL DEFAULT 0 COMMENT '删除版本',
  `pc_device_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'pc端设备id',
  `mobile_device_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '移动端设备id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_user_phone_is_deleted`(`user_phone`, `is_deleted`, `deleted_version`) USING BTREE,
  INDEX `idx_tenant_id_create_time`(`tenant_id`, `create_time`) USING BTREE,
  INDEX `idx_seat_id`(`seat_id`) USING BTREE,
  INDEX `idx_dept_id`(`dept_id`) USING BTREE,
  INDEX `idx_employee_no`(`employee_no`) USING BTREE,
  INDEX `index_2`(`user_phone`, `is_deleted`) USING BTREE,
  INDEX `index_3`(`user_phone`, `is_deleted`, `username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 533800 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_user_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_user_config`;
CREATE TABLE `kx_admin_user_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int(0) NOT NULL COMMENT '用户ID',
  `config_id` int(0) NOT NULL COMMENT '个性化配置ID',
  `config_category_id` int(0) NOT NULL COMMENT '配置类别ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14695 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户个性化配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_user_login
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_user_login`;
CREATE TABLE `kx_admin_user_login`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NULL DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `user_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `last_login_time` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `forwarded_port` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求端口',
  `login_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登录类型',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `login_method` int(0) NULL DEFAULT NULL COMMENT '1密码，2验证码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3079 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '登陆日志表，保存两个月' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_user_role
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_user_role`;
CREATE TABLE `kx_admin_user_role`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `role_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_kx_admin_user_role_kx_admin_user_1`(`user_id`) USING BTREE,
  INDEX `fk_kx_admin_user_role_kx_admin_role_1`(`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 643712 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_admin_wechat_user
-- ----------------------------
DROP TABLE IF EXISTS `kx_admin_wechat_user`;
CREATE TABLE `kx_admin_wechat_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `open_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户的标识，对当前开发者帐号唯一',
  `nick_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `gender` tinyint(1) NULL DEFAULT NULL COMMENT '用户性别，1 为男性，2 为女性',
  `province` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户个人资料填写的省份',
  `city` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户个人资料填写的城市',
  `country` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '国家，如中国为 CN',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户头像',
  `privilege` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户特权信息，json 数组，如微信沃卡用户为（chinaunicom）',
  `union_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的 unionid 是唯一的。',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 130 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_aliyun_validate
-- ----------------------------
DROP TABLE IF EXISTS `kx_aliyun_validate`;
CREATE TABLE `kx_aliyun_validate`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电话号码',
  `id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `photo_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '人脸照片链接',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `mobile_result` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '2' COMMENT '三要素识别结果 0:一致；1:不一致；2: 查无记录',
  `face_result` int(0) NULL DEFAULT 0 COMMENT '人脸识别结果，100比对成功,其他失败',
  `mobile_time` datetime(0) NULL DEFAULT NULL COMMENT '实名认证通过时间',
  `face_time` datetime(0) NULL DEFAULT NULL COMMENT '人脸识别通过时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_id_card`(`id_card`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_api_auth
-- ----------------------------
DROP TABLE IF EXISTS `kx_api_auth`;
CREATE TABLE `kx_api_auth`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `api_key_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API_KEY_ID',
  `api_key_secret` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API_SECRET_SECRET',
  `ticket_push_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '话单推送地址',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1077 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API对接表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_api_ec
-- ----------------------------
DROP TABLE IF EXISTS `kx_api_ec`;
CREATE TABLE `kx_api_ec`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `corp_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'EC企业ID',
  `app_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'APP_ID',
  `app_secret` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'APP_SECRET',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `app_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Ec话单推送专用 token',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 832 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'EC-API对接表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_api_open
-- ----------------------------
DROP TABLE IF EXISTS `kx_api_open`;
CREATE TABLE `kx_api_open`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `doc_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文档URL',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_api_tenant_relation
-- ----------------------------
DROP TABLE IF EXISTS `kx_api_tenant_relation`;
CREATE TABLE `kx_api_tenant_relation`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `status` int(0) NOT NULL DEFAULT 1 COMMENT '启停用 1-启用 2-停用',
  `open_id` int(0) NOT NULL COMMENT '对接ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1543 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API-租户关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_api_xk
-- ----------------------------
DROP TABLE IF EXISTS `kx_api_xk`;
CREATE TABLE `kx_api_xk`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `client_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'client_id',
  `client_secret` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'client_secret',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 247 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'XK-API对接表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_check_rule
-- ----------------------------
DROP TABLE IF EXISTS `kx_check_rule`;
CREATE TABLE `kx_check_rule`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规则名称',
  `check_object` int(0) NULL DEFAULT NULL COMMENT '质检对象(0卡信租户,1外部机器)',
  `applicable_type` int(0) NULL DEFAULT NULL COMMENT '适用类型(0租户，1行业)',
  `tenant_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '适用租户(-1表示所有租户,其他的多选租户用,隔开)',
  `illegal_industry_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '非法规则',
  `violation_industry_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '违规规则',
  `customer_industry_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户行业(-1表示所有行业,其他的多选行业用,隔开)',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '删除状态：0->未删除；1->已删除',
  `machine_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '机器id(-1表示所有机器,其他的多选机器用,隔开)',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_check_rule_bf
-- ----------------------------
DROP TABLE IF EXISTS `kx_check_rule_bf`;
CREATE TABLE `kx_check_rule_bf`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规则名称',
  `check_object` int(0) NULL DEFAULT NULL COMMENT '质检对象(0卡信租户,1外部机器)',
  `applicable_type` int(0) NULL DEFAULT NULL COMMENT '适用类型(0租户，1行业)',
  `tenant_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '适用租户(-1表示所有租户,其他的多选租户用,隔开)',
  `illegal_industry_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '非法规则',
  `violation_industry_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '违规规则',
  `customer_industry_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户行业(-1表示所有行业,其他的多选行业用,隔开)',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '删除状态：0->未删除；1->已删除',
  `machine_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '机器id(-1表示所有机器,其他的多选机器用,隔开)',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_area
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_area`;
CREATE TABLE `kx_crm_area`  (
  `id` int(0) NOT NULL COMMENT '编号',
  `parent_id` int(0) NULL DEFAULT NULL COMMENT '父级编号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `administrative_region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行政区划码',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省级',
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地级',
  `county` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '县级',
  `zone_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区号',
  `postcode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮编',
  `for_short` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '简称',
  `spell` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拼音',
  `logogram` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '简拼',
  `initial` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '首字母',
  `english_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '英文',
  `longitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '经度',
  `latitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '维度',
  `parent_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '父级路径',
  `level` int(0) NULL DEFAULT NULL COMMENT '级别',
  `full_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '全路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_clew_source
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_clew_source`;
CREATE TABLE `kx_crm_clew_source`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `source_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源名称',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` int(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 115581 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '线索来源' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_contact_record
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_contact_record`;
CREATE TABLE `kx_crm_contact_record`  (
  `id` bigint(0) NOT NULL,
  `type` int(0) NOT NULL DEFAULT 1 COMMENT '类型 1-普通 2-关联通话记录',
  `record_bind_id` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '通话记录标识',
  `call_duration` int(0) NULL DEFAULT NULL COMMENT '通话时长',
  `record_download_addr` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '录音下载地址',
  `contact_time` datetime(0) NOT NULL COMMENT '跟进时间',
  `owner_user_id` int(0) NOT NULL COMMENT '负责人ID',
  `content` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '跟进记录',
  `contacts_id` bigint(0) NOT NULL COMMENT '联系人ID',
  `customer_id` bigint(0) NOT NULL COMMENT '客户ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `contact_telephone_id` bigint(0) NULL DEFAULT NULL COMMENT '联系人联系电话ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_contact_telephone
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_contact_telephone`;
CREATE TABLE `kx_crm_contact_telephone`  (
  `id` bigint(0) NOT NULL,
  `telephone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系电话',
  `other_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '其他号码',
  `is_black` bit(1) NOT NULL COMMENT '是否黑名单',
  `contacts_id` bigint(0) NOT NULL COMMENT '联系人ID',
  `customer_id` bigint(0) NOT NULL COMMENT '客户ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` int(0) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_kx_crm_contact_telephone_kx_crm_customer_1`(`customer_id`) USING BTREE,
  INDEX `fk_kx_crm_contact_telephone_kx_crm_contacts_1`(`contacts_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_contacts
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_contacts`;
CREATE TABLE `kx_crm_contacts`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '联系人名称',
  `sex` int(0) NULL DEFAULT NULL COMMENT '性别',
  `next_time` datetime(0) NULL DEFAULT NULL COMMENT '下次联系时间',
  `wechat_qq` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '微信/QQ',
  `email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `post` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '职位',
  `address` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '地址 省_市_县',
  `detail_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '详细地址',
  `remark` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '备注',
  `owner_user_id` int(0) NULL DEFAULT NULL COMMENT '负责人ID',
  `last_time` datetime(0) NULL DEFAULT NULL COMMENT '最后跟进时间',
  `customer_id` bigint(0) NOT NULL COMMENT '客户ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` int(0) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '最后修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` bit(1) NULL DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `owner_user_id`(`owner_user_id`) USING BTREE,
  INDEX `customer_id`(`customer_id`) USING BTREE,
  CONSTRAINT `fk_kx_crm_contacts_kx_crm_customer_1` FOREIGN KEY (`customer_id`) REFERENCES `kx_crm_customer` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '联系人表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_customer
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_customer`;
CREATE TABLE `kx_crm_customer`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `data_type` int(0) NOT NULL COMMENT '数据类型 1-线索 2-商机 3-客户',
  `position` int(0) NOT NULL COMMENT '客户位置 1-我的客户 2-客户公海',
  `customer_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '客户名称',
  `followup` int(0) NOT NULL DEFAULT 0 COMMENT '跟进状态 0 未跟进 1 已跟进',
  `next_time` datetime(0) NULL DEFAULT NULL COMMENT '下次联系时间',
  `deal_status` int(0) NOT NULL DEFAULT 0 COMMENT '成交状态 0 未成交 1 已成交',
  `deal_time` datetime(0) NULL DEFAULT NULL COMMENT '成交时间',
  `label_ids` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '标签',
  `remark` varchar(3000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注',
  `owner_user_id` int(0) NULL DEFAULT NULL COMMENT '负责人ID',
  `collaborator_ids` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '协作人ID',
  `last_time` datetime(0) NULL DEFAULT NULL COMMENT '最后跟进时间',
  `pool_time` datetime(0) NULL DEFAULT NULL COMMENT '放入公海时间',
  `pool_type` int(0) NULL DEFAULT NULL COMMENT '放入公海类型 1 新增 2 放弃',
  `status` int(0) NULL DEFAULT 1 COMMENT '客户状态 1 正常 2 锁定 3 删除',
  `is_receive` int(0) NULL DEFAULT NULL COMMENT '1 分配 2 领取',
  `give_up_reason` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '放弃原因',
  `last_content` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后一条跟进记录',
  `receive_time` datetime(0) NULL DEFAULT NULL COMMENT '接收到客户时间',
  `pre_owner_user_id` int(0) NULL DEFAULT NULL COMMENT '进入公海前负责人ID',
  `source_id` int(0) NULL DEFAULT NULL COMMENT '来源ID',
  `industry` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '行业 一级行业ID_二级行业ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` int(0) NOT NULL COMMENT '创建人ID',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人ID',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `owner_user_id`(`owner_user_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  CONSTRAINT `fk_kx_crm_customer_kx_admin_user_1` FOREIGN KEY (`owner_user_id`) REFERENCES `kx_admin_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '客户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_customer_industry
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_customer_industry`;
CREATE TABLE `kx_crm_customer_industry`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `industry_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行业名称',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` int(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1039793 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户行业' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_customer_pool
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_customer_pool`;
CREATE TABLE `kx_crm_customer_pool`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '公海id',
  `pool_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公海名称',
  `admin_user_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '管理员 “,”分割',
  `member_user_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '公海规则员工成员 “,”分割',
  `member_dept_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '公海规则部门成员 “,”分割',
  `status` int(0) NOT NULL DEFAULT 1 COMMENT '状态 0 停用 1启用',
  `pre_owner_setting` int(0) NOT NULL COMMENT '前负责人领取规则 0不限制 1限制',
  `pre_owner_setting_day` int(0) NULL DEFAULT NULL COMMENT '前负责人领取规则限制天数',
  `receive_setting` int(0) NOT NULL COMMENT '是否限制领取频率 0不限制 1限制',
  `receive_num` int(0) NULL DEFAULT NULL COMMENT '领取频率规则',
  `remind_setting` int(0) NOT NULL COMMENT '是否设置提前提醒 0不开启 1开启',
  `remind_day` int(0) NULL DEFAULT NULL COMMENT '提醒规则天数',
  `put_in_rule` int(0) NOT NULL COMMENT '收回规则 0不自动收回 1自动收回',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` int(0) NOT NULL COMMENT '创建人ID',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公海表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_customer_pool_reason
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_customer_pool_reason`;
CREATE TABLE `kx_crm_customer_pool_reason`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `reason` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '原因',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` int(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_tenant_id_reason`(`reason`, `tenant_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 98591 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户放弃公海原因' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_customer_pool_relation
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_customer_pool_relation`;
CREATE TABLE `kx_crm_customer_pool_relation`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `customer_id` int(0) NOT NULL COMMENT '客户id',
  `pool_id` int(0) NOT NULL COMMENT '公海id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pool_id`(`pool_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户公海关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_customer_rule
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_customer_rule`;
CREATE TABLE `kx_crm_customer_rule`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规则名称',
  `customer_upper_limit` int(0) NULL DEFAULT NULL COMMENT '客户上限数',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '1启用 0禁用',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` int(0) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户上限规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_customer_source
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_customer_source`;
CREATE TABLE `kx_crm_customer_source`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `source_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源名称',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `update_by` int(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 114962 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户来源' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_global_rule_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_global_rule_config`;
CREATE TABLE `kx_crm_global_rule_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `rule_type` int(0) NOT NULL COMMENT '规则类型 1-公海领取规则 2-公海回收规则',
  `rule_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则名称',
  `rule_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则编码',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公海规则配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_industry
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_industry`;
CREATE TABLE `kx_crm_industry`  (
  `id` bigint(0) NOT NULL COMMENT '主键',
  `parent_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '父编码',
  `industry_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行业编码',
  `industry_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行业名称',
  `describes` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `category_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '门类代码',
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '门类名称',
  `categories_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '大类代码',
  `categories_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '大类名称',
  `medium_class_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中类代码',
  `medium_class_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中类名称',
  `subclass_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小类代码',
  `subclass_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小类名称',
  `level` int(0) NULL DEFAULT NULL COMMENT '等级',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_code`(`category_code`, `categories_code`, `medium_class_code`, `subclass_code`) USING BTREE COMMENT '行业四级搜索联合索引',
  INDEX `industry_code`(`industry_code`) USING BTREE,
  INDEX `category_code_2`(`category_code`) USING BTREE,
  INDEX `medium_class_code`(`medium_class_code`) USING BTREE,
  INDEX `subclass_code`(`subclass_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '行业表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_label
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_label`;
CREATE TABLE `kx_crm_label`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `label_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名称',
  `group_id` int(0) NOT NULL COMMENT '标签组id',
  `is_choose` tinyint(1) NULL DEFAULT NULL COMMENT '是否已选择',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` bit(1) NULL DEFAULT b'0' COMMENT '删除状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_kx_crm_label_kx_crm_label_group_1`(`group_id`) USING BTREE,
  INDEX `index_0`(`tenant_id`, `is_deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 78485 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '标签' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_label_group
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_label_group`;
CREATE TABLE `kx_crm_label_group`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `label_group_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签分组名',
  `options_type` int(0) NULL DEFAULT NULL COMMENT '选项类型',
  `sort` int(0) NOT NULL COMMENT '排序',
  `is_default` tinyint(1) NULL DEFAULT NULL COMMENT '是否默认分组',
  `tenant_id` int(0) NOT NULL COMMENT '租户id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人id',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人id',
  `is_deleted` bit(1) NULL DEFAULT b'0' COMMENT '删除状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13195 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_rule_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_rule_config`;
CREATE TABLE `kx_crm_rule_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NOT NULL COMMENT '租户id',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '用户id',
  `global_rule_id` int(0) NOT NULL COMMENT '全局规则id',
  `days` int(0) NULL DEFAULT NULL COMMENT '天数',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1启用 0禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 512 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公海规则关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_crm_user_rule
-- ----------------------------
DROP TABLE IF EXISTS `kx_crm_user_rule`;
CREATE TABLE `kx_crm_user_rule`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NULL DEFAULT NULL COMMENT '用户id',
  `rule_id` int(0) NULL DEFAULT NULL COMMENT '规则id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 992 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户-客户上限规则关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_dial_code
-- ----------------------------
DROP TABLE IF EXISTS `kx_dial_code`;
CREATE TABLE `kx_dial_code`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `product_id` int(0) NOT NULL COMMENT '产品id',
  `operator_code` int(0) NOT NULL COMMENT '运营商代码',
  `operator_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运营商详情',
  `applause_code` int(0) NOT NULL COMMENT '掌讯代码',
  `applause_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '掌讯详情',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_job_num_industry_key
-- ----------------------------
DROP TABLE IF EXISTS `kx_job_num_industry_key`;
CREATE TABLE `kx_job_num_industry_key`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `industry_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行业名称',
  `app_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `app_secret_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账号名称',
  `type` int(0) NULL DEFAULT NULL COMMENT '类型(1为长沙工作号接口文档，2为广东翔翼接口文档)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_detect_config_log
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_detect_config_log`;
CREATE TABLE `kx_record_detect_config_log`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NULL DEFAULT NULL,
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `operate_type` int(0) NULL DEFAULT NULL COMMENT '操作类型1新增2删除',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `keywords` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关键词',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 488 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_detect_result
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_detect_result`;
CREATE TABLE `kx_record_detect_result`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `circuit_id` int(0) NULL DEFAULT NULL COMMENT '线路id',
  `file_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件id',
  `byte_size` int(0) NULL DEFAULT NULL COMMENT '文件大小',
  `call_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫',
  `peer_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '被叫',
  `call_time` datetime(0) NULL DEFAULT NULL COMMENT '呼叫时间',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始时间',
  `finish_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `duration` int(0) NULL DEFAULT NULL COMMENT '时长',
  `record_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '录音地址',
  `record_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '质检文本',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `detect_type` tinyint(1) NULL DEFAULT NULL COMMENT '0非法 1合法',
  `keywords` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关键字',
  `detect_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '质检时间',
  `detect_result` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `review_status` tinyint(1) NULL DEFAULT 0 COMMENT '复核状态',
  `review_time` datetime(0) NULL DEFAULT NULL COMMENT '复核时间',
  `return_time` datetime(0) NULL DEFAULT NULL COMMENT '质检结果返回时间',
  `reviewer_id` int(0) NULL DEFAULT NULL,
  `reviewer_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `industry_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属行业',
  `real_duration` int(0) NULL DEFAULT NULL COMMENT '录音真实时长，毫秒',
  `check_type` int(0) NULL DEFAULT NULL COMMENT '第三方检测0磐石云，1多方，2科大讯飞',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `file_id`(`file_id`) USING BTREE,
  INDEX `detect_time`(`detect_time`) USING BTREE,
  INDEX `tenant_id`(`tenant_id`) USING BTREE,
  INDEX `call_no`(`call_no`) USING BTREE,
  INDEX `return_time`(`return_time`) USING BTREE,
  INDEX `index_0`(`call_time`) USING BTREE,
  INDEX `review_index`(`review_time`) USING BTREE,
  INDEX `index_1`(`tenant_id`, `review_status`, `call_time`) USING BTREE,
  INDEX `index_2`(`start_time`) USING BTREE,
  INDEX `index_3`(`finish_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15485750 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_detect_setting
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_detect_setting`;
CREATE TABLE `kx_record_detect_setting`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `min_duration` int(0) NULL DEFAULT NULL COMMENT '最低时长',
  `max_duration` int(0) NULL DEFAULT NULL COMMENT '最大时长',
  `line_mode` int(0) NULL DEFAULT NULL COMMENT '线路id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1-线路 2-租户',
  `finish_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 254 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_detect_statistics
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_detect_statistics`;
CREATE TABLE `kx_record_detect_statistics`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `detect_date` date NULL DEFAULT NULL COMMENT '质检日期',
  `connect_num` int(0) NULL DEFAULT NULL COMMENT '接通数',
  `detect_num` int(0) NULL DEFAULT NULL COMMENT '质检数',
  `review_num` int(0) NULL DEFAULT NULL COMMENT '复核数',
  `review_rate` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '复核率',
  `reviewer_ids` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '复核人id',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4834292 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_industry
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_industry`;
CREATE TABLE `kx_record_industry`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `industry_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行业名称',
  `parent_id` int(0) NULL DEFAULT NULL COMMENT '父行业id',
  `lib_id` int(0) NULL DEFAULT NULL COMMENT '文本库id',
  `industry_type` int(0) NULL DEFAULT NULL COMMENT '0敏感词,1行业词,2合法词',
  `general_special` int(0) NULL DEFAULT 0 COMMENT '0专用，1通用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 95 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_industry_bf
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_industry_bf`;
CREATE TABLE `kx_record_industry_bf`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `industry_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行业名称',
  `parent_id` int(0) NULL DEFAULT NULL COMMENT '父行业id',
  `lib_id` int(0) NULL DEFAULT NULL COMMENT '文本库id',
  `industry_type` int(0) NULL DEFAULT NULL COMMENT '0敏感词,1行业词,2合法词',
  `general_special` int(0) NULL DEFAULT 0 COMMENT '0专用，1通用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 92 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_keyword
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_keyword`;
CREATE TABLE `kx_record_keyword`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `industry_id` int(0) NULL DEFAULT NULL COMMENT '行业id',
  `keyword` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关键字',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '0非法关键字,1行业关键字,合法关键字',
  `lib_id` int(0) NULL DEFAULT NULL COMMENT '文本库id',
  `keyword_id` int(0) NULL DEFAULT NULL COMMENT '关键字id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21001 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_keyword_bf
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_keyword_bf`;
CREATE TABLE `kx_record_keyword_bf`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `industry_id` int(0) NULL DEFAULT NULL COMMENT '行业id',
  `keyword` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关键字',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '0非法关键字,1行业关键字,合法关键字',
  `lib_id` int(0) NULL DEFAULT NULL COMMENT '文本库id',
  `keyword_id` int(0) NULL DEFAULT NULL COMMENT '关键字id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21000 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_pre_detect
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_pre_detect`;
CREATE TABLE `kx_record_pre_detect`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL,
  `circuit_id` int(0) NULL DEFAULT NULL,
  `call_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `peer_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `call_time` datetime(0) NULL DEFAULT NULL,
  `start_time` datetime(0) NULL DEFAULT NULL,
  `finish_time` datetime(0) NULL DEFAULT NULL,
  `call_duration` int(0) NULL DEFAULT NULL,
  `record_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` tinyint(1) NULL DEFAULT NULL,
  `detect` tinyint(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `finish_time`(`finish_time`) USING BTREE,
  INDEX `call_time`(`call_time`) USING BTREE,
  INDEX `detect`(`detect`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13942523 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_pre_download
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_pre_download`;
CREATE TABLE `kx_record_pre_download`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL,
  `supplier_id` int(0) NULL DEFAULT NULL,
  `mkdir` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `file_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `record_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `call_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `xiaoke` tinyint(1) NULL DEFAULT NULL,
  `is_download` tinyint(1) NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `product_id` int(0) NULL DEFAULT NULL,
  `download_count` int(0) NULL DEFAULT 0 COMMENT '下载次数',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `duration` int(0) NULL DEFAULT 0 COMMENT '时长',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `is_download`(`is_download`) USING BTREE,
  INDEX `index_0`(`is_download`, `supplier_id`, `create_time`) USING BTREE,
  INDEX `index_1`(`call_id`) USING BTREE,
  INDEX `index_2`(`create_time`) USING BTREE,
  INDEX `index_4`(`create_time`, `is_download`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 142772306 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_record_task
-- ----------------------------
DROP TABLE IF EXISTS `kx_record_task`;
CREATE TABLE `kx_record_task`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `last_detect_time` datetime(0) NULL DEFAULT NULL COMMENT '最后质检时间',
  `detect_type` tinyint(1) NULL DEFAULT 1 COMMENT '质检类型 0非法 1合法',
  `register_result` tinyint(1) NULL DEFAULT 0 COMMENT '登记结果 0未知 1符合 2 不符合 ',
  `detect_count` int(0) NOT NULL DEFAULT 0 COMMENT '质检次数',
  `today_detect_count` int(0) NOT NULL DEFAULT 0 COMMENT '今日质检次数',
  `note` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登记备注',
  `register_time` datetime(0) NULL DEFAULT NULL COMMENT '登记时间',
  `call_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '话术模板',
  `reviewer_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '复核人id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13413 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_robot_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_robot_config`;
CREATE TABLE `kx_robot_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '机器人平台标识',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '机器人平台鉴权密钥',
  `url` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '机器人平台地址',
  `work_times` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工作时间（格式HH:mm-HH:mm,HH:mm-HH:mm）多个逗号分隔',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '添加人',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` int(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '机器人配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_robot_task
-- ----------------------------
DROP TABLE IF EXISTS `kx_robot_task`;
CREATE TABLE `kx_robot_task`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `task_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `status` int(0) NULL DEFAULT NULL COMMENT '任务状态：0未开始，1进行中，2已暂停，3已完成，4已关闭',
  `concurrency` int(0) NULL DEFAULT NULL COMMENT '并发数（AI坐席数）',
  `task_total` int(0) NULL DEFAULT NULL COMMENT '任务总数',
  `finish_total` int(0) NULL DEFAULT 0 COMMENT '已拨打数（关闭任务后有值）',
  `max_fail_count` int(0) NULL DEFAULT NULL COMMENT '连续最大失败次数',
  `talk_id` int(0) NULL DEFAULT NULL COMMENT '话术id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '任务开始时间',
  `create_by` int(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI机器人任务' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_sys_code
-- ----------------------------
DROP TABLE IF EXISTS `kx_sys_code`;
CREATE TABLE `kx_sys_code`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `applause_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '掌讯代码',
  `applause_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '掌讯详情',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `error_type` int(0) NULL DEFAULT NULL COMMENT '1掌讯错误码，2第三方错误码',
  `select_language` tinyint(0) NULL DEFAULT 1 COMMENT '语言选择，默认为1，中文',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_sys_product_code
-- ----------------------------
DROP TABLE IF EXISTS `kx_sys_product_code`;
CREATE TABLE `kx_sys_product_code`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `product_id` int(0) NOT NULL COMMENT '产品id',
  `operator_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运营商代码',
  `operator_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运营商详情',
  `applause_code_id` int(0) NOT NULL COMMENT '掌讯代码id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `remark` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 184 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_ability_num
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_ability_num`;
CREATE TABLE `kx_work_ability_num`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `ability_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '能力号',
  `mode_id` int(0) NULL DEFAULT NULL COMMENT '模式id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `is_deleted` bit(1) NULL DEFAULT NULL COMMENT '是否删除',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '添加人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  `status` int(0) NULL DEFAULT NULL COMMENT '0 未激活 1待复机 2正常',
  `bs` bit(1) NULL DEFAULT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ability_num`(`ability_phone`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26528 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '能力号表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_ability_num_statistics
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_ability_num_statistics`;
CREATE TABLE `kx_work_ability_num_statistics`  (
  `id` bigint(0) NOT NULL,
  `ability_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '能力号',
  `last_time` datetime(0) NULL DEFAULT NULL COMMENT '最近拨打时间',
  `call_duration` int(0) NULL DEFAULT NULL COMMENT '通话累计分钟数',
  `call_duration_second` int(0) NULL DEFAULT NULL COMMENT '通话累计时长（秒）',
  `save_month` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统计月份',
  `ts` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ap`(`ability_phone`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '能力号统计数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_ability_options
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_ability_options`;
CREATE TABLE `kx_work_ability_options`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `old_id` int(0) NULL DEFAULT NULL COMMENT '原id',
  `ability_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '能力号',
  `mode_id` int(0) NULL DEFAULT NULL COMMENT '模式id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `is_deleted` bit(1) NULL DEFAULT NULL COMMENT '是否删除',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '添加人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  `status` int(0) NULL DEFAULT NULL COMMENT '0 未激活 1待复机 2正常',
  `bs` bit(1) NULL DEFAULT NULL COMMENT '是否启用',
  `option_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `option_user` int(0) NULL DEFAULT NULL COMMENT '操作人',
  `option_type` int(0) NULL DEFAULT NULL COMMENT '类型1删除 2更改',
  `new_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '新能力号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13608 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '能力号删除记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_agency_rate_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_agency_rate_config`;
CREATE TABLE `kx_work_agency_rate_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `agency_id` int(0) NOT NULL COMMENT '代理ID',
  `level` int(0) NULL DEFAULT NULL COMMENT '层级',
  `product_id` int(0) NOT NULL COMMENT '产品id',
  `call_duration` int(0) NOT NULL COMMENT '低消分钟数（分钟）',
  `batch_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '费用配置编码',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除标识',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_bacth_code`(`batch_code`) USING BTREE,
  INDEX `idx_agency_id`(`agency_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3694 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代理费率配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_app_device_model
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_app_device_model`;
CREATE TABLE `kx_work_app_device_model`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `device_model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '品牌型号',
  `brand` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '品牌',
  `rom_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用的系统名称',
  `system_version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '安卓版本',
  `user_phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户号码',
  `device` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '设备id',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `app_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'app版本',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_0`(`user_phone`, `device_model`, `system_version`, `brand`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2169234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'app设备型号' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_app_error_info
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_app_error_info`;
CREATE TABLE `kx_work_app_error_info`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `error_time` datetime(0) NULL DEFAULT NULL COMMENT '发生异常时间',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '异常信息',
  `interface_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口名称',
  `app_version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'APP版本',
  `user_phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登录账号',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42930615 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'app异常信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_app_version
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_app_version`;
CREATE TABLE `kx_work_app_version`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `new_version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '新版本号',
  `is_update` bit(1) NULL DEFAULT NULL COMMENT '是否强制更新',
  `url` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下载地址',
  `update_desc` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '新版本描述',
  `affect` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '影响版本，多个逗号分割',
  `device` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '设备id组,逗号分隔',
  `full` bit(1) NULL DEFAULT b'1' COMMENT '是否全量更新',
  `bs` bit(1) NULL DEFAULT NULL COMMENT '记录是否有效',
  `tenant_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '租户id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '新版上线时间',
  `update_time` datetime(0) NULL DEFAULT NULL,
  `create_by` int(0) NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'wgt表示热更新',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'APP版本控制' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_black_cost
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_black_cost`;
CREATE TABLE `kx_work_black_cost`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `cost_id` int(0) NULL DEFAULT NULL COMMENT '关联相关扣费id',
  `per_cost` decimal(10, 5) NULL DEFAULT NULL COMMENT '每次检测的费用',
  `cost_type` int(0) NULL DEFAULT 1 COMMENT '扣费类型，1黑名单',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3916 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_black_detail
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_black_detail`;
CREATE TABLE `kx_work_black_detail`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理ID',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司ID',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `blacklist_id` int(0) NULL DEFAULT NULL COMMENT '黑名单id',
  `black_company` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '黑名单公司',
  `req_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `caller` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫',
  `callee` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '被叫',
  `eval_result` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '验证结果',
  `result_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口请求结果code',
  `result_msg` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口请求结果msg',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `index_black_id`(`blacklist_id`) USING BTREE,
  INDEX `index_product_id`(`product_id`) USING BTREE,
  INDEX `index_result`(`eval_result`) USING BTREE,
  INDEX `index_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34049607 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '黑名单调用详细记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_black_phone
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_black_phone`;
CREATE TABLE `kx_work_black_phone`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电话号码',
  `source` int(0) NULL DEFAULT NULL COMMENT '数据来源 1手动添加 2批量导入 3客户模块添加',
  `create_user` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `is_deleted` int(0) NULL DEFAULT 0 COMMENT '是否删除 0否1是',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `industry_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `black_txt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '通话文本',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_0`(`phone`, `tenant_id`, `is_deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 612656 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '黑名单号码表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_black_statistics
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_black_statistics`;
CREATE TABLE `kx_work_black_statistics`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `create_date` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日期',
  `create_month` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '月份',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  `user_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '坐席号码',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '用户id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理id',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司id',
  `black_id` int(0) NULL DEFAULT NULL COMMENT '黑名单id',
  `black_company` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '黑名单公司',
  `all_count` int(0) NULL DEFAULT NULL COMMENT '总检验数',
  `success_count` int(0) NULL DEFAULT 0 COMMENT '是黑名单数',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 293594 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '黑名单统计汇总表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_blacklist_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_blacklist_config`;
CREATE TABLE `kx_work_blacklist_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '检测商名称',
  `app_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户ID',
  `app_secret` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密钥',
  `request_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求地址',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '黑名单类型 1-启呼 2-电话邦 3-东云黑名单',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '启用状态 1启用 0停用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_call_statistics
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_call_statistics`;
CREATE TABLE `kx_work_call_statistics`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `call_date` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统计日期yyyy-MM-dd',
  `user_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '员工标识',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司标识',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理标识',
  `call_duration` int(0) NULL DEFAULT NULL COMMENT '通话时长（分钟）',
  `call_duration_second` int(0) NULL DEFAULT NULL COMMENT '通话时长（秒）',
  `call_num` int(0) NULL DEFAULT NULL COMMENT '拨打数',
  `connect_num` int(0) NULL DEFAULT NULL COMMENT '接听数',
  `create_by` int(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT NULL,
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  `sip_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sipNo',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `call_date`(`call_date`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `index_0`(`tenant_id`, `call_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 356901670 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通话统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_call_statistics_bf
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_call_statistics_bf`;
CREATE TABLE `kx_work_call_statistics_bf`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `call_date` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统计日期yyyy-MM-dd',
  `user_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '员工标识',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司标识',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理标识',
  `call_duration` int(0) NULL DEFAULT NULL COMMENT '通话时长（分钟）',
  `call_duration_second` int(0) NULL DEFAULT NULL COMMENT '通话时长（秒）',
  `call_num` int(0) NULL DEFAULT NULL COMMENT '拨打数',
  `connect_num` int(0) NULL DEFAULT NULL COMMENT '接听数',
  `create_by` int(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT NULL,
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `call_date`(`call_date`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `index_0`(`tenant_id`, `call_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 335855880 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通话统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_call_statistics_month
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_call_statistics_month`;
CREATE TABLE `kx_work_call_statistics_month`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `call_date` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统计日期yyyy-MM',
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '员工标识',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司标识',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理标识',
  `call_duration` int(0) NULL DEFAULT NULL COMMENT '通话时长（分钟）',
  `call_duration_second` int(0) NULL DEFAULT NULL COMMENT '通话时长（秒）',
  `call_num` int(0) NULL DEFAULT NULL COMMENT '拨打数',
  `connect_num` int(0) NULL DEFAULT NULL COMMENT '接听数',
  `create_by` int(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT NULL,
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `call_date`(`call_date`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 582260 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通话统计-月度' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_call_task
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_call_task`;
CREATE TABLE `kx_work_call_task`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务描述',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `status` int(0) NULL DEFAULT 0 COMMENT '任务状态：0未完成，1，已完成',
  `assignable_count` int(0) NULL DEFAULT NULL COMMENT '可领取数量',
  `count` int(0) NULL DEFAULT NULL COMMENT '任务号码总数',
  `auto_recovery` bit(1) NULL DEFAULT b'0' COMMENT '是否自动回收',
  `get_count` int(0) NULL DEFAULT 200 COMMENT '可领取数量',
  `can_receive` bit(1) NULL DEFAULT b'1' COMMENT '是否可领取',
  `is_allocation` bit(1) NULL DEFAULT b'0' COMMENT '是否分配',
  `is_complete` bit(1) NULL DEFAULT b'0' COMMENT '是否完成',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '添加人',
  `is_deleted` bit(1) NULL DEFAULT b'0' COMMENT '数量是否失效',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127385 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '呼叫任务' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_call_task_user
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_call_task_user`;
CREATE TABLE `kx_work_call_task_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `call_task_id` int(0) NULL DEFAULT NULL COMMENT '租户标识',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '所属人',
  `count` int(0) NULL DEFAULT NULL COMMENT '客户总数',
  `get_type` int(0) NULL DEFAULT NULL COMMENT '数据来源：1领取；2分配',
  `is_complete` bit(1) NULL DEFAULT b'0' COMMENT '是否完成',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '添加人',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `call_task_id`(`call_task_id`, `user_id`) USING BTREE,
  INDEX `call_task_id_2`(`call_task_id`) USING BTREE,
  INDEX `get_type`(`get_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 379503 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务员工表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_corp_change_verify
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_corp_change_verify`;
CREATE TABLE `kx_work_corp_change_verify`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `application_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请标识',
  `corp_change_reason` int(0) NOT NULL COMMENT '企业变更原因',
  `status` int(0) NOT NULL DEFAULT 1 COMMENT '0-待审核 1-审核通过 2-驳回',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `old_corp_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '旧企业名称',
  `new_corp_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '新企业名称',
  `business_license_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业执照号',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_application_no`(`application_no`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 129 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '企业变更申请审核表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_corp_verify
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_corp_verify`;
CREATE TABLE `kx_work_corp_verify`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `application_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请标识',
  `status` int(0) NOT NULL DEFAULT 1 COMMENT '0-待审核 1-审核通过 2-驳回',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理ID',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司ID',
  `settlement_type` int(0) NULL DEFAULT 1 COMMENT '结算类型 1-自然月 2-周期',
  `level` int(0) NULL DEFAULT NULL COMMENT '企业层级 0-平台 1-公司 2-代理 3-普通租户',
  `corp_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '企业名称',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系号码',
  `business_license_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业执照号',
  `id_card_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除',
  `contract_seat_num` int(0) NULL DEFAULT 0 COMMENT '合同坐席数限制',
  `contract_month_num` int(0) NULL DEFAULT 2 COMMENT '合同月份数',
  `usable_seat_num` int(0) NULL DEFAULT 0 COMMENT '可加坐席数',
  `billing_method` int(0) NULL DEFAULT 1 COMMENT '计费方式 1主叫侧 2被叫侧',
  `role_id` int(0) NULL DEFAULT NULL COMMENT '角色id',
  `low_cost_type` int(0) NULL DEFAULT 0 COMMENT '低消模式0关联租户套餐分钟数，1不关联租户套餐分钟数',
  `customer_industry` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户行业',
  `tenant_identification` tinyint(1) NOT NULL DEFAULT 1 COMMENT '单坐席是否停用（0否、1是）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_application_no`(`application_no`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_company_id`(`company_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12329 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户申请审核表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_cost_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_cost_config`;
CREATE TABLE `kx_work_cost_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `global_cost_config_id` int(0) NOT NULL COMMENT '全局费用配置ID',
  `cost_value` decimal(12, 3) NOT NULL COMMENT '费用值',
  `discount` int(0) NULL DEFAULT 100 COMMENT '折扣 n%',
  `batch_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '费用配置编码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `global_cost_config_id`(`global_cost_config_id`, `batch_code`) USING BTREE,
  INDEX `idx_batch_code`(`batch_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 60053 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '费用配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_deduction
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_deduction`;
CREATE TABLE `kx_work_deduction`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `bill_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账单号',
  `batch_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '批次号',
  `deduction_type` int(0) NOT NULL COMMENT '计费类型',
  `deduction_amount` decimal(15, 3) NOT NULL COMMENT '扣除金额',
  `deduction_count` int(0) NULL DEFAULT 1 COMMENT '扣除项数量',
  `relation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '各计费项关联体现（如坐席费，记录哪个坐席）',
  `after_amount` decimal(15, 3) NULL DEFAULT NULL COMMENT '扣费后的余额',
  `global_cost_config_id` int(0) NULL DEFAULT NULL COMMENT '全局费用配置ID',
  `deduction_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '扣费日期',
  `deduction_month` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '扣费月份',
  `settlement_type` int(0) NULL DEFAULT 1 COMMENT '结算类型 1-自然月 2-周期',
  `settlement_date` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '月结日',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `remark` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `bill_no`(`bill_no`) USING BTREE,
  INDEX `batch_number`(`batch_number`, `deduction_type`) USING BTREE,
  INDEX `index_0`(`deduction_type`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2403544 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '扣费明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_deduction_error
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_deduction_error`;
CREATE TABLE `kx_work_deduction_error`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `set_meal_id` int(0) NULL DEFAULT NULL COMMENT '租户套餐主键',
  `product_id` int(0) NULL DEFAULT 0 COMMENT '产品id',
  `create_time` datetime(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户套餐扣费异常' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_dr_compare
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_dr_compare`;
CREATE TABLE `kx_work_dr_compare`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `ftp_config_id` int(0) NOT NULL COMMENT 'FTP配置ID',
  `file_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名称',
  `compare_time` datetime(0) NOT NULL COMMENT '比对时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_file_name`(`ftp_config_id`, `file_name`) USING BTREE,
  INDEX `idx_ftp_config_id`(`ftp_config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话单比对历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_dr_compare_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_dr_compare_config`;
CREATE TABLE `kx_work_dr_compare_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `service_provider_type` int(0) NOT NULL COMMENT '服务商类型',
  `ftp_host` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ftp_host',
  `ftp_port` int(0) NOT NULL DEFAULT 0 COMMENT 'ftp_port',
  `ftp_username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ftp_username',
  `ftp_password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ftp_password',
  `ftp_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ftp_path',
  `ftp_connect_mode` int(0) NOT NULL DEFAULT 1 COMMENT '连接方式 1:FTP 2:SFTP',
  `interval_minutes` int(0) NOT NULL DEFAULT 5 COMMENT '间隔时间（分钟）',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `enable_stop` bit(1) NOT NULL DEFAULT b'1' COMMENT '开启停用',
  `stop_switch` bit(1) NULL DEFAULT b'0' COMMENT '是否自动停机0否1是',
  `lose_num` int(0) NULL DEFAULT NULL COMMENT '空缺次数进行自动关停',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '虚商话单比对配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_dr_compare_config_bak
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_dr_compare_config_bak`;
CREATE TABLE `kx_work_dr_compare_config_bak`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `service_provider_type` int(0) NOT NULL COMMENT '服务商类型',
  `ftp_host` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ftp_host',
  `ftp_port` int(0) NOT NULL DEFAULT 0 COMMENT 'ftp_port',
  `ftp_username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ftp_username',
  `ftp_password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ftp_password',
  `ftp_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ftp_path',
  `ftp_connect_mode` int(0) NOT NULL DEFAULT 1 COMMENT '连接方式 1:FTP 2:SFTP',
  `interval_minutes` int(0) NOT NULL DEFAULT 5 COMMENT '间隔时间（分钟）',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `enable_stop` bit(1) NOT NULL DEFAULT b'1' COMMENT '开启停用',
  `stop_switch` bit(1) NULL DEFAULT b'0' COMMENT '是否自动停机0否1是',
  `lose_num` int(0) NULL DEFAULT NULL COMMENT '空缺次数进行自动关停',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '虚商话单比对配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_dr_compare_data
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_dr_compare_data`;
CREATE TABLE `kx_work_dr_compare_data`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `user_id` int(0) NOT NULL DEFAULT 0 COMMENT '用户ID',
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主叫号码',
  `call_number` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '被叫号码',
  `p_start_time` datetime(0) NULL DEFAULT NULL COMMENT '服务商话单开始时间',
  `k_start_time` datetime(0) NULL DEFAULT NULL COMMENT '平台话单开始时间',
  `p_end_time` datetime(0) NULL DEFAULT NULL COMMENT '服务商话单结束时间',
  `k_end_time` datetime(0) NULL DEFAULT NULL COMMENT '平台话单结束时间',
  `p_call_duration` int(0) NULL DEFAULT NULL COMMENT '服务商话单通话时长',
  `k_call_duration` int(0) NULL DEFAULT NULL COMMENT '平台话单通话时长',
  `compare_status` int(0) NOT NULL COMMENT '比对状态',
  `compare_id` bigint(0) NOT NULL COMMENT '关联比对信息ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_user_phone`(`user_phone`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_compare_id`(`compare_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1798899 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话单比对表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_dr_compare_properties
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_dr_compare_properties`;
CREATE TABLE `kx_work_dr_compare_properties`  (
  `id` int(0) NOT NULL COMMENT '主键ID',
  `param_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数名称',
  `param_value` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数值',
  `compare_config_id` int(0) NOT NULL COMMENT '比对配置ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话单比对虚商参数表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_dr_compare_pwl
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_dr_compare_pwl`;
CREATE TABLE `kx_work_dr_compare_pwl`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `telephone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1629948 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话单比对号码白名单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_dr_compare_relation
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_dr_compare_relation`;
CREATE TABLE `kx_work_dr_compare_relation`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主叫号码',
  `is_stop` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否关停',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_user_phone`(`user_phone`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话单比对关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_examine
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_examine`;
CREATE TABLE `kx_work_examine`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `batch_id` int(0) NULL DEFAULT NULL COMMENT '批次ID',
  `application_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请标识',
  `examine_type` int(0) NULL DEFAULT NULL COMMENT '审批类型',
  `examine_status` int(0) NOT NULL DEFAULT 1 COMMENT '审批状态 1-待审核 2-通过 3-驳回 4-未通过',
  `examine_time` datetime(0) NULL DEFAULT NULL COMMENT '审批时间',
  `examine_by` int(0) NULL DEFAULT NULL COMMENT '审批人',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `data` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求数据',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_application_no`(`application_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8452 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_file
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_file`;
CREATE TABLE `kx_work_file`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `type` int(0) NOT NULL DEFAULT 2 COMMENT '类型 1-本地 2-阿里云 3-腾讯云',
  `original_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件原名',
  `name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `suffix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件后缀',
  `path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件路径',
  `size` bigint(0) NOT NULL COMMENT '文件大小',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73969 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_financial_bill
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_financial_bill`;
CREATE TABLE `kx_work_financial_bill`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `bill_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账单号',
  `type` int(0) NOT NULL COMMENT '收支类型 1-收入 2-支出',
  `source` int(0) NOT NULL COMMENT '收支来源',
  `amount` decimal(12, 3) NOT NULL COMMENT '金额',
  `after_amount` decimal(12, 3) NOT NULL COMMENT '收支后余额',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人ID',
  `is_deleted` bit(1) NULL DEFAULT b'0' COMMENT '逻辑删除',
  `source_tenant_id` int(0) NULL DEFAULT NULL COMMENT '来源租户ID',
  `source_tenant_amount` decimal(12, 3) NULL DEFAULT NULL COMMENT '来源租户金额',
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账单备注',
  `create_month` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收支月份',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_bill_no`(`bill_no`) USING BTREE,
  INDEX `idx_tenant_id_create_time`(`tenant_id`, `create_time`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_create_month`(`create_month`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22508774 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '财务流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_global_cost_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_global_cost_config`;
CREATE TABLE `kx_work_global_cost_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `deduction_type` int(0) NULL DEFAULT NULL COMMENT '计费类型',
  `cost_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '费用名称',
  `cost_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '费用编码',
  `cost_unit_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '费用单位',
  `calculation_type` int(0) NOT NULL COMMENT '计算类型 1-按剩余天数 2-按单位 3-整月 4-按指定天数',
  `calculation_template` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '计算模板 {#cost_code}',
  `exact_digit` int(0) NOT NULL DEFAULT 3 COMMENT '精确位数',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '费用备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `nq_cost_code`(`cost_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_half_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_half_config`;
CREATE TABLE `kx_work_half_config`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '公司id',
  `half_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '半月套餐配置时间，多个用,分隔',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_user` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_user` int(0) NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 955 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '半月套餐配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_job_bind_log
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_job_bind_log`;
CREATE TABLE `kx_work_job_bind_log`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `job_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工作号',
  `user_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫号码',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工作号绑定记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_job_num
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_job_num`;
CREATE TABLE `kx_work_job_num`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `job_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工作号',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `use_status` int(0) NULL DEFAULT 1 COMMENT '使用状态 1 未使用 2 实名认证中 3 绑定已生效 4 绑定失败 5 工作号状态异常失效 6 工作号换绑次数超限失效',
  `work_status` int(0) NULL DEFAULT 1 COMMENT '工作状态 1 正常 2 异常',
  `bind_count` int(0) NULL DEFAULT 0 COMMENT '换绑次数',
  `province_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'x号码所属省编码',
  `city_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'x号码所属市编码',
  `area_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'x号码所属区编码',
  `support_province_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '异网支持绑定的省份编码',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(0) NULL DEFAULT 0 COMMENT '删除状态：0->未删除；1->已删除',
  `bs` bit(1) NULL DEFAULT b'1' COMMENT '是否启用',
  `auth_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '绑定id',
  `job_amount` decimal(10, 3) NULL DEFAULT NULL COMMENT '工作号费用',
  `industry_key_id` int(0) NULL DEFAULT NULL COMMENT '行业秘钥id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 312 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_message
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_message`;
CREATE TABLE `kx_work_message`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `msg_type` int(0) NULL DEFAULT NULL COMMENT '消息类型:1系统消息,2公告',
  `msg_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `msg_notice_scope` int(0) NULL DEFAULT NULL COMMENT '通知范围 1按企业，2按产品',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司id',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `msg_notice_method` int(0) NULL DEFAULT NULL COMMENT '通知方式 1消息中心 2弹窗',
  `msg_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '消息正文',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_user` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `is_release` int(0) NULL DEFAULT 0 COMMENT '是否发布 0未发布，1已发布',
  `sys_msg_type` int(0) NULL DEFAULT NULL COMMENT '系统消息类型 1充值',
  `is_deleted` int(0) NULL DEFAULT 0 COMMENT '是否删除 0否1是',
  `popup_day` int(0) NULL DEFAULT NULL COMMENT '弹窗天数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 528020 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_message_user
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_message_user`;
CREATE TABLE `kx_work_message_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `msg_id` int(0) NULL DEFAULT NULL COMMENT '消息id',
  `receiver_id` int(0) NULL DEFAULT NULL COMMENT '接收人id',
  `is_read` int(0) NULL DEFAULT 0 COMMENT '是否已读 0未读1已读',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '填充消息体',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_msg_id`(`msg_id`) USING BTREE,
  INDEX `index_user`(`receiver_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4019016 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_pay_order
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_pay_order`;
CREATE TABLE `kx_work_pay_order`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `mer_order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `total_amount` int(0) NULL DEFAULT NULL COMMENT '订单金额（元）',
  `seq_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统交易流水号',
  `buyer_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家用户名',
  `bank_info` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行信息',
  `bank_card_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付银行信息',
  `status` int(0) NULL DEFAULT NULL COMMENT '交易状态',
  `status_info` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态信息',
  `pay_time` datetime(0) NULL DEFAULT NULL COMMENT '交易时间',
  `order_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单描述',
  `data` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'data',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `mer_order_id`(`mer_order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4959 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '网银订单号' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_phone_device
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_phone_device`;
CREATE TABLE `kx_work_phone_device`  (
  `id` bigint(0) NOT NULL COMMENT '主键ID',
  `imei` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '话机串号',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '号码',
  `iccid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SIM卡号',
  `ano_iccid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '不一致的iccid',
  `status` int(0) NULL DEFAULT 200 COMMENT '状态 200正常，300机卡不一致，400手机卡离线，500未上传状态，600未绑定，700停用',
  `last_active_time` datetime(0) NULL DEFAULT NULL COMMENT '最后活跃时间',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `is_delete` int(0) NULL DEFAULT 0 COMMENT '是否删除 0否1是',
  `abnormal_count` int(0) NULL DEFAULT 0 COMMENT '异常次数',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理ID',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司ID',
  `pin_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'pin码',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_imei`(`imei`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话机表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_phone_device_upload_log
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_phone_device_upload_log`;
CREATE TABLE `kx_work_phone_device_upload_log`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `imei` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '话机串号',
  `number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `iccid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SIM卡号',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `status` int(0) NULL DEFAULT 0 COMMENT '状态 0默认 1已比对',
  `compare_time` datetime(0) NULL DEFAULT NULL COMMENT '比对时间',
  `compare_info` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '比对信息 200正常，300机卡不一致，400手机卡离线，500未上传状态，600未绑定，700停用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_imei`(`imei`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18201102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话机上传信息记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_phone_white
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_phone_white`;
CREATE TABLE `kx_work_phone_white`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '加白号码',
  `product_id` tinyint(0) NULL DEFAULT NULL COMMENT '产品id',
  `result_resp` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '加白结果',
  `result_white` tinyint(0) NULL DEFAULT NULL COMMENT '是否是白名单 0否1是',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45204 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '号码白名单记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_product_apply
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_product_apply`;
CREATE TABLE `kx_work_product_apply`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `application_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请标识',
  `apply_type` int(0) NULL DEFAULT 1 COMMENT '申请类型 1-企业申请 2-注册用户申请',
  `apply_status` int(0) NULL DEFAULT NULL COMMENT '申请状态 0待完善,1待审核,2审核通过,3驳回',
  `legal_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '法人名称',
  `comp_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '企业名称',
  `business_license_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '统一社会信用码',
  `business_bearer` int(0) NULL DEFAULT NULL COMMENT '业务承载方类型 1APP,2小程序,3网址,4公众号,5其他',
  `business_bearer_detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务承载方明细',
  `verbal_trick_str` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '话术内容',
  `industry` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属行业',
  `is_record` int(0) NULL DEFAULT NULL COMMENT '电信回拨是否需要录音',
  `axb_transactor_type` int(0) NULL DEFAULT NULL COMMENT 'AXB业务办理人 1企业法人,2授权代理人',
  `callback_transactor_type` int(0) NULL DEFAULT NULL COMMENT '电信回拨办卡方 1员工办卡,2公司办卡',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `set_meal_id` int(0) NULL DEFAULT NULL COMMENT '套餐id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `supplier_id` int(0) NULL DEFAULT NULL COMMENT '供应商id',
  `create_by` int(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NULL DEFAULT b'0',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `soft_group_id` int(0) NULL DEFAULT NULL COMMENT '软件换线路id',
  `caller_pre` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网关前缀，用于kos申请分机号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17217 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品申请' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_product_apply_annex
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_product_apply_annex`;
CREATE TABLE `kx_work_product_apply_annex`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `application_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请标识',
  `annex_type` int(0) NOT NULL COMMENT '附件类型,对应ProductApplyFileEnum枚举',
  `file_id` int(0) NOT NULL COMMENT '文件ID',
  `is_effect` int(0) NULL DEFAULT NULL COMMENT '是否有效 0无效1有效',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `application_no`(`application_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 64550 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品申请附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_product_apply_audit
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_product_apply_audit`;
CREATE TABLE `kx_work_product_apply_audit`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `application_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品申请记录标识',
  `audit_status` int(0) NULL DEFAULT NULL COMMENT '审核结果 2审核通过,3驳回',
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '审核人',
  `is_deleted` bit(1) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `application_no`(`application_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12799 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品申请审核' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_product_apply_blacklist
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_product_apply_blacklist`;
CREATE TABLE `kx_work_product_apply_blacklist`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `application_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `set_meal_id` int(0) NULL DEFAULT NULL COMMENT '套餐id',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `blacklist_id` int(0) NULL DEFAULT NULL COMMENT '黑名单',
  `create_by` int(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `is_delete` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1383 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品黑名单配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_product_change_log
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_product_change_log`;
CREATE TABLE `kx_work_product_change_log`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `seat_num` int(0) NULL DEFAULT NULL COMMENT '变更坐席数量',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '绑定的手机号',
  `old_product_id` int(0) NULL DEFAULT NULL COMMENT '原产品id',
  `old_set_meal_id` int(0) NULL DEFAULT NULL COMMENT '原套餐id',
  `new_product_id` int(0) NULL DEFAULT NULL COMMENT '新产品id',
  `new_set_meal_id` int(0) NULL DEFAULT NULL COMMENT '新套餐id',
  `tenant_minutes` int(0) NULL DEFAULT NULL COMMENT '租户切换分钟数',
  `agency_minutes` int(0) NULL DEFAULT NULL COMMENT '代理切换分钟数',
  `company_minutes` int(0) NULL DEFAULT NULL COMMENT '公司切换分钟数',
  `tenant_amount` decimal(10, 3) NULL DEFAULT NULL COMMENT '租户调整金额',
  `agency_amount` decimal(10, 3) NULL DEFAULT NULL COMMENT '代理调整金额',
  `company_amount` decimal(10, 3) NULL DEFAULT NULL COMMENT '公司调整金额',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理id',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司id',
  `option_user` int(0) NULL DEFAULT NULL COMMENT '操作人',
  `option_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20151 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品切换日志记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_product_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_product_config`;
CREATE TABLE `kx_work_product_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `product_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品名称',
  `circuit_id` int(0) NOT NULL COMMENT '线路id',
  `supplier_id` int(0) NOT NULL COMMENT '供应商id',
  `mode` int(0) NOT NULL COMMENT '模式',
  `status` int(0) NULL DEFAULT 1 COMMENT '启停状态 0-停用 1-启用',
  `sort` int(0) NULL DEFAULT 0 COMMENT '序号',
  `batch_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '费用配置编码',
  `is_show` bit(1) NOT NULL COMMENT '是否显示 1显示，2隐藏',
  `introduce` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品介绍',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品说明',
  `tags` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `overview_pic` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品概述图片名',
  `overview_file_id` int(0) NULL DEFAULT NULL COMMENT '产品概述文件ID',
  `quick_start_pic` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快速入门图片名',
  `quick_start_file_id` int(0) NULL DEFAULT NULL COMMENT '快速入门文件ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` bit(1) NULL DEFAULT NULL COMMENT '逻辑删除标识',
  `audit_type` int(0) NULL DEFAULT 0 COMMENT '审核类型 0平台 1公司代理 2自动审核',
  `support_sip` int(0) NULL DEFAULT 0 COMMENT '是否支持sip 0否1是',
  `support_black` int(0) NULL DEFAULT 0 COMMENT '是否支持黑名单 0否1是',
  `need_authentication` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否需要实名认证0不需要1需要',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_product_key_config
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_product_key_config`;
CREATE TABLE `kx_work_product_key_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `key_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密钥参数',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` bit(1) NULL DEFAULT NULL COMMENT '逻辑删除标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3525 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品密钥配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_protocol
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_protocol`;
CREATE TABLE `kx_work_protocol`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `type` int(0) NOT NULL COMMENT '协议类型',
  `context` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '协议内容',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_type`(`type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户隐私协议表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_recharge
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_recharge`;
CREATE TABLE `kx_work_recharge`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账单号',
  `recharge_amount` decimal(12, 3) NOT NULL COMMENT '充值金额',
  `payment_type` int(0) NOT NULL COMMENT '支付类型',
  `serial_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流水号',
  `after_amount` decimal(12, 3) NOT NULL COMMENT '充值后的金额',
  `recharge_type` int(0) NOT NULL COMMENT '充值类型',
  `make_bill` bit(1) NOT NULL COMMENT '是否开票',
  `remark` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `transaction_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易号',
  `recharge_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '充值日期',
  `recharge_month` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '充值月份',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `file_id` int(0) NULL DEFAULT NULL COMMENT '文件id',
  `file_ids` int(0) NULL DEFAULT NULL COMMENT '文件id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_id_create_time`(`tenant_id`, `create_time`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `bill_no`(`bill_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 88984 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '充值明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_report_number_record
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_report_number_record`;
CREATE TABLE `kx_work_report_number_record`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `agency_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '代理名称',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理ID',
  `tenant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '租户名称',
  `phone_number` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '电话号码',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '归属地省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '归属地市',
  `id_card` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '身份证号',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `script` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '话术',
  `audit_status` tinyint(0) NULL DEFAULT 0 COMMENT '审核状态（0=未审核，1=审核通过，2=审核不通过）',
  `audit_date` datetime(0) NULL DEFAULT NULL COMMENT '审核日期',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `is_deleted` tinyint(0) NULL DEFAULT 0 COMMENT '逻辑删除标记（0=未删除，1=已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1006885 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '号码报备记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_seat
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_seat`;
CREATE TABLE `kx_work_seat`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `seat_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '坐席编号',
  `set_meal_id` int(0) NOT NULL COMMENT '套餐ID',
  `ability_phone_id` int(0) NULL DEFAULT NULL COMMENT '能力号ID',
  `sip_extension_id` int(0) NULL DEFAULT NULL COMMENT 'SIP分机ID',
  `sip_call_type` int(0) NULL DEFAULT 0 COMMENT 'SIP拨打类型 0-非SIP 1-人工拨打 2-机器人拨打',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除',
  `share_date` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '动态时间',
  `job_phone_id` int(0) NULL DEFAULT NULL COMMENT '工作号ID',
  `seat_status` int(0) NULL DEFAULT 1 COMMENT '(0停用、1启用)',
  `seat_identification` tinyint(1) NOT NULL DEFAULT 0 COMMENT '（0未标识、1已标识）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_set_meal_id`(`set_meal_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_seat_no`(`seat_no`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_sip_extension_id`(`sip_extension_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 82870 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_seat_black_phone
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_seat_black_phone`;
CREATE TABLE `kx_work_seat_black_phone`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电话号码',
  `source` int(0) NULL DEFAULT NULL COMMENT '数据来源 1手动添加 2批量导入',
  `create_user` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `is_deleted` int(0) NULL DEFAULT 0 COMMENT '是否删除 0否1是',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5017 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_seat_operation_record
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_seat_operation_record`;
CREATE TABLE `kx_work_seat_operation_record`  (
  `record_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `seat_id` int(0) NOT NULL COMMENT '坐席ID',
  `set_meal_id` int(0) NOT NULL COMMENT '套餐ID',
  `product_id` int(0) NOT NULL COMMENT '产品ID',
  `bind_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '绑定号码',
  `change_bind_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '换绑号码',
  `tenant_id` int(0) NOT NULL COMMENT '所属租户ID',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '所属代理ID',
  `company_id` int(0) NOT NULL COMMENT '所属公司ID',
  `operation_type` int(0) NOT NULL COMMENT '操作类型 1-新增 2-绑定 3-换绑 4-删除',
  `operation_source` int(0) NOT NULL COMMENT '操作来源 1-普通 2-API 3-费用返还 4-销户 5-模式变更',
  `operation_by` int(0) NOT NULL COMMENT '操作人ID',
  `operation_time` datetime(0) NOT NULL COMMENT '操作时间',
  `operation_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作日期',
  `operation_month` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作月份',
  `job_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '工作号',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `idx_operation_time`(`operation_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 225161 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '坐席操作记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_seat_statistics
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_seat_statistics`;
CREATE TABLE `kx_work_seat_statistics`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `add_seat_sum` int(0) NOT NULL DEFAULT 0 COMMENT '新增坐席数',
  `remove_seat_sum` int(0) NOT NULL DEFAULT 0 COMMENT '删除坐席数',
  `disable_seat_num` int(0) NOT NULL DEFAULT 0 COMMENT '停用坐席数',
  `curr_seat_num` int(0) NOT NULL DEFAULT 0 COMMENT '当前坐席数',
  `tenant_status` int(0) NULL DEFAULT 1 COMMENT '租户状态',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `tenant_create_time` datetime(0) NULL DEFAULT NULL COMMENT '租户创建时间',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理ID',
  `company_id` int(0) NOT NULL COMMENT '公司ID',
  `create_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '统计日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE,
  INDEX `index_0`(`create_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 229401381 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '坐席统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_set_meal
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_set_meal`;
CREATE TABLE `kx_work_set_meal`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `set_meal_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '套餐名称',
  `call_duration` int(0) NOT NULL COMMENT '套餐时长（分钟）',
  `batch_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '费用配置编码',
  `type` int(0) NOT NULL DEFAULT 1 COMMENT '套餐类型 1-通用 2-指定',
  `product_id` int(0) NOT NULL COMMENT '产品ID',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_by` int(0) NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '逻辑删除标识',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_batch_code`(`batch_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9462 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户套餐表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_set_meal_bill
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_set_meal_bill`;
CREATE TABLE `kx_work_set_meal_bill`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `set_meal_id` int(0) NULL DEFAULT NULL COMMENT '租户套餐主键',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `remain_minutes` int(0) NULL DEFAULT 0 COMMENT '剩余分钟数',
  `customer_minutes` int(0) NULL DEFAULT 0 COMMENT '当天消费分钟数',
  `exceeded_minutes` int(0) NULL DEFAULT 0 COMMENT '超出套餐分钟数',
  `recharge_minutes` int(0) NULL DEFAULT 0 COMMENT '当天充值分钟数',
  `record_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '记录时间',
  `create_time` datetime(0) NOT NULL,
  `is_deleted` bit(1) NOT NULL DEFAULT b'0',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  `seat_start_time` datetime(0) NULL DEFAULT NULL COMMENT '坐席周期开始时间',
  `seat_end_time` datetime(0) NULL DEFAULT NULL COMMENT '坐席周期结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 683317 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '租户套餐流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_set_meal_chan
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_set_meal_chan`;
CREATE TABLE `kx_work_set_meal_chan`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(0) NULL DEFAULT NULL,
  `old_set_meal_id` int(0) NULL DEFAULT NULL,
  `new_set_meal_id` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 353 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_set_meal_change
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_set_meal_change`;
CREATE TABLE `kx_work_set_meal_change`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `corp_id` int(0) NULL DEFAULT NULL COMMENT '要变更套餐的企业id',
  `set_meal_type` int(0) NOT NULL COMMENT '变更套餐类型 1租户套餐 2代理套餐',
  `change_type` int(0) NULL DEFAULT NULL COMMENT '变更方式 1新增 2关联已有 3编辑',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `new_set_meal_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '新套餐名称',
  `old_call_duration` int(0) NULL DEFAULT NULL COMMENT '原套餐时长（分钟）',
  `new_call_duration` int(0) NULL DEFAULT NULL COMMENT '新套餐时长（分钟）',
  `old_batch_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '原套餐费用编码',
  `new_batch_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '新套餐费用编码',
  `effective_time` datetime(0) NULL DEFAULT NULL COMMENT '生效时间',
  `change_status` int(0) NULL DEFAULT NULL COMMENT '变更状态 1待生效 2已生效 3已撤销',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '操作人的租户id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '修改人',
  `is_deleted` tinyint(1) NULL DEFAULT NULL COMMENT '逻辑删除标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1546 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '套餐变更记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_set_meal_relation
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_set_meal_relation`;
CREATE TABLE `kx_work_set_meal_relation`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `set_meal_id` int(0) NOT NULL COMMENT '套餐ID',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tenant_id`(`tenant_id`, `set_meal_id`) USING BTREE,
  INDEX `set_meal_id`(`set_meal_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12528 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '指定套餐关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_sip_extension
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_sip_extension`;
CREATE TABLE `kx_work_sip_extension`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `extension_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分机号码',
  `product_id` int(0) NOT NULL COMMENT '产品ID',
  `status` int(0) NOT NULL DEFAULT 1 COMMENT '启停用状态',
  `tenant_id` int(0) NOT NULL COMMENT '租户ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `extension_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分机号唯一id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_extension_number`(`extension_number`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6246 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'SIP分机号码表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_sip_operation_record
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_sip_operation_record`;
CREATE TABLE `kx_work_sip_operation_record`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `sip_id` int(0) NOT NULL COMMENT '分机ID',
  `operation_type` int(0) NOT NULL COMMENT '操作类型 1-启用 2-禁用',
  `operation_by` int(0) NOT NULL COMMENT '操作人ID',
  `operation_time` datetime(0) NOT NULL COMMENT '操作时间',
  `operation_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作日期',
  `operation_month` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作月份',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分机操作记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_verify_annex
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_verify_annex`;
CREATE TABLE `kx_work_verify_annex`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `application_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请标识',
  `annex_type` int(0) NOT NULL COMMENT '附件类型',
  `file_id` int(0) NOT NULL COMMENT '文件ID',
  `batch_id` int(0) NULL DEFAULT NULL COMMENT '批次ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9300 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '申请附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_work_verify_number_record
-- ----------------------------
DROP TABLE IF EXISTS `kx_work_verify_number_record`;
CREATE TABLE `kx_work_verify_number_record`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `number` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '号码',
  `certified_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '认证用户',
  `certified_id_card` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '认证身份证号码',
  `platform_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '平台名称',
  `company_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公司名称',
  `notify_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '接收通知手机',
  `status` tinyint(0) NULL DEFAULT 0 COMMENT '签署状态（0=未签署，1=签署中，2=已签署,3已撤销,4未发起）',
  `sign_file_url` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'e签宝签署地址',
  `file_url` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '签署回调返回地址',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `sign_flow_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '签署流程id',
  `file_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件id',
  `revoke_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '撤回原因',
  `create_by` int(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_by` int(0) NULL DEFAULT NULL COMMENT '更新人',
  `agency_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '代理名称',
  `agency_id` int(0) NULL DEFAULT NULL COMMENT '代理ID',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '归属地省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '归属地市',
  `script` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '话术',
  `audit_status` tinyint(0) NULL DEFAULT 0 COMMENT '审核状态（0=未审核，1=审核通过，2=审核不通过,3已发送）',
  `audit_date` datetime(0) NULL DEFAULT NULL COMMENT '审核日期',
  `company_id` int(0) NULL DEFAULT NULL COMMENT '公司id',
  `sign_date` datetime(0) NULL DEFAULT NULL COMMENT '签署时间',
  `audit_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '审核结果',
  `tenant_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '租户名称',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `basic_operator` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '电信' COMMENT '电信',
  `target_platform` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '陕西中间号' COMMENT '陕西中间号',
  `belonging_pool_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '244' COMMENT '所属号池ID',
  `call_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '手动模式' COMMENT '手动模式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 712597542608902 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '号码认证记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_zj_machine
-- ----------------------------
DROP TABLE IF EXISTS `kx_zj_machine`;
CREATE TABLE `kx_zj_machine`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `machine_id` int(0) NULL DEFAULT NULL,
  `machine_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_zj_record_detect_machine
-- ----------------------------
DROP TABLE IF EXISTS `kx_zj_record_detect_machine`;
CREATE TABLE `kx_zj_record_detect_machine`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `machine_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `today_connect_num` int(0) NULL DEFAULT NULL,
  `today_detect_num` int(0) NOT NULL DEFAULT 0,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_delete` int(0) NULL DEFAULT 0 COMMENT '是否删除 0否1是',
  `is_axb` int(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `machine_name`(`machine_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_zj_record_detect_result
-- ----------------------------
DROP TABLE IF EXISTS `kx_zj_record_detect_result`;
CREATE TABLE `kx_zj_record_detect_result`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `machine_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `file_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `byte_size` int(0) NULL DEFAULT NULL,
  `call_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `peer_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `call_time` datetime(0) NULL DEFAULT NULL,
  `start_time` datetime(0) NULL DEFAULT NULL,
  `finish_time` datetime(0) NULL DEFAULT NULL,
  `duration` int(0) NULL DEFAULT NULL,
  `record_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `record_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `label` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `detect_type` tinyint(1) NULL DEFAULT NULL COMMENT '0-非法 1合法',
  `keywords` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `detect_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `detect_result` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `note` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `inspector` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `return_time` datetime(0) NULL DEFAULT NULL,
  `review_status` tinyint(1) NULL DEFAULT 0,
  `review_time` datetime(0) NULL DEFAULT NULL,
  `reviewer_id` int(0) NULL DEFAULT NULL COMMENT '复核人id',
  `reviewer_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `axb_callee` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'axb模式的被叫',
  `record_download_addr` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '远程下载路径',
  `industry_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属行业',
  `real_duration` int(0) NULL DEFAULT NULL COMMENT '录音真实时长，毫秒',
  `check_type` int(0) NULL DEFAULT NULL COMMENT '第三方检测0磐石云，1多方，2科大讯飞',
  `gateway_in_id` int(0) NULL DEFAULT NULL COMMENT '对接网关id',
  `gateway_in_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '对接网关ip',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `machine_name`(`machine_name`) USING BTREE,
  INDEX `call_time`(`call_time`) USING BTREE,
  INDEX `review_status`(`review_status`) USING BTREE,
  INDEX `file_id`(`file_id`) USING BTREE,
  INDEX `index_time`(`detect_time`, `return_time`) USING BTREE,
  INDEX `idx_detect_time`(`detect_time`) USING BTREE,
  INDEX `idx_detect_type`(`detect_type`) USING BTREE,
  INDEX `index_note`(`note`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61167 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_zj_record_detect_result_his
-- ----------------------------
DROP TABLE IF EXISTS `kx_zj_record_detect_result_his`;
CREATE TABLE `kx_zj_record_detect_result_his`  (
  `id` int(0) NOT NULL DEFAULT 0,
  `machine_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `file_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `byte_size` int(0) NULL DEFAULT NULL,
  `call_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `peer_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `call_time` datetime(0) NULL DEFAULT NULL,
  `start_time` datetime(0) NULL DEFAULT NULL,
  `finish_time` datetime(0) NULL DEFAULT NULL,
  `duration` int(0) NULL DEFAULT NULL,
  `record_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `record_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `label` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `detect_type` tinyint(1) NULL DEFAULT NULL COMMENT '0-非法 1合法',
  `keywords` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `detect_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `detect_result` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `note` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `inspector` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `return_time` datetime(0) NULL DEFAULT NULL,
  `review_status` tinyint(1) NULL DEFAULT 0,
  `review_time` datetime(0) NULL DEFAULT NULL,
  `reviewer_id` int(0) NULL DEFAULT NULL COMMENT '复核人id',
  `reviewer_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `axb_callee` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'axb模式的被叫',
  `record_download_addr` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '远程下载路径',
  `industry_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属行业',
  `real_duration` int(0) NULL DEFAULT NULL COMMENT '录音时长',
  `check_type` int(0) NULL DEFAULT NULL COMMENT '第三方检测0磐石云，1多方，2科大讯飞'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_zj_record_detect_setting
-- ----------------------------
DROP TABLE IF EXISTS `kx_zj_record_detect_setting`;
CREATE TABLE `kx_zj_record_detect_setting`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `min_duration` int(0) NULL DEFAULT NULL,
  `max_duration` int(0) NULL DEFAULT NULL,
  `start_time` time(0) NULL DEFAULT NULL,
  `end_time` time(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 175 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kx_zj_record_machine_day_connect
-- ----------------------------
DROP TABLE IF EXISTS `kx_zj_record_machine_day_connect`;
CREATE TABLE `kx_zj_record_machine_day_connect`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `machine_id` int(0) NULL DEFAULT NULL COMMENT '机器id',
  `day_connect_num` int(0) NULL DEFAULT NULL COMMENT '当天连接数',
  `connect_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '连接时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_time`(`connect_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14129 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_line_config
-- ----------------------------
DROP TABLE IF EXISTS `t_line_config`;
CREATE TABLE `t_line_config`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `circuit_id` int(0) NULL DEFAULT NULL COMMENT '线路id',
  `call_start_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '可呼时间段开始时间',
  `call_end_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '可呼时间段结束时间',
  `caller_blind_spot` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '主叫盲区，多个用逗号拼接',
  `callee_blind_spot` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '被叫盲区，多个用逗号拼接',
  `caller_limit` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '主叫限制，多个用逗号拼接 1移动2联通3电信4虚商',
  `caller_available_count` int(0) NULL DEFAULT NULL COMMENT '主叫可呼次数',
  `callee_limit_day` int(0) NULL DEFAULT NULL COMMENT '被叫频次限制天数',
  `callee_limit_day_count` int(0) NULL DEFAULT NULL COMMENT '被叫频次限制每天可呼次数',
  `black_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '黑名单配置，多个用逗号拼接，0不配置，1卡信库',
  `special_call` int(0) NULL DEFAULT NULL COMMENT '特殊号禁拨，0否1是',
  `is_enable` int(0) NULL DEFAULT 0 COMMENT '是否启用，0否1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_special_numbers
-- ----------------------------
DROP TABLE IF EXISTS `t_special_numbers`;
CREATE TABLE `t_special_numbers`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `special_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '特殊号码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test
-- ----------------------------
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test`  (
  `id` bigint(0) NOT NULL,
  `supplier_id` int(0) NULL DEFAULT NULL COMMENT '供应商id',
  `dept_id` int(0) NULL DEFAULT NULL COMMENT '部门id',
  `set_meal_id` int(0) NULL DEFAULT NULL COMMENT '套餐id',
  `product_id` int(0) NULL DEFAULT NULL COMMENT '产品id',
  `bind_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '绑定id',
  `call_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '话单唯一标识',
  `call_time` datetime(0) NULL DEFAULT NULL COMMENT '拨打时间',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '主叫接听时间',
  `answer_time` datetime(0) NULL DEFAULT NULL COMMENT '被叫接听时间',
  `finish_time` datetime(0) NULL DEFAULT NULL COMMENT '挂机时间',
  `call_duration` int(0) NULL DEFAULT NULL COMMENT '通话时长（秒）',
  `fee_duration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '扣费时长（分钟）',
  `call_status` int(0) NULL DEFAULT NULL COMMENT '接听状态：0未接听；1已接听',
  `user_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主叫号码',
  `tel_x` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中间号/能力号',
  `call_number` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '被叫号码',
  `place` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '号码归属地',
  `record_download_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '录音地址',
  `tenant_id` int(0) NULL DEFAULT NULL COMMENT '租户id',
  `user_id` int(0) NULL DEFAULT NULL COMMENT ' 员工标识',
  `create_by` int(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `is_delete` bit(1) NULL DEFAULT b'0',
  `called_duration` int(0) NULL DEFAULT NULL COMMENT '被叫接听时长',
  `seat_id` int(0) NULL DEFAULT NULL COMMENT '坐席id',
  `sip_id` int(0) NULL DEFAULT NULL COMMENT '分机号sip id',
  `caller_duration` int(0) NULL DEFAULT NULL COMMENT '主叫接听时长',
  `in_out_type` tinyint(0) NULL DEFAULT 2 COMMENT '1:为呼入类型，2呼出类型',
  `job_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '工作号',
  `operator_record_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `test` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `bind_index`(`bind_id`) USING BTREE,
  INDEX `idx_call_id`(`call_id`) USING BTREE,
  INDEX `idx_tenant_id_user_id`(`tenant_id`, `user_id`) USING BTREE,
  INDEX `idx_tenant_id_user_phone`(`tenant_id`, `user_phone`) USING BTREE,
  INDEX `idx_tenant_id_call_number`(`tenant_id`, `call_number`) USING BTREE,
  INDEX `index_0`(`tenant_id`, `is_delete`, `call_time`) USING BTREE,
  INDEX `index_2`(`tenant_id`, `user_phone`, `call_number`) USING BTREE,
  INDEX `index_3`(`create_time`) USING BTREE,
  INDEX `index_4`(`is_delete`, `user_id`, `tenant_id`, `call_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '话单明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test_sjt
-- ----------------------------
DROP TABLE IF EXISTS `test_sjt`;
CREATE TABLE `test_sjt`  (
  `call_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `tenant_id` int(0) NULL DEFAULT NULL,
  `product_id` int(0) NULL DEFAULT NULL,
  `record_download_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
