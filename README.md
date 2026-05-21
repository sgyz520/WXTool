# WXTool - 微信工具箱

[![Build](https://github.com/sgyz520/WXTool/actions/workflows/build.yml/badge.svg)](https://github.com/sgyz520/WXTool/actions/workflows/build.yml)

WeChat enhancement tweak for iOS.

## 功能

| 功能 | 说明 | 状态 |
|------|------|------|
| 图片堆叠 | 强制开启微信图片堆叠发送与显示 | ✅ |
| 消息防撤回 | 阻止对方撤回消息，保留聊天记录 | ✅ |

## 版本兼容

- 微信 8.0.62+
- iOS 14.0+ (arm64 / arm64e)

## 项目结构

```
WXTool/
├── Tweak.x                  # 入口点
├── WCMediaStack.h           # 公共头文件（日志、常量、版本标记）
├── features/
│   ├── MediaStack.x         # 图片堆叠功能
│   └── AntRecall.x          # 消息防撤回功能
├── .github/workflows/
│   └── build.yml            # GitHub Actions 自动打包
├── Makefile                 # Theos 构建配置
├── control                  # 包元数据
└── WXTool.plist             # 进程过滤器
```

## 构建

### 本地构建

```bash
# rootless（默认）
make clean package

# roothide
make clean package SCHEME=roothide

# 指定 Theos 路径
make clean package THEOS=/path/to/theos
```

### CI 自动构建

推送代码到 GitHub 后，Actions 会自动构建并生成 `.deb` 包：

1. 推送代码到 `main` 或 `master` 分支
2. 进入 GitHub Repo → Actions → 查看构建进度
3. 构建完成后，进入对应 Workflow → Summary → 下载 Artifacts

### 发布 Release

打 Release 时，CI 会自动将 `.deb` 包上传到 Release Assets：

```bash
git tag v1.1.0
git push origin v1.1.0
```

然后在 GitHub 页面将 tag 发布为 Release 即可。

## 功能开关

编辑 [Makefile](Makefile)，注释或取消注释对应的 `-DENABLE_XXX` 标志来控制功能开启：

```makefile
WXTool_CFLAGS = -fobjc-arc \
                -mllvm -enable-allobf \
                -DVERSION_STRING=\"$(PACKAGE_VERSION)\" \
                -DENABLE_MEDIA_STACK \
                -DENABLE_ANTI_RECALL
```

## 作者

施主见谅