<template>
  <div class="quick-start">
    <!-- 区块标题 -->
    <h2 class="section-title">快速上手</h2>

    <el-card class="quick-start-card" shadow="hover">
      <!-- 操作卡片 -->
      <div class="action-cards">
        <div class="action-card" @click="openManual">
          <div class="action-icon">📘</div>
          <div class="action-title">使用手册</div>
          <div class="action-desc">查看详细的使用说明和操作指南</div>
        </div>

        <div class="action-card" @click="openVideo">
          <div class="action-icon">🎬</div>
          <div class="action-title">视频教程</div>
          <div class="action-desc">观看视频快速了解核心功能</div>
        </div>

        <div class="action-card" @click="openFAQ">
          <div class="action-icon">❓</div>
          <div class="action-title">常见问题</div>
          <div class="action-desc">查找问题解答和故障排除</div>
        </div>
      </div>

      <!-- 联系信息 -->
      <div class="contact-section">
        <h3 class="subsection-title">联系我们</h3>
        <div class="contact-cards">
          <div class="contact-card">
            <el-icon class="contact-icon"><User /></el-icon>
            <div class="contact-info">
              <div class="contact-label">负责人</div>
              <div class="contact-value">{{ contact.name }}</div>
            </div>
          </div>

          <div class="contact-card">
            <el-icon class="contact-icon"><Phone /></el-icon>
            <div class="contact-info">
              <div class="contact-label">联系电话</div>
              <div class="contact-value">{{ contact.phone }}</div>
            </div>
          </div>

          <div class="contact-card">
            <el-icon class="contact-icon"><Message /></el-icon>
            <div class="contact-info">
              <div class="contact-label">邮箱</div>
              <div class="contact-value">{{ contact.email }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 底部操作按钮 -->
      <div class="bottom-actions">
        <el-button type="primary" size="large" @click="handleApply">
          <el-icon><DocumentAdd /></el-icon>
          申请试用
        </el-button>

        <el-button
          :type="isFavorited ? 'warning' : 'default'"
          size="large"
          @click="handleFavorite"
        >
          <el-icon>
            <StarFilled v-if="isFavorited" />
            <Star v-else />
          </el-icon>
          {{ isFavorited ? '已收藏' : '收藏案例' }}
        </el-button>

        <el-dropdown @command="handleShare" trigger="click">
          <el-button size="large">
            <el-icon><Share /></el-icon>
            分享给同事
            <el-icon class="el-icon--right"><ArrowDown /></el-icon>
          </el-button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="image">
                <el-icon><Picture /></el-icon>
                生成长图
              </el-dropdown-item>
              <el-dropdown-item command="link">
                <el-icon><Link /></el-icon>
                复制链接
              </el-dropdown-item>
              <el-dropdown-item command="pdf">
                <el-icon><Document /></el-icon>
                下载PDF
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import {
  User,
  Phone,
  Message,
  DocumentAdd,
  Star,
  StarFilled,
  Share,
  ArrowDown,
  Picture,
  Link,
  Document
} from '@element-plus/icons-vue';
import type { Guide, Contact } from '@/types/case';

interface Props {
  data: Guide;
  contact: Contact;
}

interface Emits {
  (e: 'apply'): void;
  (e: 'favorite', isFavorited: boolean): void;
  (e: 'share', type: 'image' | 'link' | 'pdf'): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();

// 收藏状态
const isFavorited = ref(false);

/**
 * 打开使用手册
 */
const openManual = () => {
  window.open(props.data.manual, '_blank');
};

/**
 * 打开视频教程
 */
const openVideo = () => {
  window.open(props.data.video, '_blank');
};

/**
 * 打开常见问题
 */
const openFAQ = () => {
  window.open(props.data.faqUrl, '_blank');
};

/**
 * 处理申请试用
 */
const handleApply = () => {
  emit('apply');
};

/**
 * 处理收藏
 */
const handleFavorite = () => {
  isFavorited.value = !isFavorited.value;
  emit('favorite', isFavorited.value);
};

/**
 * 处理分享
 */
const handleShare = (command: 'image' | 'link' | 'pdf') => {
  emit('share', command);
};
</script>

<style lang="scss" scoped>
.quick-start {
  width: 100%;
}

.section-title {
  font-size: $font-size-xl;
  font-weight: 600;
  color: $text-primary;
  margin: 0 0 24px 0;
}

.quick-start-card {
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

// 操作卡片
.action-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 32px;

  @media (max-width: $breakpoint-md) {
    grid-template-columns: 1fr;
    gap: 16px;
  }
}

.action-card {
  padding: 24px;
  background-color: $bg-secondary;
  border-radius: $border-radius;
  text-align: center;
  cursor: pointer;
  transition: all $transition-base;

  &:hover {
    transform: translateY(-4px);
    box-shadow: $shadow-md;
    background-color: #e6f7ff;
  }
}

.action-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.action-title {
  font-size: $font-size-lg;
  font-weight: 600;
  color: $text-primary;
  margin-bottom: 8px;
}

.action-desc {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.6;
}

// 联系信息
.contact-section {
  margin-bottom: 32px;
}

.contact-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;

  @media (max-width: $breakpoint-md) {
    grid-template-columns: 1fr;
  }
}

.contact-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background-color: $bg-secondary;
  border-radius: $border-radius-sm;
}

.contact-icon {
  font-size: 24px;
  color: $primary-color;
}

.contact-info {
  flex: 1;
}

.contact-label {
  font-size: $font-size-sm;
  color: $text-tertiary;
  margin-bottom: 4px;
}

.contact-value {
  font-size: $font-size-base;
  font-weight: 500;
  color: $text-primary;
}

// 底部操作按钮
.bottom-actions {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  padding-top: 16px;
  border-top: 2px solid $border-light;

  @media (max-width: $breakpoint-md) {
    flex-direction: column;
    width: 100%;

    .el-button {
      width: 100%;
    }
  }
}
</style>
