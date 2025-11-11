# 数智员工经典案例展示页面

一个基于 Vue 3 + TypeScript + Element Plus 的单页长滚动展示页面，用于展示AI数字员工的优秀应用案例。

## 技术栈

- **框架**: Vue 3 + TypeScript
- **UI组件库**: Element Plus
- **图表库**: ECharts (预留，可用于数据可视化扩展)
- **样式**: SCSS
- **构建工具**: Vite

## 功能特性

### 页面结构

页面采用**单页长滚动布局**，包含以下6个区块：

1. **案例头部区块**
   - 封面图/视频展示（16:9比例）
   - 案例名称和等级徽章（金牌/银牌/铜牌）
   - 一句话亮点展示
   - 基础信息（所属组织、领域、上线时间）
   - 可折叠的联系人信息

2. **成效数据区块**
   - 核心指标4宫格卡片（带数字递增动画）
   - 降本增效对比展示（人工 VS 数智员工）
   - ROI投资回报率展示

3. **能力介绍区块**
   - 智慧大脑信息展示
   - 核心能力3宫格
   - 能力亮点列表
   - 工作技能展示（支持展开/收起）

4. **业务场景区块**
   - 典型应用场景描述
   - 业务流程图展示
   - 适用岗位标签

5. **用户评价区块**
   - 综合评分和星级展示
   - 评分维度条形图
   - 用户证言卡片展示

6. **快速上手区块**
   - 使用手册、视频教程、常见问题入口
   - 联系信息展示
   - 操作按钮（申请试用、收藏案例、分享）

### 交互功能

- ✅ 页面内锚点导航（固定顶部导航条）
- ✅ 平滑滚动到对应区块
- ✅ 数字递增动画效果
- ✅ 收藏功能（本地状态切换）
- ✅ 分享功能（复制链接、生成长图、下载PDF）
- ✅ 响应式布局（适配移动端）
- ✅ 工作技能展开/收起
- ✅ 视频弹窗播放
- ✅ 卡片悬停动画效果

## 项目结构

```
pauline/
├── src/
│   ├── components/          # 组件目录
│   │   ├── CaseShowcase.vue     # 主页面组件
│   │   ├── NavigationBar.vue    # 导航条组件
│   │   ├── CaseHeader.vue       # 案例头部组件
│   │   ├── PerformanceData.vue  # 成效数据组件
│   │   ├── CapabilityIntro.vue  # 能力介绍组件
│   │   ├── BusinessScenario.vue # 业务场景组件
│   │   ├── UserReviews.vue      # 用户评价组件
│   │   ├── QuickStart.vue       # 快速上手组件
│   │   └── AnimatedNumber.vue   # 数字动画组件
│   ├── types/               # TypeScript类型定义
│   │   └── case.ts
│   ├── data/                # 数据文件
│   │   └── mockData.ts
│   ├── styles/              # 样式文件
│   │   ├── variables.scss   # SCSS变量
│   │   └── global.scss      # 全局样式
│   ├── App.vue              # 根组件
│   └── main.ts              # 入口文件
├── index.html               # HTML模板
├── vite.config.ts           # Vite配置
├── tsconfig.json            # TypeScript配置
├── package.json             # 项目依赖
└── README.md                # 项目说明
```

## 快速开始

### 安装依赖

```bash
npm install
```

### 开发模式

```bash
npm run dev
```

访问 http://localhost:5173 查看页面

### 构建生产版本

```bash
npm run build
```

### 预览生产版本

```bash
npm run preview
```

## 数据结构

所有案例数据都定义在 `src/types/case.ts` 中，包含以下主要接口：

- `CaseDetail`: 案例完整数据结构
- `Performance`: 成效数据
- `Capability`: 能力信息
- `Scenario`: 业务场景
- `Review`: 用户评价
- `Guide`: 使用指南

Mock数据示例见 `src/data/mockData.ts`

## 自定义和扩展

### 修改主题色

编辑 `src/styles/variables.scss` 文件：

```scss
$primary-color: #1E90FF;  // 主色调
$gradient-blue-purple: linear-gradient(135deg, #667eea 0%, #764ba2 100%);  // 渐变色
```

### 添加新的案例

在 `src/data/mockData.ts` 中按照 `CaseDetail` 接口定义添加新的案例数据。

### 扩展图表功能

项目已集成 ECharts，可以在成效数据或用户评价区块中添加更丰富的数据可视化图表。

## 响应式断点

```scss
$breakpoint-xs: 480px;   // 超小屏幕
$breakpoint-sm: 768px;   // 小屏幕
$breakpoint-md: 992px;   // 中等屏幕
$breakpoint-lg: 1200px;  // 大屏幕
$breakpoint-xl: 1600px;  // 超大屏幕
```

## 浏览器兼容性

- Chrome (推荐)
- Firefox
- Safari
- Edge

建议使用现代浏览器以获得最佳体验。

## 注意事项

1. 封面图和流程图建议使用高质量图片，推荐尺寸：
   - 封面图：800x450 (16:9)
   - 流程图：1200x600

2. 视频文件建议使用MP4格式，确保兼容性

3. Mock数据中的图片链接使用了占位图，实际使用时请替换为真实图片URL

4. 分享功能（生成长图、PDF）需要实际项目中集成 html2canvas 和 jspdf 库的完整实现

## License

MIT
