# 播客/视频笔记工作流 (Podcast Notes Workflow)

> 将播客/视频高效转化为结构化笔记
> 支持：小宇宙、喜马拉雅、B站视频、YouTube 等

## 工作流概览

```
视频/音频链接 → 下载 → 飞书妙记转写 → 导出文本 → AI整理笔记
```

## 适用场景

- 学习播客课程（如小宇宙、喜马拉雅）
- 观看技术视频（B站、YouTube）
- 整理视频教程（如 TapTap REP 教程）
- 任何需要将音视频转化为文字笔记的场景

## 注意事项

⚠️ **飞书妙记需要手动操作**
飞书妙记没有开放公共 API，无法自动化上传音视频和导出文本。
这一步需要用户手动完成：
1. 在飞书妙记中上传音视频
2. 等待 AI 转写完成
3. 导出文本（支持 TXT 和 DOCX）
4. 将文本内容提供给 AI 整理

## 工作流程详解

### 第一步：获取音视频

**支持的平台：**

| 平台 | 下载方式 | 说明 |
|-----|---------|------|
| 小宇宙 | RSS / 音频直链 | 需要抓包获取直链 |
| 喜马拉雅 | 抓包 / 第三方工具 | 需要解析 |
| B站 | yt-dlp | `yt-dlp "URL"` |
| YouTube | yt-dlp | `yt-dlp "URL"` |
| 抖音/快手 | 抓包 | 需要浏览器开发者工具 |
| 其他网站 | 浏览器 F12 抓包 | 通用方法 |

**推荐工具：**
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - 支持 1000+ 网站
- [you-get](https://github.com/soimort/you-get) - 备用下载工具

**安装 yt-dlp：**
```bash
# macOS
brew install yt-dlp

# Windows (需要 WSL 或 Python)
pip install yt-dlp
```

### 第二步：飞书妙记转写

1. 打开飞书 → 搜索「飞书妙记」或从「工作台」进入
2. 点击「上传本地文件」
3. 选择已下载的音视频文件
4. 等待 AI 转写完成

**设置建议：**
- 选择正确的音频语言
- 支持中/英/日/韩等 12 种语言
- 1 小时视频约需 5 分钟转写

### 第三步：导出文本

1. 打开妙记内容
2. 点击右上角「导出」
3. 选择格式：
   - **TXT**：纯文本，方便后续处理
   - **DOCX**：Word 格式，可直接编辑
4. 保存到本地

### 第四步：AI 整理笔记

将导出的文本内容提供给 AI，AI 会帮你：
1. **提炼核心要点** - 每个章节/段落讲了什么
2. **提取关键概念** - 术语、公式、方法论
3. **生成结构化笔记** - 便于回顾和复习
4. **制作行动清单** - 你可以立即执行的行动

---

## 快速开始

### 1. 初始化工作目录

```bash
# 创建项目目录
mkdir -p podcast-notes/{raw,transcripts,notes}
cd podcast-notes
```

### 2. 下载音视频

```bash
# 单个下载
yt-dlp -o "%(title)s.%(ext)s" "视频URL"

# 批量下载（创建 urls.txt）
yt-dlp -a urls.txt

# 带 referer 头的下载（某些网站需要）
yt-dlp --add-header "Referer:https://example.com" "URL"
```

### 3. 整理笔记（给 AI 的提示词）

将以下信息发给 AI：

```
请帮我整理以下播客/视频的笔记：

【内容】
[粘贴导出的文字内容]

【整理要求】
1. 提炼核心要点（3-5个）
2. 提取关键概念和术语
3. 整理成结构化的大纲
4. 生成行动清单
5. 如有需要，制作思维导图

【背景】
[可选：这是关于XX主题的内容，我想学习XX方面的知识]
```

---

## 常用命令参考

### yt-dlp 常用命令

```bash
# 查看可用格式
yt-dlp --list-formats "URL"

# 下载最高质量
yt-dlp -f "bestvideo+bestaudio/best" "URL"

# 转换为 MP3（播客）
yt-dlp -x --audio-format mp3 "URL"

# 下载播放列表
yt-dlp --playlist-start 1 --playlist-end 10 "PlaylistURL"

# 断点续传
yt-dlp -c "URL"
```

### FFmpeg 常用命令

```bash
# 转换格式
ffmpeg -i input.mov -c:v libx264 output.mp4

# 压缩视频
ffmpeg -i input.mp4 -vf "scale=1280:-2" -crf 28 output.mp4

# 提取音频
ffmpeg -i video.mp4 -vn -acodec mp3 output.mp3

# 合并音视频
ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -c:a aac output.mp4
```

---

## 常见问题

**Q: 视频下载被拒绝（403/防盗链）？**
```bash
# 尝试添加 referer 头
yt-dlp --add-header "Referer:https://目标网站.com" "URL"

# 或添加 cookies
yt-dlp --cookies-from-browser chrome "URL"
```

**Q: 视频太大无法上传飞书？**
```bash
# 压缩到 2GB 以下
ffmpeg -i input.mp4 -fs 1900M -c copy output.mp4

# 或降低分辨率
ffmpeg -i input.mp4 -vf "scale=1280:-2" -crf 24 output.mp4
```

**Q: 如何获取小宇宙播客的音频直链？**
1. 打开小宇宙播客页面
2. F12 打开开发者工具
3. 切换到 Network 标签
4. 播放音频，筛选 `mp3` 或 `m4a`
5. 复制链接，用 yt-dlp 下载

**Q: 转写质量不佳？**
- 确保音频清晰，无背景噪音
- 选择正确的语言选项
- 对于专业术语较多的内容，可能需要人工校对

---

## 目录结构建议

```
podcast-notes/
├── README.md              # 本文件
├── raw/                   # 原始音视频
│   ├── episode-01.mp3
│   └── episode-02.mp4
├── transcripts/            # 转写文本
│   ├── episode-01.txt
│   └── episode-02.docx
├── notes/                 # 整理后的笔记
│   ├── episode-01-notes.md
│   └── episode-02-notes.md
└── urls.txt               # 下载链接列表（可选）
```

---

## 相关资源

- [yt-dlp GitHub](https://github.com/yt-dlp/yt-dlp)
- [yt-dlp 支持网站列表](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)
- [FFmpeg 下载](https://ffmpeg.org/download.html)
- [飞书妙记帮助](https://www.feishu.cn/hc/zh-CN/articles/360033241654)

---

## 更新日志

### v1.0.0 (2026-05-17)
- 初始版本
- 支持常见视频/播客平台
- 包含飞书妙记工作流

---

*如有问题或建议，欢迎提交 Issue 或 Pull Request。*
