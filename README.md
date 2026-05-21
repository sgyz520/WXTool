# WXTool - 微信增强插件

[![Build](https://github.com/sgyz520/WXTool/actions/workflows/build.yml/badge.svg)](https://github.com/sgyz520/WXTool/actions/workflows/build.yml)

WeChat enhancement tweak for iOS.

## 功能

| 功能 | 说明 | 状态 |
|------|------|------|
| 图片堆叠 | 强制开启微信图片堆叠发送与显示 | ✅ |
| 消息防撤回 | 阻止对方撤回消息，保留聊天记录 | ✅ |
| 设置入口 | 在微信设置中显示 WXTool 配置页面 | ✅ |

## 使用说明

安装后，在 **微信 → 设置** 页面底部可以找到 **WXTool** 入口。

在设置页面可以：
- 单独开关每个功能
- 查看插件版本信息
- 加入 QQ 交流群

## 版本兼容

- 微信 8.0.62+
- iOS 14.0+ (arm64 / arm64e)

## 项目结构

```
WXTool/
├── Tweak.x                  # 主入口点（Hook 逻辑）
├── EntryController.x        # 设置界面控制器
├── WCMediaStack.h           # 公共头文件（日志、常量、版本标记）
├── Resources/
│   ├── entry.plist          # 设置入口配置
│   ├── Root.plist           # 设置界面布局
│   └── icon.png             # 插件图标
├── .github/workflows/
│   └── build.yml            # GitHub Actions 自动打包
├── Makefile                 # Theos 构建配置
├── control                  # 包元数据
└── WXTool.plist             # 进程过滤器
```

## 构建

### 本地构建

```bash
# 默认构建
make clean package

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