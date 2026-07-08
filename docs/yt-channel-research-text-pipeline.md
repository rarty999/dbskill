# YouTube 频道研究 · 文字内容流水线（裁剪版）

> 本文档是从 `channel-research-and-video-generator` skill 裁剪出的**纯文字产出版本**，
> 供 Claude Code 云端会话直接执行。画面 / 配音 / 视频合成由用户自己的 N8N 工作流完成，
> 本流程只负责：频道研究 → 选题 → 标题 → 正文脚本 → 封面图与分镜提示词。

## 上下文交接（2026-07-08 会话探测结论）

- 运行环境：Claude Code on the web，环境名 **KK**。
- 网络策略已由用户改为 **Full**（对新会话生效）。旧会话（Trusted 策略）实测：
  - `youtube.com` / `i.ytimg.com` / `yt3.ggpht.com` → 代理 403 封锁
  - `www.googleapis.com`（YouTube Data API v3）→ **放行**，仅缺 API Key
  - `pypi.org` / `registry.npmjs.org` → 放行（可装 yt-dlp、youtube-transcript-api）
  - WebSearch 可用；WebFetch 对 YouTube 及第三方统计站（Social Blade 等）被目标站反爬 403
- **新会话第一步：先验证网络**。若下面命令返回 200，说明 Full 策略生效，走 Path A；
  否则走 Path B（API Key）或 Path C（WebSearch + 用户截图）。

```bash
curl -sS --cacert /root/.ccr/ca-bundle.crt -o /dev/null -w "%{http_code}" \
  "https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg"
```

## 研究引擎（按优先级）

| Path | 条件 | 做法 |
|---|---|---|
| **A. 直抓** | Full 网络生效 | `pip install yt-dlp youtube-transcript-api`。yt-dlp 拉频道视频列表（按播放量排序）、元数据；youtube-transcript-api 拉字幕；curl 直接下载 `https://i.ytimg.com/vi/<ID>/maxresdefault.jpg` 缩略图，用 Read 工具做视觉分析 |
| **B. 官方 API** | 用户提供免费 YouTube Data API v3 Key | search/videos/channels 端点拿频道数据、热门视频排行、标题/描述/标签、高赞评论。缩略图图片仍不可下载 → 请用户截图上传 |
| **C. 降级** | 都不行 | WebSearch + 模型知识 + 用户上传频道页/缩略图截图（视觉分析截图效果等同直抓） |

## 流水线（6 步，全部纯文字产出）

1. **要频道** —— 让用户给频道 URL / @handle。
2. **深度研究** —— 分析 TOP 热门视频（非最新）：标题公式、缩略图套路（构图/表情/文字处理/配色）、
   hook 结构（前 15 秒）、脚本格式、节奏与故事弧、核心可复制机制。
3. **研究报告** —— 生成 `research-report.html`（skill 内置中性模板）+ 对话内摘要。
4. **选题 + 标题** —— 按解码出的标题公式给 5–10 个候选，用户选定锁题。
5. **正文脚本** —— 用目标频道的 hook/结构/节奏写完整脚本，长度由用户指定；先给用户过稿。
6. **提示词包**（交给 N8N 的最终交付物，markdown 文件）：
   - 共享 STYLE BLOCK（风格常量，写一次）
   - 分镜表：镜头号 | 时间戳 | 旁白句 | 画面描述 | 场景提示词（= STYLE BLOCK + 场景变量）
   - 时间戳按字数/语速估算；若 N8N 生成配音后回传真实时长，再校准一版
   - 封面图提示词 ×2–3：套用该频道的缩略图公式（焦点主体、情绪、构图、配色、hook 文案 2–3 词）
   - 手部/角色一致性附加提示词（人物出镜时前置）

## 原则（沿用原 skill）

- 前半段（研究）才是核心价值，不研究不动笔。
- 脚本声音 = 被分析频道的风格，不套任何固定「品牌腔」。
- 学习不是抄袭：学的是模式，选题必须是对方没做过的。
- 每一步给用户过审后再进下一步（选题锁定 → 脚本过稿 → 分镜表确认）。
