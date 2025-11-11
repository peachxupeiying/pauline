<template>
  <div class="performance-data">
    <!-- 区块标题 -->
    <h2 class="section-title">成效数据</h2>

    <!-- 核心指标4宫格 -->
    <div class="metrics-grid">
      <el-card
        v-for="metric in metrics"
        :key="metric.key"
        class="metric-card"
        shadow="hover"
      >
        <div class="metric-icon">{{ metric.icon }}</div>
        <div class="metric-content">
          <div class="metric-value" ref="metricValueRefs">
            <animated-number :value="metric.value" :format="metric.format" />
          </div>
          <div class="metric-label">{{ metric.label }}</div>
          <div v-if="metric.trend" class="metric-trend" :class="metric.trendClass">
            {{ metric.trend }}
          </div>
          <div v-if="metric.extra" class="metric-extra">
            {{ metric.extra }}
          </div>
        </div>
      </el-card>
    </div>

    <!-- 降本增效对比卡片 -->
    <el-card class="comparison-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <h3 class="card-title">降本增效对比</h3>
        </div>
      </template>

      <div class="comparison-content">
        <!-- 左侧：人工 -->
        <div class="comparison-side">
          <div class="side-title">人工处理</div>
          <div class="side-metrics">
            <div class="side-metric">
              <div class="side-metric-label">平均处理时长</div>
              <div class="side-metric-value">{{ data.comparison.manual.avgTime }}</div>
            </div>
            <div class="side-metric">
              <div class="side-metric-label">准确率</div>
              <div class="side-metric-value">{{ data.comparison.manual.accuracy }}</div>
            </div>
            <div class="side-metric">
              <div class="side-metric-label">在线时间</div>
              <div class="side-metric-value">{{ data.comparison.manual.availability }}</div>
            </div>
            <div class="side-metric">
              <div class="side-metric-label">年成本</div>
              <div class="side-metric-value cost">
                ¥{{ formatNumber(data.comparison.manual.annualCost) }}
              </div>
            </div>
          </div>
        </div>

        <!-- 中间：VS -->
        <div class="vs-divider">
          <div class="vs-text">VS</div>
        </div>

        <!-- 右侧：数智员工 -->
        <div class="comparison-side ai-side">
          <div class="side-title highlight">数智员工</div>
          <div class="side-metrics">
            <div class="side-metric">
              <div class="side-metric-label">平均处理时长</div>
              <div class="side-metric-value highlight">{{ data.comparison.ai.avgTime }}</div>
            </div>
            <div class="side-metric">
              <div class="side-metric-label">准确率</div>
              <div class="side-metric-value highlight">{{ data.comparison.ai.accuracy }}</div>
            </div>
            <div class="side-metric">
              <div class="side-metric-label">在线时间</div>
              <div class="side-metric-value highlight">{{ data.comparison.ai.availability }}</div>
            </div>
            <div class="side-metric">
              <div class="side-metric-label">年成本</div>
              <div class="side-metric-value cost highlight">
                ¥{{ formatNumber(data.comparison.ai.annualCost) }}
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ROI显示 -->
      <div class="roi-section">
        <div class="roi-label">投资回报率</div>
        <div class="roi-value">{{ data.comparison.roi }}</div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import type { Performance } from '@/types/case';
import AnimatedNumber from './AnimatedNumber.vue';

interface Props {
  data: Performance;
}

const props = defineProps<Props>();

// 核心指标数据
const metrics = computed(() => [
  {
    key: 'userCount',
    icon: '👥',
    label: '使用人数',
    value: props.data.userCount,
    format: 'number',
    trend: props.data.userCountTrend,
    trendClass: 'trend-up'
  },
  {
    key: 'dialogCount',
    icon: '💬',
    label: '对话轮数',
    value: props.data.dialogCount,
    format: 'number',
    extra: `月均 ${formatNumber(props.data.dialogMonthlyAvg)} 次`
  },
  {
    key: 'taskCount',
    icon: '📋',
    label: '工作任务数',
    value: props.data.taskCount,
    format: 'number',
    extra: `日均 ${formatNumber(props.data.taskDailyAvg)} 个`
  },
  {
    key: 'costSaving',
    icon: '💰',
    label: '节省金额',
    value: props.data.costSaving,
    format: 'currency',
    extra: `工作时长 ${props.data.workHours} 天`
  }
]);

/**
 * 格式化数字
 */
const formatNumber = (num: number): string => {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
};
</script>

<style lang="scss" scoped>
.performance-data {
  width: 100%;
}

.section-title {
  font-size: $font-size-xl;
  font-weight: 600;
  color: $text-primary;
  margin: 0 0 24px 0;
}

// 核心指标网格
.metrics-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;

  @media (max-width: $breakpoint-md) {
    grid-template-columns: repeat(2, 1fr);
  }

  @media (max-width: $breakpoint-sm) {
    grid-template-columns: 1fr;
  }
}

.metric-card {
  border-radius: $border-radius;
  transition: transform $transition-base;

  &:hover {
    transform: translateY(-4px);
  }

  :deep(.el-card__body) {
    padding: 24px;
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    gap: 12px;
  }
}

.metric-icon {
  font-size: 40px;
}

.metric-content {
  width: 100%;
}

.metric-value {
  font-size: $font-size-huge;
  font-weight: 700;
  color: $primary-color;
  margin-bottom: 8px;
}

.metric-label {
  font-size: $font-size-base;
  color: $text-secondary;
  margin-bottom: 4px;
}

.metric-trend {
  font-size: $font-size-sm;
  font-weight: 600;

  &.trend-up {
    color: $success-color;
  }

  &.trend-down {
    color: $error-color;
  }
}

.metric-extra {
  font-size: $font-size-sm;
  color: $text-tertiary;
  margin-top: 4px;
}

// 对比卡片
.comparison-card {
  border-radius: $border-radius;

  :deep(.el-card__header) {
    border-bottom: 2px solid $border-light;
    padding: 20px 24px;
  }

  :deep(.el-card__body) {
    padding: 32px 24px;
  }
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.card-title {
  font-size: $font-size-lg;
  font-weight: 600;
  color: $text-primary;
  margin: 0;
}

.comparison-content {
  display: flex;
  align-items: stretch;
  gap: 32px;

  @media (max-width: $breakpoint-md) {
    flex-direction: column;
    gap: 24px;
  }
}

.comparison-side {
  flex: 1;
}

.side-title {
  font-size: $font-size-lg;
  font-weight: 600;
  color: $text-primary;
  margin-bottom: 20px;
  text-align: center;

  &.highlight {
    color: $primary-color;
  }
}

.side-metrics {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.side-metric {
  padding: 12px;
  background-color: $bg-secondary;
  border-radius: $border-radius-sm;
}

.side-metric-label {
  font-size: $font-size-sm;
  color: $text-secondary;
  margin-bottom: 6px;
}

.side-metric-value {
  font-size: $font-size-xl;
  font-weight: 600;
  color: $text-primary;

  &.highlight {
    color: $primary-color;
  }

  &.cost {
    color: $warning-color;

    &.highlight {
      color: $success-color;
    }
  }
}

.vs-divider {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 60px;

  @media (max-width: $breakpoint-md) {
    min-height: 40px;
  }
}

.vs-text {
  width: 60px;
  height: 60px;
  background: $gradient-blue-purple;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: $font-size-xl;
  font-weight: 700;
  color: white;

  @media (max-width: $breakpoint-md) {
    width: 50px;
    height: 50px;
    font-size: $font-size-lg;
  }
}

// ROI
.roi-section {
  margin-top: 32px;
  padding-top: 24px;
  border-top: 2px solid $border-light;
  text-align: center;
}

.roi-label {
  font-size: $font-size-base;
  color: $text-secondary;
  margin-bottom: 12px;
}

.roi-value {
  font-size: 48px;
  font-weight: 700;
  background: $gradient-blue-purple;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;

  @media (max-width: $breakpoint-sm) {
    font-size: 36px;
  }
}
</style>
