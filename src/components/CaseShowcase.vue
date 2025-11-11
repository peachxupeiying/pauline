<template>
  <div class="case-showcase">
    <!-- 页面内导航条 -->
    <NavigationBar
      :active-section="activeSection"
      @navigate="scrollToSection"
    />

    <!-- 主内容区 -->
    <div class="showcase-content" ref="contentRef">
      <!-- 1. 案例头部区块 -->
      <section id="header" class="section">
        <CaseHeader :data="caseData" />
      </section>

      <!-- 2. 成效数据区块 -->
      <section id="performance" class="section">
        <PerformanceData :data="caseData.performance" />
      </section>

      <!-- 3. 能力介绍区块 -->
      <section id="capability" class="section">
        <CapabilityIntro :data="caseData.capability" />
      </section>

      <!-- 4. 业务场景区块 -->
      <section id="scenario" class="section">
        <BusinessScenario :data="caseData.scenario" />
      </section>

      <!-- 5. 用户评价区块 -->
      <section id="review" class="section">
        <UserReviews :data="caseData.review" />
      </section>

      <!-- 6. 快速上手区块 -->
      <section id="quick-start" class="section">
        <QuickStart
          :data="caseData.guide"
          :contact="caseData.contact"
          @apply="handleApply"
          @favorite="handleFavorite"
          @share="handleShare"
        />
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { ElMessage } from 'element-plus';
import { mockCaseData } from '@/data/mockData';
import NavigationBar from './NavigationBar.vue';
import CaseHeader from './CaseHeader.vue';
import PerformanceData from './PerformanceData.vue';
import CapabilityIntro from './CapabilityIntro.vue';
import BusinessScenario from './BusinessScenario.vue';
import UserReviews from './UserReviews.vue';
import QuickStart from './QuickStart.vue';

// 案例数据
const caseData = ref(mockCaseData);

// 当前激活的section
const activeSection = ref('header');

// 内容区引用
const contentRef = ref<HTMLElement>();

/**
 * 滚动到指定section
 */
const scrollToSection = (sectionId: string) => {
  const element = document.getElementById(sectionId);
  if (element) {
    element.scrollIntoView({
      behavior: 'smooth',
      block: 'start'
    });
  }
};

/**
 * 处理滚动事件，更新activeSection
 */
const handleScroll = () => {
  const sections = ['header', 'performance', 'capability', 'scenario', 'review', 'quick-start'];
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

  for (const sectionId of sections) {
    const element = document.getElementById(sectionId);
    if (element) {
      const { top, height } = element.getBoundingClientRect();
      // 如果section的顶部在视口中间以上，则认为是当前激活的section
      if (top <= window.innerHeight / 2 && top + height > window.innerHeight / 2) {
        activeSection.value = sectionId;
        break;
      }
    }
  }
};

/**
 * 处理申请试用
 */
const handleApply = () => {
  ElMessage.success('申请已提交，我们会尽快与您联系！');
};

/**
 * 处理收藏
 */
const handleFavorite = (isFavorited: boolean) => {
  if (isFavorited) {
    ElMessage.success('已收藏案例');
  } else {
    ElMessage.info('已取消收藏');
  }
};

/**
 * 处理分享
 */
const handleShare = (type: 'image' | 'link' | 'pdf') => {
  switch (type) {
    case 'image':
      ElMessage.info('正在生成长图...');
      // 这里可以实现html2canvas生成长图的逻辑
      setTimeout(() => {
        ElMessage.success('长图生成成功！');
      }, 1000);
      break;
    case 'link':
      const url = window.location.href;
      navigator.clipboard.writeText(url).then(() => {
        ElMessage.success('链接已复制到剪贴板');
      });
      break;
    case 'pdf':
      ElMessage.info('正在生成PDF...');
      // 这里可以实现jspdf生成PDF的逻辑
      setTimeout(() => {
        ElMessage.success('PDF生成成功！');
      }, 1000);
      break;
  }
};

onMounted(() => {
  window.addEventListener('scroll', handleScroll);
  handleScroll(); // 初始化
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll);
});
</script>

<style lang="scss" scoped>
.case-showcase {
  width: 100%;
  min-height: 100vh;
  background-color: $bg-secondary;
}

.showcase-content {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 80px 24px 24px; // 顶部留出导航条的空间

  @media (max-width: $breakpoint-sm) {
    padding: 70px 16px 16px;
  }
}

.section {
  margin-bottom: $spacing-lg;
  animation: fadeIn 0.5s ease-in-out;

  @media (max-width: $breakpoint-sm) {
    margin-bottom: $spacing-md;
  }
}
</style>
