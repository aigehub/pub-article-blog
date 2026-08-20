# Hugo 博客

该目录是 `pub-article-flow` 的静态博客发布目标，使用 Hugo Extended 和 PaperMod。

## 本地运行

要求：

- Hugo Extended 0.146.0 或更高版本（与 GitHub Pages 构建一致的版本是 0.165.0）
- Git

不要用 `apt` 或 `snap` 安装 Hugo：Ubuntu 仓库和 snap 通常不是 Extended 版，PaperMod 的 SCSS 会编译失败。用官方 Extended 二进制：

```bash
./scripts/install-hugo.sh
```

脚本会把 `hugo` 装到 `~/.local/bin`。若当前 shell 仍提示找不到命令，执行：

```bash
export PATH="$HOME/.local/bin:$PATH"
hash -r
hugo version
```

`hugo version` 应包含 `extended`。

首次安装主题：

```bash
./scripts/setup-theme.sh
```

脚本默认检出已验证的 PaperMod revision；可通过 `PAPERMOD_REF` 临时指定其他 commit、tag 或 branch。

启动开发服务器：

```bash
hugo server --buildDrafts
```

生产构建：

```bash
./scripts/build.sh
```

构建结果位于 `public/`。

## 从文章任务导出

在仓库根目录构建 `pubflow` 后执行：

```bash
npm run build
node dist/cli.js blog export '<job-dir>' --blog-dir blog
```

导出器读取：

- `<job-dir>/typed.md`
- `<job-dir>/typed.html`
- `<job-dir>/assets/manifest.json`
- manifest 引用的封面与正文图片

并生成：

```text
content/posts/<slug>/index.md
content/posts/<slug>/wechat.fragment
content/posts/<slug>/cover.<ext>
content/posts/<slug>/image-01.<ext>
```

文章页通过覆盖 PaperMod 的 `layouts/single.html` 渲染 `wechat.fragment`，保留微信排版的内联样式；`index.md` 继续用于列表、RSS 和搜索。站点使用浅色卡片包裹正文，避免暗色主题把微信配色冲掉。文件不用 `.html` 后缀，避免 Hugo 0.165 把 HTML 当成内容页并被安全策略拒绝。

重复导出同一主题会原子替换对应 Page Bundle，避免遗留旧图片。

如果该仓库位于 `/home/lin/pub-article-flow` 同级的 `/home/lin/pub-article-blog`，主项目的 `run-topic.sh` 会自动：

1. 拉取博客仓库远程 `main`。
2. 导出本次文章。
3. 仅提交 `content/posts`。
4. 推送到 GitHub。
5. 由本仓库的 GitHub Pages 工作流自动构建并部署。

设置 `PUBFLOW_BLOG_GIT_PUSH=0` 可保留自动导出、关闭自动提交和推送。

## GitHub Pages

目录中的 `.github/workflows/deploy-pages.yml` 可用于独立博客仓库：

1. 将 `blog/` 作为一个独立 GitHub 仓库推送。
2. 在仓库 Settings → Pages 中选择 GitHub Actions。
3. 修改 `hugo.yaml` 的 `baseURL`，或让工作流使用 Pages 输出的 URL。
4. 推送 `main` 后自动构建和部署。

## Cloudflare Pages

推荐把源码保存在 GitHub、生产站托管到 Cloudflare Pages：

- Build command：`./scripts/build.sh`
- Build output directory：`public`
- Root directory：博客仓库根目录

## AdSense

审核通过后：

1. 在 `hugo.yaml` 设置：

   ```yaml
   params:
     adsensePublisherId: ca-pub-xxxxxxxxxxxxxxxx
   ```

2. 将 `static/ads.txt.example` 复制为 `static/ads.txt`，替换为真实 publisher ID。
3. 补全 About、Contact 和 Privacy 页面。
4. 在 AdSense 中完成域名所有权验证和网站审核。
5. 面向 EEA、英国或瑞士用户投放个性化广告时配置 Google 认证 CMP。

全局 Auto Ads 脚本通过 `layouts/partials/extend_head.html` 异步加载。

手动广告位可在文章 Markdown 中使用：

```text
{{</* ad slot="1234567890" */>}}
```

## 上线前配置

请至少修改：

- `baseURL`
- 站点标题与描述
- 作者
- 联系方式
- 隐私政策
- 社交链接
- 自定义域名
- AdSense publisher ID 和 `ads.txt`
