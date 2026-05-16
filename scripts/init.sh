#!/bin/bash
# init.sh - 初始化播客笔记工作目录
#
# 用法:
#   ./scripts/init.sh              # 创建默认 podcast-notes 目录
#   ./scripts/init.sh my-podcasts  # 创建自定义名称的目录
#
# 要求: yt-dlp, tree (可选)

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目名称
PROJECT_NAME="${1:-podcast-notes}"

# 检查依赖
check_dependency() {
    local cmd="$1"
    local name="$2"
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${YELLOW}⚠️  $name 未安装${NC}"
        return 1
    fi
    echo -e "${GREEN}✓${NC} $name 已安装 ($(command -v "$cmd"))"
    return 0
}

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  播客笔记工作流 - 初始化脚本${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# 检查依赖
echo "检查依赖..."
MISSING=0
check_dependency "yt-dlp" "yt-dlp" || MISSING=1
check_dependency "ffmpeg" "ffmpeg" || MISSING=1

if [ $MISSING -eq 1 ]; then
    echo ""
    echo -e "${YELLOW}请先安装缺失的依赖：${NC}"
    echo "  macOS: brew install yt-dlp ffmpeg"
    echo "  Linux: sudo apt install yt-dlp ffmpeg"
    echo ""
fi

echo ""

# 创建目录结构
echo "创建项目目录: $PROJECT_NAME"
mkdir -p "$PROJECT_NAME"/{raw,transcripts,notes,scripts}

# 创建示例文件
cat > "$PROJECT_NAME/urls.txt" << 'EOF'
# 在此添加下载链接，每行一个
# 示例：
# https://www.bilibili.com/video/BV1xx411c7mD
# https://www.youtube.com/watch?v=xxxxx

EOF

# 创建 README
cat > "$PROJECT_NAME/README.md" << 'EOF'
# 我的播客笔记

本目录用于存放播客/视频学习笔记。

## 目录结构

- `raw/` - 原始音视频文件
- `transcripts/` - 飞书妙记导出的文字记录
- `notes/` - 整理后的笔记
- `urls.txt` - 下载链接列表

## 工作流程

1. 在 `urls.txt` 中添加链接
2. 运行 `../scripts/batch-download.sh` 下载
3. 上传到飞书妙记转写
4. 导出到 `transcripts/`
5. AI 整理笔记到 `notes/`

EOF

echo -e "${GREEN}✓${NC} 目录结构已创建"

# 显示目录结构
echo ""
echo "目录结构:"
if command -v tree &> /dev/null; then
    tree -L 2 "$PROJECT_NAME"
else
    echo "$PROJECT_NAME/"
    ls -la "$PROJECT_NAME"
fi

# 创建完成后提示
echo ""
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  下一步操作${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo "1. ${GREEN}cd $PROJECT_NAME${NC}"
echo "2. ${GREEN}编辑 urls.txt，添加下载链接${NC}"
echo "3. ${GREEN}运行 ../scripts/batch-download.sh 下载${NC}"
echo "4. ${GREEN}上传到飞书妙记转写${NC}"
echo "5. ${GREEN}导出文字到 transcripts/${NC}"
echo "6. ${GREEN}将内容发给 AI 整理笔记${NC}"
echo ""
echo "详细说明请查看项目根目录的 README.md"
echo ""
