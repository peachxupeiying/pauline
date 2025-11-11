<template>
  <span>{{ displayValue }}</span>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue';

interface Props {
  value: number;
  format?: 'number' | 'currency';
  duration?: number;
}

const props = withDefaults(defineProps<Props>(), {
  format: 'number',
  duration: 1500
});

const displayValue = ref('0');

/**
 * 格式化数字
 */
const formatNumber = (num: number): string => {
  const rounded = Math.round(num);
  const formatted = rounded.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');

  if (props.format === 'currency') {
    return `¥${formatted}`;
  }
  return formatted;
};

/**
 * 执行数字动画
 */
const animate = (targetValue: number) => {
  const startValue = 0;
  const startTime = Date.now();
  const duration = props.duration;

  const step = () => {
    const now = Date.now();
    const elapsed = now - startTime;
    const progress = Math.min(elapsed / duration, 1);

    // 使用缓动函数（easeOutQuart）
    const easeProgress = 1 - Math.pow(1 - progress, 4);
    const currentValue = startValue + (targetValue - startValue) * easeProgress;

    displayValue.value = formatNumber(currentValue);

    if (progress < 1) {
      requestAnimationFrame(step);
    } else {
      displayValue.value = formatNumber(targetValue);
    }
  };

  requestAnimationFrame(step);
};

// 监听值变化
watch(
  () => props.value,
  (newValue) => {
    animate(newValue);
  },
  { immediate: false }
);

onMounted(() => {
  // 延迟执行动画，等待元素进入视口
  setTimeout(() => {
    animate(props.value);
  }, 100);
});
</script>
