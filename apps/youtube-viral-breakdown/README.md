# YouTube 爆款视频拆解助手

一个零依赖的单文件 Web 应用：粘贴 YouTube 视频链接，用你自己的 Gemini API Key 生成爆款拆解报告（时间线拆解、爆款公式、原创复刻、完整脚本、分镜表、标题封面方案、选题库、制作清单），支持导出 Markdown / JSON。

## 使用方式

**方式一：本地直接打开（最简单）**

下载 `index.html`，双击用浏览器打开即可，无需安装任何东西。

**方式二：部署成公开网址（GitHub Pages）**

仓库 Settings → Pages → Source 选 `Deploy from a branch`，选择 `main` 分支后保存，
访问 `https://<用户名>.github.io/<仓库名>/apps/youtube-viral-breakdown/`。

## 准备工作

1. 到 [Google AI Studio](https://aistudio.google.com/apikey) 免费申请一个 Gemini API Key
2. 打开页面，把 Key 粘贴到设置区，点「测试连接」确认有效
3. 粘贴一条**公开的** YouTube 视频链接（普通视频或 Shorts 均可），点「开始拆解」

## 说明

- 没有后端：所有请求由你的浏览器直接发给 Google Gemini，API Key 只保存在本机浏览器 localStorage
- 视频分析基于 Gemini 的原生 YouTube 视频理解能力（无需下载/上传视频）
- 免费额度有限：长视频消耗大，建议优先用 Shorts 或短视频测试；输出被截断时关掉部分生成开关
- 需要能访问 Google 服务的网络环境
- 复刻请做原创化改编，尊重原作者版权
