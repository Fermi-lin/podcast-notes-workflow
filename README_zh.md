# 播客笔记工作流 (Podcast Notes Workflow)

> 将播客/视频高效转化为结构化笔记的 AI 工作流
>
> 支持：小宇宙、喜马拉雅、B站视频、YouTube、TapTap 等 1000+ 平台

---

## 🎯 这个 Skill 做什么？

当你有一个播客/视频想要学习，但不想花时间慢慢看时，这个工作流可以帮你：

1. **下载** - 从各种平台获取音视频（yt-dlp 支持 1000+ 网站）
2. **转写** - 用飞书妙记将音视频转为文字（支持 12 种语言）
3. **整理** - AI 帮你提炼要点、整理结构化笔记

## 📋 工作流程

```
视频/音频链接 → yt-dlp 下载 → 飞书妙记转写 → 导出文本 → AI整理笔记
```

**注意**：飞书妙记没有开放公共 API，上传和导出需要手动完成。

---

## 🚀 快速开始

### 准备工作

#### 1. 安装依赖

```bash
# macOS
brew install yt-dlp ffmpeg

# Linux
sudo apt install yt-dlp ffmpeg

# Windows (需要 WSL)
sudo apt install yt-dlp ffmpeg
```

#### 2. 初始化项目

```bash
# 克隆或下载本项目
git clone https://github.com/Fermi-lin/podcast-notes-workflow.git
cd podcast-notes-workflow

# 运行初始化脚本
./scripts/init.sh my-podcast-notes
cd my-podcast-notes

# 添加下载链接
vim urls.txt

# 下载音视频
../scripts/batch-download.sh
```

#### 3. 飞书妙记转写（手动 ⚠️）

1. 打开 [飞书](https://www.feishu.cn/) → 搜索「飞书妙记」
2. 点击「上传本地文件」→ 选择下载的音视频
3. 选择正确的语言（中文/英文/日文等）
4. 等待 AI 转写完成（约 5 分钟/小时）

#### 4. 导出文本

1. 打开妙记 → 点击右上角「导出」
2. 选择 **TXT** 或 **DOCX** 格式
3. 保存到 `transcripts/` 目录

#### 5. AI 整理笔记

将导出的文本发给 AI，使用以下提示词：

```markdown
请帮我整理以下播客/视频的笔记：

【内容】
[粘贴导出的文字内容]

【整理要求】
1. 提炼核心要点（3-5个）
2. 提取关键概念和术语
3. 整理成结构化的大纲
4. 生成行动清单（我可以立即执行的）

【背景】
[可选：这是关于XX主题的内容]
```

---

## 📝 全流程 Checklist

详见 [CHECKLIST.md](./CHECKLIST.md)

---

## 🔧 常用命令

### yt-dlp

```bash
# 查看可用格式
yt-dlp --list-formats "URL"

# 下载最高质量视频
yt-dlp -f "bestvideo+bestaudio/best" "URL"

# 提取音频（推荐用于播客）
yt-dlp -x --audio-format mp3 "URL"

# 批量下载
yt-dlp -a urls.txt

# 断点续传
yt-dlp -c "URL"

# 带 referer 头（某些网站需要）
yt-dlp --add-header "Referer:https://example.com" "URL"

# 使用浏览器 cookies（绕过登录限制）
yt-dlp --cookies-from-browser chrome "URL"
```

### FFmpeg

```bash
# 压缩视频（上传飞书前，建议 <2GB）
ffmpeg -i input.mp4 -vf "scale=1280:-2" -crf 28 output.mp4

# 提取音频
ffmpeg -i video.mp4 -vn -acodec mp3 output.mp3

# 转换格式
ffmpeg -i input.mov -c:v libx264 output.mp4

# 查看视频信息
ffprobe -v error -show_format -show_streams input.mp4
```

---

## 💡 高级技巧

### 获取小宇宙播客直链

1. 打开小宇宙播客页面
2. F12 打开开发者工具 → 切换到 Network 标签
3. 播放音频
4. 筛选条件输入 `mp3` 或 `m4a`
5. 右键点击请求 → Copy → Copy link address
6. 用 yt-dlp 下载

### TapTap 视频下载

TapTap 使用 blob URL，需要特殊处理：

```bash
# 直接使用 moment 页面链接
yt-dlp "https://www.taptap.cn/moment/数字ID"
```

### B站视频下载

```bash
# 下载单个视频
yt-dlp "https://www.bilibili.com/video/BVxxx"

# 下载整个系列/合集
yt-dlp --playlist-start 1 --playlist-end 10 "https://www.bilibili.com/video/avxxx"

# 仅下载音频
yt-dlp -x --audio-format mp3 "https://www.bilibili.com/video/BVxxx"
```

---

## ❓ 常见问题

### Q: 视频下载被拒绝（403 错误）

**解决方案：**
1. 尝试添加 `--cookies-from-browser chrome`
2. 或添加 `--add-header "Referer:https://目标网站.com"`
3. 或使用浏览器开发者工具抓取真实链接

### Q: 视频太大无法上传飞书

**解决方案：**
```bash
# 压缩到 2GB 以下
ffmpeg -i input.mp4 -fs 1900M -c copy output.mp4

# 或降低分辨率
ffmpeg -i input.mp4 -vf "scale=1280:-2" -crf 28 output.mp4
```

### Q: 转写质量不佳

**优化建议：**
- 确保音频清晰，无背景噪音
- 选择正确的语言选项
- 对于专业术语较多的内容，可能需要人工校对
- 可以分段转写（1小时以内的片段效果更好）

---

## 📁 项目结构

```
podcast-notes-workflow/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml       # Bug 报告模板
│   │   └── feature_request.yml  # 功能请求模板
│   └── workflows/
│       └── shellcheck.yml       # 脚本检查 CI
├── scripts/
│   ├── init.sh                 # 初始化脚本
│   ├── batch-download.sh       # 批量下载脚本
│   └── prompt-template.md      # AI 提示词模板
├── CHECKLIST.md                # 全流程检查清单
├── CONTRIBUTING.md             # 贡献指南
├── README.md                   # 本文档
├── SKILL.md                    # WorkBuddy Skill 定义
├── LICENSE                     # MIT 许可证
└── 飞书妙记上传指南.md           # 飞书妙记使用指南
```

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

- 报告 Bug → [Issue](https://github.com/Fermi-lin/podcast-notes-workflow/issues)
- 贡献代码 → [Pull Request](https://github.com/Fermi-lin/podcast-notes-workflow/pulls)
- 改进文档 → 直接编辑提交

详见 [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 📄 License

MIT License - 详见 [LICENSE](./LICENSE)

---

<p align="center">
  <a href="https://github.com/Fermi-lin/podcast-notes-workflow/stargazers">
    <img src="https://img.shields.io/github/stars/Fermi-lin/podcast-notes-workflow?style=social" alt="Stars">
  </a>
  <a href="https://github.com/Fermi-lin/podcast-notes-workflow/network/members">
    <img src="https://img.shields.io/github/forks/Fermi-lin/podcast-notes-workflow?style=social" alt="Forks">
  </a>
</p>
