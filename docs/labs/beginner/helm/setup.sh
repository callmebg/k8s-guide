#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps

# 检查 Helm 是否安装
if ! command -v helm &> /dev/null; then
  echo "⚠️  Helm 未安装，正在安装..."
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

create_cluster
wait_ready

# 添加 bitnami 仓库
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo "✅ Helm 就绪，bitnami 仓库已添加"
echo ""
echo "Helm 版本："
helm version --short
echo ""
echo "已添加的仓库："
helm repo list
