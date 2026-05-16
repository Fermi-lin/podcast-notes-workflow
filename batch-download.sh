#!/bin/bash
# batch-download.sh - 批量下载音视频
#
# 用法:
#   ./scripts/batch-download.sh              # 使用默认 ./raw 目录
#   ./scripts/batch-download.sh ./downloads  # 自定义输出目录
#
# 要求: yt-dlp

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 输出目录
OUTPUT_DIR="${1:-./raw}"

# 检查 yt-dlp 是否安装
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  播客笔记工作流 - 批量下载${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

if ! command -v yt-dlp &> /dev/null; then
    echo -e "${RED}❌ yt-dlp 未安装${NC}"
    echo ""
    echo -e "${YELLOW}安装方法：${NC}"
    echo "  macOS: brew install yt-dlp"
    echo "  Linux: sudo apt install yt-dlp"
    echo "  其他: pip install yt-dlp"
    exit 1
fi

echo -e "${GREEN}✓${NC} yt-dlp 已安装 ($(yt-dlp --version | head -1))"
echo ""

# 创建输出目录
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}✓${NC} 输出目录: $OUTPUT_DIR"
echo ""

# 检查 urls.txt 是否存在
if [ ! -f "urls.txt" ]; then
    echo -e "${YELLOW}📝 urls.txt 不存在，创建示例文件${NC}"
    cat > urls.txt << 'EOF'
# 在此添加下载链接，每行一个
#
# 示例：
# https://www.bilibili.com/video/BV1xx411c7mD
# https://www.youtube.com/watch?v=xxxxx
# https://www.taptap.cn/moment/443066027056563879
#
# 小宇宙播客请先抓包获取直链

EOF
    echo ""
    echo -e "${YELLOW}请编辑 urls.txt 添加下载链接后重新运行${NC}"
    exit 1
fi

# 统计链接数量
LINK_COUNT=$(grep -v '^#' urls.txt | grep -v '^$' | wc -l | tr -d ' ')
echo -e "${GREEN}📋${NC} 发现 $LINK_COUNT 个下载链接"
echo ""

# 确认下载
read -p "确认开始下载？(y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "已取消"
    exit 0
fi

echo ""
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  开始下载...${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# 下载选项说明
echo "下载选项:"
echo "  - 保存到: $OUTPUT_DIR/"
echo "  - 格式: MP3 (提取音频)"
echo "  - 断点续传: 已启用"
echo ""

# 下载
yt-dlp \
    --download-archive downloaded.txt \
    --output "$OUTPUT_DIR/%(title)s.%(ext)s" \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --embed-thumbnail \
    --add-metadata \
    -a urls.txt

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  ✅ 下载完成！${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# 显示下载结果
if [ "$(ls -A "$OUTPUT_DIR")" ]; then
    echo "下载的文件:"
    ls -lh "$OUTPUT_DIR"/*.mp3 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}' || true
fi

echo ""
echo -e "${BLUE}下一步：${NC}"
echo "1. 将文件上传到飞书妙记转写"
echo "2. 导出文字到 transcripts/"
echo "3. 将内容发给 AI 整理笔记"
echo ""
