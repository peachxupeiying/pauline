<template>
  <div class="navigation-bar" :class="{ 'is-scrolled': isScrolled }">
    <div class="nav-content">
      <div class="nav-items">
        <div
          v-for="item in navItems"
          :key="item.id"
          class="nav-item"
          :class="{ 'is-active': activeSection === item.id }"
          @click="handleNavigate(item.id)"
        >
          {{ item.label }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

interface NavItem {
  id: string;
  label: string;
}

interface Props {
  activeSection?: string;
}

interface Emits {
  (e: 'navigate', sectionId: string): void;
}

const props = withDefaults(defineProps<Props>(), {
  activeSection: 'header'
});

const emit = defineEmits<Emits>();

// 导航项
const navItems: NavItem[] = [
  { id: 'performance', label: '成效数据' },
  { id: 'capability', label: '能力介绍' },
  { id: 'scenario', label: '业务场景' },
  { id: 'review', label: '用户评价' },
  { id: 'quick-start', label: '快速上手' }
];

// 是否滚动过
const isScrolled = ref(false);

/**
 * 处理导航点击
 */
const handleNavigate = (sectionId: string) => {
  emit('navigate', sectionId);
};

/**
 * 处理页面滚动，添加阴影效果
 */
const handleScroll = () => {
  isScrolled.value = window.scrollY > 10;
};

onMounted(() => {
  window.addEventListener('scroll', handleScroll);
  handleScroll();
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll);
});
</script>

<style lang="scss" scoped>
.navigation-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background-color: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  transition: all $transition-base;

  &.is-scrolled {
    box-shadow: $shadow-md;
  }
}

.nav-content {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 24px;

  @media (max-width: $breakpoint-sm) {
    padding: 0 16px;
  }
}

.nav-items {
  display: flex;
  align-items: center;
  gap: 32px;
  height: 60px;
  overflow-x: auto;
  overflow-y: hidden;

  // 隐藏滚动条
  &::-webkit-scrollbar {
    display: none;
  }

  @media (max-width: $breakpoint-sm) {
    gap: 20px;
    height: 50px;
  }
}

.nav-item {
  flex-shrink: 0;
  font-size: $font-size-base;
  font-weight: 500;
  color: $text-secondary;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: $border-radius-sm;
  transition: all $transition-base;
  position: relative;

  &:hover {
    color: $primary-color;
  }

  &.is-active {
    color: $primary-color;

    &::after {
      content: '';
      position: absolute;
      bottom: -8px;
      left: 0;
      right: 0;
      height: 2px;
      background-color: $primary-color;
      border-radius: 1px;

      @media (max-width: $breakpoint-sm) {
        bottom: -6px;
      }
    }
  }

  @media (max-width: $breakpoint-sm) {
    font-size: $font-size-sm;
  }
}
</style>
