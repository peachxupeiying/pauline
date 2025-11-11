<template>
  <div class="capability-intro">
    <!-- 区块标题 -->
    <h2 class="section-title">能力介绍</h2>

    <el-card class="capability-card" shadow="hover">
      <!-- 智慧大脑 -->
      <div class="brain-section">
        <div class="brain-icon">🧠</div>
        <div class="brain-info">
          <div class="brain-label">智慧大脑</div>
          <div class="brain-value">{{ data.brain }}</div>
        </div>
      </div>

      <!-- 核心能力3宫格 -->
      <div class="core-abilities">
        <div
          v-for="ability in data.coreAbilities"
          :key="ability.title"
          class="ability-card"
        >
          <div class="ability-icon">{{ ability.icon }}</div>
          <div class="ability-title">{{ ability.title }}</div>
          <div class="ability-desc">{{ ability.description }}</div>
        </div>
      </div>

      <!-- 能力亮点 -->
      <div class="highlights-section">
        <h3 class="subsection-title">能力亮点</h3>
        <div class="highlights-list">
          <div
            v-for="(highlight, index) in data.highlights"
            :key="index"
            class="highlight-item"
          >
            <el-icon class="highlight-icon" color="#52c41a"><CircleCheck /></el-icon>
            <span class="highlight-text">{{ highlight }}</span>
          </div>
        </div>
      </div>

      <!-- 工作技能 -->
      <div class="skills-section">
        <h3 class="subsection-title">工作技能</h3>
        <div class="skills-container">
          <div class="skills-list">
            <el-tag
              v-for="(skill, index) in displayedSkills"
              :key="index"
              class="skill-tag"
              type="info"
            >
              {{ skill }}
            </el-tag>
          </div>
          <div v-if="data.skills.length > 8" class="skills-toggle">
            <el-button
              type="primary"
              link
              @click="toggleSkills"
            >
              {{ showAllSkills ? '收起' : `展开全部 (${data.skills.length})` }}
              <el-icon class="toggle-icon" :class="{ 'is-rotated': showAllSkills }">
                <ArrowDown />
              </el-icon>
            </el-button>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { CircleCheck, ArrowDown } from '@element-plus/icons-vue';
import type { Capability } from '@/types/case';

interface Props {
  data: Capability;
}

const props = defineProps<Props>();

// 是否显示全部技能
const showAllSkills = ref(false);

// 显示的技能列表
const displayedSkills = computed(() => {
  if (showAllSkills.value || props.data.skills.length <= 8) {
    return props.data.skills;
  }
  return props.data.skills.slice(0, 8);
});

/**
 * 切换技能展示
 */
const toggleSkills = () => {
  showAllSkills.value = !showAllSkills.value;
};
</script>

<style lang="scss" scoped>
.capability-intro {
  width: 100%;
}

.section-title {
  font-size: $font-size-xl;
  font-weight: 600;
  color: $text-primary;
  margin: 0 0 24px 0;
}

.capability-card {
  border-radius: $border-radius;

  :deep(.el-card__body) {
    padding: 32px;

    @media (max-width: $breakpoint-sm) {
      padding: 24px;
    }
  }
}

// 智慧大脑
.brain-section {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: $border-radius;
  margin-bottom: 32px;
}

.brain-icon {
  font-size: 48px;
}

.brain-info {
  flex: 1;
}

.brain-label {
  font-size: $font-size-sm;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 4px;
}

.brain-value {
  font-size: $font-size-xl;
  font-weight: 600;
  color: white;
}

// 核心能力
.core-abilities {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 32px;

  @media (max-width: $breakpoint-md) {
    grid-template-columns: 1fr;
    gap: 16px;
  }
}

.ability-card {
  padding: 24px;
  background-color: $bg-secondary;
  border-radius: $border-radius;
  text-align: center;
  transition: all $transition-base;

  &:hover {
    transform: translateY(-4px);
    box-shadow: $shadow-md;
  }
}

.ability-icon {
  font-size: 40px;
  margin-bottom: 12px;
}

.ability-title {
  font-size: $font-size-lg;
  font-weight: 600;
  color: $text-primary;
  margin-bottom: 8px;
}

.ability-desc {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.6;
}

// 能力亮点
.highlights-section {
  margin-bottom: 32px;
}

.subsection-title {
  font-size: $font-size-lg;
  font-weight: 600;
  color: $text-primary;
  margin: 0 0 16px 0;
}

.highlights-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.highlight-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 12px;
  background-color: $bg-secondary;
  border-radius: $border-radius-sm;
  transition: background-color $transition-base;

  &:hover {
    background-color: #e6f7ff;
  }
}

.highlight-icon {
  flex-shrink: 0;
  margin-top: 2px;
}

.highlight-text {
  font-size: $font-size-base;
  color: $text-primary;
  line-height: 1.6;
}

// 工作技能
.skills-section {
  // 不需要额外margin，因为是最后一个部分
}

.skills-container {
  // 容器样式
}

.skills-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 16px;
}

.skill-tag {
  font-size: $font-size-sm;
  padding: 6px 12px;
  border-radius: 4px;
  transition: all $transition-base;

  &:hover {
    transform: scale(1.05);
  }
}

.skills-toggle {
  text-align: center;
}

.toggle-icon {
  margin-left: 4px;
  transition: transform $transition-base;

  &.is-rotated {
    transform: rotate(180deg);
  }
}
</style>
