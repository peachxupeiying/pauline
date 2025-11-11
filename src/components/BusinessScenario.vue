<template>
  <div class="business-scenario">
    <!-- 区块标题 -->
    <h2 class="section-title">业务场景</h2>

    <el-card class="scenario-card" shadow="hover">
      <!-- 场景描述 -->
      <div class="scenario-description">
        <h3 class="subsection-title">典型应用场景</h3>
        <p class="description-text">{{ data.description }}</p>
      </div>

      <!-- 业务流程图 -->
      <div class="flow-section">
        <h3 class="subsection-title">业务流程</h3>
        <div class="flow-image-wrapper">
          <img :src="data.flowImage" alt="业务流程图" class="flow-image" />
        </div>
      </div>

      <!-- 适用岗位 -->
      <div class="roles-section">
        <h3 class="subsection-title">适用岗位</h3>
        <div class="roles-list">
          <el-tag
            v-for="(role, index) in data.targetRoles"
            :key="index"
            class="role-tag"
            type="primary"
            effect="plain"
          >
            <el-icon class="role-icon"><User /></el-icon>
            {{ role }}
          </el-tag>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { User } from '@element-plus/icons-vue';
import type { Scenario } from '@/types/case';

interface Props {
  data: Scenario;
}

defineProps<Props>();
</script>

<style lang="scss" scoped>
.business-scenario {
  width: 100%;
}

.section-title {
  font-size: $font-size-xl;
  font-weight: 600;
  color: $text-primary;
  margin: 0 0 24px 0;
}

.scenario-card {
  border-radius: $border-radius;

  :deep(.el-card__body) {
    padding: 32px;

    @media (max-width: $breakpoint-sm) {
      padding: 24px;
    }
  }
}

.subsection-title {
  font-size: $font-size-lg;
  font-weight: 600;
  color: $text-primary;
  margin: 0 0 16px 0;
}

// 场景描述
.scenario-description {
  margin-bottom: 32px;
}

.description-text {
  font-size: $font-size-base;
  color: $text-secondary;
  line-height: 1.8;
  margin: 0;
  text-align: justify;
}

// 流程图
.flow-section {
  margin-bottom: 32px;
}

.flow-image-wrapper {
  width: 100%;
  background-color: $bg-secondary;
  border-radius: $border-radius;
  overflow: hidden;
  padding: 20px;

  @media (max-width: $breakpoint-sm) {
    padding: 16px;
  }
}

.flow-image {
  width: 100%;
  height: auto;
  display: block;
  border-radius: $border-radius-sm;
}

// 适用岗位
.roles-section {
  // 最后一个section不需要margin-bottom
}

.roles-list {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.role-tag {
  font-size: $font-size-base;
  padding: 8px 16px;
  border-radius: 20px;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  transition: all $transition-base;

  &:hover {
    transform: translateY(-2px);
    box-shadow: $shadow-sm;
  }
}

.role-icon {
  font-size: 16px;
}
</style>
