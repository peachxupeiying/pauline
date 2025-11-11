<template>
  <div class="user-reviews">
    <!-- 区块标题 -->
    <h2 class="section-title">用户评价</h2>

    <el-card class="reviews-card" shadow="hover">
      <!-- 综合评分 -->
      <div class="overall-rating">
        <div class="rating-value">{{ data.overallScore.toFixed(1) }}</div>
        <div class="rating-stars">
          <el-rate
            v-model="data.overallScore"
            disabled
            show-score
            text-color="#faad14"
            :colors="['#faad14', '#faad14', '#faad14']"
            score-template=""
          />
        </div>
        <div class="rating-count">基于 {{ data.totalReviews }} 条评价</div>
      </div>

      <!-- 评分维度条形图 -->
      <div class="dimensions-section">
        <h3 class="subsection-title">评分维度</h3>
        <div class="dimensions-list">
          <div
            v-for="dimension in data.dimensions"
            :key="dimension.name"
            class="dimension-item"
          >
            <div class="dimension-name">{{ dimension.name }}</div>
            <div class="dimension-bar-container">
              <div
                class="dimension-bar"
                :style="{ width: `${(dimension.score / 5) * 100}%` }"
              ></div>
            </div>
            <div class="dimension-score">{{ dimension.score.toFixed(1) }}</div>
          </div>
        </div>
      </div>

      <!-- 用户证言 -->
      <div class="testimonials-section">
        <h3 class="subsection-title">用户证言</h3>
        <div class="testimonials-grid">
          <div
            v-for="testimonial in data.testimonials"
            :key="testimonial.name"
            class="testimonial-card"
          >
            <div class="testimonial-header">
              <div class="user-avatar">
                <img :src="testimonial.avatar" :alt="testimonial.name" />
              </div>
              <div class="user-info">
                <div class="user-name">{{ testimonial.name }}</div>
                <div class="user-position">{{ testimonial.position }}</div>
              </div>
            </div>
            <div class="testimonial-content">
              <el-rate
                v-model="testimonial.rating"
                disabled
                size="small"
                :colors="['#faad14', '#faad14', '#faad14']"
              />
              <p class="testimonial-text">{{ testimonial.content }}</p>
              <div class="testimonial-date">{{ testimonial.date }}</div>
            </div>
          </div>
        </div>

        <!-- 查看全部评价按钮 -->
        <div class="view-all-section">
          <el-button type="primary" plain>
            查看全部评价 ({{ data.totalReviews }})
          </el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import type { Review } from '@/types/case';

interface Props {
  data: Review;
}

defineProps<Props>();
</script>

<style lang="scss" scoped>
.user-reviews {
  width: 100%;
}

.section-title {
  font-size: $font-size-xl;
  font-weight: 600;
  color: $text-primary;
  margin: 0 0 24px 0;
}

.reviews-card {
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

// 综合评分
.overall-rating {
  text-align: center;
  padding: 32px 0;
  margin-bottom: 32px;
  border-bottom: 2px solid $border-light;

  @media (max-width: $breakpoint-sm) {
    padding: 24px 0;
  }
}

.rating-value {
  font-size: 64px;
  font-weight: 700;
  color: $primary-color;
  line-height: 1;
  margin-bottom: 12px;

  @media (max-width: $breakpoint-sm) {
    font-size: 48px;
  }
}

.rating-stars {
  margin-bottom: 8px;

  :deep(.el-rate) {
    height: auto;
  }

  :deep(.el-rate__icon) {
    font-size: 32px;
    margin-right: 4px;

    @media (max-width: $breakpoint-sm) {
      font-size: 24px;
    }
  }
}

.rating-count {
  font-size: $font-size-base;
  color: $text-tertiary;
}

// 评分维度
.dimensions-section {
  margin-bottom: 32px;
}

.dimensions-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.dimension-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.dimension-name {
  flex: 0 0 100px;
  font-size: $font-size-base;
  color: $text-secondary;

  @media (max-width: $breakpoint-sm) {
    flex: 0 0 80px;
    font-size: $font-size-sm;
  }
}

.dimension-bar-container {
  flex: 1;
  height: 20px;
  background-color: $bg-tertiary;
  border-radius: 10px;
  overflow: hidden;
}

.dimension-bar {
  height: 100%;
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
  transition: width 0.8s ease-out;
}

.dimension-score {
  flex: 0 0 40px;
  text-align: right;
  font-size: $font-size-base;
  font-weight: 600;
  color: $primary-color;

  @media (max-width: $breakpoint-sm) {
    font-size: $font-size-sm;
  }
}

// 用户证言
.testimonials-section {
  // 最后一个section
}

.testimonials-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 24px;

  @media (max-width: $breakpoint-sm) {
    grid-template-columns: 1fr;
  }
}

.testimonial-card {
  padding: 20px;
  background-color: $bg-secondary;
  border-radius: $border-radius;
  transition: all $transition-base;

  &:hover {
    transform: translateY(-4px);
    box-shadow: $shadow-md;
  }
}

.testimonial-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.user-avatar {
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  background-color: $bg-tertiary;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.user-info {
  flex: 1;
}

.user-name {
  font-size: $font-size-base;
  font-weight: 600;
  color: $text-primary;
  margin-bottom: 2px;
}

.user-position {
  font-size: $font-size-sm;
  color: $text-tertiary;
}

.testimonial-content {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.testimonial-text {
  font-size: $font-size-base;
  color: $text-secondary;
  line-height: 1.6;
  margin: 0;
  @extend .ellipsis-3;
}

.testimonial-date {
  font-size: $font-size-sm;
  color: $text-tertiary;
}

.view-all-section {
  text-align: center;
  padding-top: 16px;
}
</style>
