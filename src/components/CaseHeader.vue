<template>
  <div class="case-header">
    <el-card class="header-card" shadow="hover">
      <div class="header-content">
        <!-- 左侧：封面图/视频 -->
        <div class="cover-section">
          <div class="cover-wrapper" @click="handleCoverClick">
            <img :src="data.coverImage" :alt="data.name" class="cover-image" />
            <div v-if="data.coverVideo" class="play-button">
              <el-icon :size="48"><VideoPlay /></el-icon>
            </div>
          </div>
        </div>

        <!-- 右侧：案例信息 -->
        <div class="info-section">
          <!-- 案例名称 -->
          <h1 class="case-name">{{ data.name }}</h1>

          <!-- 案例等级标签 -->
          <div class="grade-badge" :class="`grade-${data.grade}`">
            <span class="grade-icon">{{ gradeIcon }}</span>
            <span class="grade-text">{{ gradeText }}</span>
          </div>

          <!-- 一句话亮点 -->
          <div class="highlight">{{ data.highlight }}</div>

          <!-- 基础信息 -->
          <div class="basic-info">
            <div class="info-item">
              <el-icon class="info-icon"><OfficeBuilding /></el-icon>
              <span class="info-label">所属组织：</span>
              <span class="info-value">{{ data.organization }}</span>
            </div>
            <div class="info-item">
              <el-icon class="info-icon"><Menu /></el-icon>
              <span class="info-label">所属领域：</span>
              <span class="info-value">{{ data.domain }}</span>
            </div>
            <div class="info-item">
              <el-icon class="info-icon"><Calendar /></el-icon>
              <span class="info-label">上线时间：</span>
              <span class="info-value">{{ data.onlineDate }}</span>
            </div>
          </div>

          <!-- 联系人信息（可折叠） -->
          <el-collapse v-model="activeCollapse" class="contact-collapse">
            <el-collapse-item name="contact">
              <template #title>
                <div class="collapse-title">
                  <el-icon><UserFilled /></el-icon>
                  <span>联系人信息</span>
                </div>
              </template>
              <div class="contact-info">
                <div class="contact-item">
                  <span class="contact-label">姓名：</span>
                  <span class="contact-value">{{ data.contact.name }}</span>
                </div>
                <div class="contact-item">
                  <span class="contact-label">电话：</span>
                  <span class="contact-value">{{ data.contact.phone }}</span>
                </div>
                <div class="contact-item">
                  <span class="contact-label">邮箱：</span>
                  <span class="contact-value">{{ data.contact.email }}</span>
                </div>
              </div>
            </el-collapse-item>
          </el-collapse>
        </div>
      </div>
    </el-card>

    <!-- 视频弹窗 -->
    <el-dialog v-model="videoDialogVisible" title="案例视频" width="80%" :before-close="handleVideoClose">
      <video v-if="data.coverVideo" :src="data.coverVideo" controls autoplay class="video-player"></video>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { VideoPlay, OfficeBuilding, Menu, Calendar, UserFilled } from '@element-plus/icons-vue';
import type { CaseDetail } from '@/types/case';

interface Props {
  data: CaseDetail;
}

const props = defineProps<Props>();

// 折叠面板激活项
const activeCollapse = ref<string[]>([]);

// 视频弹窗显示状态
const videoDialogVisible = ref(false);

// 等级图标
const gradeIcon = computed(() => {
  const icons = {
    gold: '👑',
    silver: '⭐',
    bronze: '🏅'
  };
  return icons[props.data.grade];
});

// 等级文本
const gradeText = computed(() => {
  const texts = {
    gold: '金牌案例',
    silver: '银牌案例',
    bronze: '铜牌案例'
  };
  return texts[props.data.grade];
});

/**
 * 处理封面点击
 */
const handleCoverClick = () => {
  if (props.data.coverVideo) {
    videoDialogVisible.value = true;
  }
};

/**
 * 处理视频弹窗关闭
 */
const handleVideoClose = (done: () => void) => {
  done();
};
</script>

<style lang="scss" scoped>
.case-header {
  width: 100%;
}

.header-card {
  border-radius: $border-radius-lg;
  overflow: hidden;

  :deep(.el-card__body) {
    padding: 0;
  }
}

.header-content {
  display: flex;
  gap: 32px;

  @media (max-width: $breakpoint-md) {
    flex-direction: column;
    gap: 24px;
  }
}

// 封面区域
.cover-section {
  flex: 0 0 40%;

  @media (max-width: $breakpoint-md) {
    flex: 1;
  }
}

.cover-wrapper {
  position: relative;
  width: 100%;
  padding-top: 56.25%; // 16:9比例
  background-color: $bg-tertiary;
  border-radius: $border-radius;
  overflow: hidden;
  cursor: pointer;

  &:hover {
    .play-button {
      transform: translate(-50%, -50%) scale(1.1);
    }
  }
}

.cover-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.play-button {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 80px;
  height: 80px;
  background-color: rgba(0, 0, 0, 0.6);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  transition: transform $transition-base;
}

// 信息区域
.info-section {
  flex: 1;
  padding: 32px;
  display: flex;
  flex-direction: column;
  gap: 20px;

  @media (max-width: $breakpoint-md) {
    padding: 24px;
  }
}

.case-name {
  font-size: $font-size-xxl;
  font-weight: 600;
  color: $text-primary;
  margin: 0;

  @media (max-width: $breakpoint-sm) {
    font-size: $font-size-xl;
  }
}

.grade-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: 20px;
  font-size: $font-size-base;
  font-weight: 500;
  color: white;
  align-self: flex-start;

  &.grade-gold {
    background: $gradient-gold;
  }

  &.grade-silver {
    background: $gradient-silver;
  }

  &.grade-bronze {
    background: $gradient-bronze;
  }
}

.grade-icon {
  font-size: 18px;
}

.highlight {
  font-size: $font-size-lg;
  font-weight: 600;
  color: $primary-color;
  line-height: 1.6;
}

.basic-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: $font-size-base;
  color: $text-secondary;
}

.info-icon {
  color: $primary-color;
}

.info-label {
  font-weight: 500;
}

.info-value {
  color: $text-primary;
}

.contact-collapse {
  border: none;

  :deep(.el-collapse-item__header) {
    border: none;
    background-color: transparent;
    padding: 0;
  }

  :deep(.el-collapse-item__wrap) {
    border: none;
    background-color: transparent;
  }

  :deep(.el-collapse-item__content) {
    padding: 12px 0 0;
  }
}

.collapse-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: $font-size-base;
  font-weight: 500;
  color: $primary-color;
}

.contact-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding-left: 24px;
}

.contact-item {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.contact-label {
  font-weight: 500;
}

.contact-value {
  color: $text-primary;
}

// 视频播放器
.video-player {
  width: 100%;
  max-height: 70vh;
  background-color: #000;
}
</style>
