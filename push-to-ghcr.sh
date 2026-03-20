#!/bin/bash
set -e

# AutoNovel 推送 Docker 镜像到 GHCR 脚本
# 使用方法: ./push-to-ghcr.sh [github-username]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 检查参数
if [ -z "$1" ]; then
  echo "用法: $0 <github-username>"
  echo "示例: $0 your-username"
  exit 1
fi

GITHUB_USERNAME="$1"
IMAGE_TAG="local"

echo "========================================="
echo "AutoNovel - 推送到 GHCR"
echo "GitHub 用户名: $GITHUB_USERNAME"
echo "========================================="
echo ""

# 提示输入 PAT（不显示输入）
echo "请输入你的 GitHub Personal Access Token (需要 write:packages 权限):"
read -s GITHUB_TOKEN
echo ""

# 登录 GHCR
echo "正在登录 ghcr.io..."
echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin
echo ""

# 构建并推送 web 镜像
echo "========================================="
echo "构建并推送 web 镜像..."
echo "========================================="
docker build -f web/Dockerfile -t "ghcr.io/$GITHUB_USERNAME/auto-novel-web:$IMAGE_TAG" .
docker push "ghcr.io/$GITHUB_USERNAME/auto-novel-web:$IMAGE_TAG"
echo ""

# 构建并推送 server 镜像
echo "========================================="
echo "构建并推送 server 镜像..."
echo "========================================="
docker build -f server/Dockerfile -t "ghcr.io/$GITHUB_USERNAME/auto-novel-server:$IMAGE_TAG" .
docker push "ghcr.io/$GITHUB_USERNAME/auto-novel-server:$IMAGE_TAG"
echo ""

echo "========================================="
echo "推送完成！"
echo "Web 镜像: ghcr.io/$GITHUB_USERNAME/auto-novel-web:$IMAGE_TAG"
echo "Server 镜像: ghcr.io/$GITHUB_USERNAME/auto-novel-server:$IMAGE_TAG"
echo "========================================="
echo ""
echo "要使用这些镜像，修改 docker-compose.yml 中的 image 字段为上述地址。"
