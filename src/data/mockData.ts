import type { CaseDetail } from '@/types/case';

/**
 * Mock数据 - 智能客服数智员工案例
 */
export const mockCaseData: CaseDetail = {
  // 基础信息
  id: 'case-001',
  name: '智能客服数智员工',
  grade: 'gold',
  highlight: '7×24小时在线，客户满意度提升40%，人力成本降低60%',
  coverImage: 'https://via.placeholder.com/800x450/1E90FF/FFFFFF?text=AI+Customer+Service',
  coverVideo: 'https://www.example.com/video/ai-customer-service.mp4',
  organization: '集团客户服务部',
  domain: '客户服务',
  onlineDate: '2024-03-15',
  contact: {
    name: '张三',
    phone: '138-0000-1234',
    email: 'zhangsan@example.com'
  },

  // 成效数据
  performance: {
    userCount: 15680,
    userCountTrend: '↑28%',
    dialogCount: 356789,
    dialogMonthlyAvg: 118930,
    taskCount: 89456,
    taskDailyAvg: 2982,
    workHours: 1825,
    costSaving: 4560000,

    comparison: {
      manual: {
        avgTime: '8.5分钟',
        accuracy: '85%',
        availability: '8小时/天',
        annualCost: 7200000
      },
      ai: {
        avgTime: '30秒',
        accuracy: '96%',
        availability: '24小时/天',
        annualCost: 2640000
      },
      roi: '272%'
    }
  },

  // 能力信息
  capability: {
    brain: 'Claude 3.5 Sonnet',
    coreAbilities: [
      {
        icon: '🔍',
        title: '智能识别',
        description: '精准识别客户意图，支持多轮对话理解'
      },
      {
        icon: '⚡',
        title: '自动处理',
        description: '自动完成90%常见问题，无需人工介入'
      },
      {
        icon: '📊',
        title: '智能分析',
        description: '实时分析客户情绪，智能推荐解决方案'
      }
    ],
    highlights: [
      '支持文本、语音、图片多模态交互',
      '智能工单自动生成与流转',
      '客户画像实时分析',
      '知识库自动更新与优化',
      '多渠道统一接入（网页、APP、微信、电话）'
    ],
    skills: [
      '产品咨询', '订单查询', '退换货处理', '投诉处理', '账户管理',
      '支付问题', '物流查询', '优惠活动', '会员服务', '技术支持',
      '售后服务', '预约管理', '资料查询', '业务办理', '信息变更',
      '账单查询', '套餐推荐', '故障报修', '满意度调查', '客户回访',
      '数据分析', '报表生成', '质量监控', '知识管理', '智能推荐',
      '情绪识别', '意图理解', '多轮对话', '上下文记忆', '个性化服务',
      '智能路由', '工单派发', '优先级判断', '自动回复', '智能提醒',
      '数据统计', '趋势分析', '异常预警', '性能优化', '自我学习',
      '多语言支持', '方言识别', '专业术语'
    ]
  },

  // 业务场景
  scenario: {
    description: '主要应用于客户咨询、订单处理、售后服务等场景。通过智能对话系统，自动处理客户的常见问题，对于复杂问题能够智能识别并转接人工客服。同时实时分析客户满意度，为业务优化提供数据支持。',
    flowImage: 'https://via.placeholder.com/1200x600/4169E1/FFFFFF?text=Business+Flow+Chart',
    targetRoles: ['客服专员', '客服主管', '售后人员', '投诉处理专员', '质检人员']
  },

  // 用户评价
  review: {
    overallScore: 4.8,
    totalReviews: 328,
    dimensions: [
      { name: '易用性', score: 4.9 },
      { name: '稳定性', score: 4.7 },
      { name: '效率提升', score: 4.8 },
      { name: '准确性', score: 4.7 },
      { name: '响应速度', score: 4.9 }
    ],
    testimonials: [
      {
        avatar: 'https://via.placeholder.com/80/FF6B6B/FFFFFF?text=L',
        name: '李经理',
        position: '客服中心主管',
        content: '使用智能客服后，团队效率提升了3倍！以前需要20个人处理的工作量，现在8个人就能完成，而且客户满意度还提高了。AI能处理大部分常见问题，我们可以专注于复杂问题的解决。',
        rating: 5,
        date: '2024-10-15'
      },
      {
        avatar: 'https://via.placeholder.com/80/4ECDC4/FFFFFF?text=W',
        name: '王专员',
        position: '客服专员',
        content: '刚开始还担心AI会取代我们，后来发现它其实是我们的好帮手。重复性的问题AI都能解决，我们可以把精力放在需要同理心和创造性解决的问题上。工作变得更有意义了！',
        rating: 5,
        date: '2024-10-08'
      },
      {
        avatar: 'https://via.placeholder.com/80/95E1D3/FFFFFF?text=C',
        name: '陈主任',
        position: '质量管理部主任',
        content: '智能客服的服务质量很稳定，不会因为情绪或疲劳影响服务质量。而且它能7×24小时工作，客户随时都能得到及时响应。数据分析功能也很强大，帮助我们快速发现问题。',
        rating: 4.5,
        date: '2024-09-28'
      }
    ]
  },

  // 使用指南
  guide: {
    manual: 'https://www.example.com/docs/ai-customer-service-manual.pdf',
    video: 'https://www.example.com/video/tutorial.mp4',
    faqUrl: 'https://www.example.com/faq/ai-customer-service'
  }
};
