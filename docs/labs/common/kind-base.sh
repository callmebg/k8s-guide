#!/bin/bash
# K8s Guide 实验基础脚本
# 用法：source common/kind-base.sh

set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-k8s-guide-lab}"
KIND_CONFIG="${KIND_CONFIG:-}"

# 检查依赖
check_deps() {
  local missing=()
  for cmd in docker kind kubectl; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    echo "❌ 缺少依赖: ${missing[*]}"
    echo "   请参考 https://k8s-guide.vercel.app/beginner/02-install-kind"
    exit 1
  fi
}

# 创建 Kind 集群
create_cluster() {
  if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
    echo "⚠️  集群 ${CLUSTER_NAME} 已存在"
    return 0
  fi

  echo "🚀 创建 Kind 集群: ${CLUSTER_NAME}"

  local config_arg=""
  if [ -n "$KIND_CONFIG" ] && [ -f "$KIND_CONFIG" ]; then
    config_arg="--config=$KIND_CONFIG"
  fi

  kind create cluster --name "$CLUSTER_NAME" $config_arg

  echo "✅ 集群创建成功"
  kubectl cluster-info --context "kind-${CLUSTER_NAME}"
}

# 删除 Kind 集群
delete_cluster() {
  if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
    echo "🗑️  删除 Kind 集群: ${CLUSTER_NAME}"
    kind delete cluster --name "$CLUSTER_NAME"
    echo "✅ 集群已删除"
  else
    echo "⚠️  集群 ${CLUSTER_NAME} 不存在"
  fi
}

# 等待所有节点就绪
wait_ready() {
  echo "⏳ 等待节点就绪..."
  kubectl wait --for=condition=ready nodes --all --timeout=60s
  echo "✅ 所有节点就绪"
}

# 打印集群信息
cluster_info() {
  echo ""
  echo "📊 集群信息:"
  echo "  集群名称: ${CLUSTER_NAME}"
  echo "  kubectl context: kind-${CLUSTER_NAME}"
  echo ""
  kubectl get nodes -o wide
  echo ""
}
