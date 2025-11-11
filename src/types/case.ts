/**
 * 案例等级类型
 */
export type CaseGrade = 'gold' | 'silver' | 'bronze';

/**
 * 联系人信息
 */
export interface Contact {
  name: string;
  phone: string;
  email: string;
}

/**
 * 对比数据 - 单侧（人工或AI）
 */
export interface ComparisonSide {
  avgTime: string; // 平均处理时长
  accuracy: string; // 准确率
  availability: string; // 在线时间
  annualCost: number; // 年成本
}

/**
 * 降本增效对比数据
 */
export interface ComparisonData {
  manual: ComparisonSide; // 人工数据
  ai: ComparisonSide; // AI数据
  roi: string; // 投资回报率
}

/**
 * 成效数据
 */
export interface Performance {
  userCount: number; // 使用人数
  userCountTrend: string; // 使用人数趋势，如 "↑20%"
  dialogCount: number; // 对话轮数
  dialogMonthlyAvg: number; // 对话月均值
  taskCount: number; // 工作任务数
  taskDailyAvg: number; // 工作任务日均值
  workHours: number; // 工作时长（天）
  costSaving: number; // 节省金额（元）
  comparison: ComparisonData; // 对比数据
}

/**
 * 核心能力项
 */
export interface CoreAbility {
  icon: string; // 图标
  title: string; // 标题
  description: string; // 描述
}

/**
 * 能力信息
 */
export interface Capability {
  brain: string; // 智慧大脑
  coreAbilities: CoreAbility[]; // 核心能力列表
  highlights: string[]; // 能力亮点
  skills: string[]; // 工作技能列表
}

/**
 * 业务场景
 */
export interface Scenario {
  description: string; // 场景描述
  flowImage: string; // 流程图
  targetRoles: string[]; // 适用岗位
}

/**
 * 评分维度
 */
export interface ReviewDimension {
  name: string; // 维度名称
  score: number; // 分数
}

/**
 * 用户证言/评价
 */
export interface Testimonial {
  avatar: string; // 头像
  name: string; // 姓名
  position: string; // 岗位
  content: string; // 评价内容
  rating: number; // 星级
  date: string; // 日期
}

/**
 * 用户评价
 */
export interface Review {
  overallScore: number; // 综合评分
  totalReviews: number; // 评价总数
  dimensions: ReviewDimension[]; // 评分维度
  testimonials: Testimonial[]; // 用户证言
}

/**
 * 使用指南
 */
export interface Guide {
  manual: string; // 使用手册链接
  video: string; // 视频教程链接
  faqUrl: string; // 常见问题链接
}

/**
 * 案例详情完整数据结构
 */
export interface CaseDetail {
  // 基础信息
  id: string;
  name: string;
  grade: CaseGrade; // 等级
  highlight: string; // 一句话亮点
  coverImage: string; // 封面图
  coverVideo?: string; // 封面视频（可选）
  organization: string; // 所属组织
  domain: string; // 所属领域
  onlineDate: string; // 上线时间
  contact: Contact; // 联系人信息

  // 成效数据
  performance: Performance;

  // 能力信息
  capability: Capability;

  // 业务场景
  scenario: Scenario;

  // 用户评价
  review: Review;

  // 使用指南
  guide: Guide;
}
