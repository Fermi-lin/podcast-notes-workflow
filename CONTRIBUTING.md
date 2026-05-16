# 贡献指南

感谢你愿意为 Podcast Notes Workflow 贡献力量！🎉

## 如何贡献

### 1. 报告问题

遇到问题？请先检查：

- [ ] 是否查看过 [常见问题](./README.md#-常见问题)？
- [ ] 是否使用最新版本的工具？

提交 Issue 时，请包含：

```
- 操作系统和版本
- 相关工具版本 (yt-dlp --version)
- 目标平台和链接
- 完整的错误信息
- 你尝试过的解决方法
```

### 2. 改进文档

我们欢迎：

- 修正错别字或语法错误
- 添加更多使用场景
- 翻译成其他语言
- 添加更多平台的下载方法

### 3. 提交代码

#### 开发流程

1. **Fork** 本仓库
2. 创建你的特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交你的更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

#### 代码规范

- Bash 脚本使用 `shellcheck` 检查
- 文档使用 Markdown 格式
- 命令行示例使用代码块

### 4. 添加新平台支持

如果你添加了新平台的下载方法：

1. 在 README.md 中添加平台说明
2. 包含示例命令
3. 包含可能的限制和解决方案

## 项目结构

```
podcast-notes-workflow/
├── README.md              # 主文档
├── README_zh.md          # 中文文档（如有）
├── CHECKLIST.md          # 使用检查清单
├── CONTRIBUTING.md        # 本文件
├── ISSUE_TEMPLATE.md      # Issue 模板
├── LICENSE               # MIT 许可证
├── scripts/
│   ├── init.sh          # 初始化脚本
│   └── batch-download.sh # 批量下载脚本
└── docs/                # 额外文档
```

## Commit 消息规范

```
feat: 添加 xxx 功能
fix: 修复 xxx 问题
docs: 更新 xxx 文档
refactor: 重构 xxx 代码
test: 添加 xxx 测试
```

## 问题交流

如有疑问，欢迎：

- 在 GitHub Issues 中提问
- 提交 Pull Request 讨论

---

再次感谢你的贡献！
