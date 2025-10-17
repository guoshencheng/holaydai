# holaydai

本仓库包含一个使用 SwiftUI 编写的 macOS 应用 **DaysCountdown**，可以帮助你计算距离某个事件（“XXXX”）还有多少天或已经过去多少天。

## 功能特性
- 自定义事件名称，快速替换默认的 “XXXX” 描述。
- 通过图形化 `DatePicker` 选择目标日期。
- 支持是否将今天计入倒计时，满足不同的倒计时习惯。
- 根据目标日期自动展示“还有多少天”或“已经过去多少天”的中文提示。
- 实时刷新，确保倒计时每天自动更新。

## 如何运行
1. 使用 Xcode 15 或更高版本打开 [`DaysCountdown/DaysCountdown.xcodeproj`](DaysCountdown/DaysCountdown.xcodeproj)。
2. 在工具栏将 Scheme 设置为 **DaysCountdown**，平台选择 **My Mac**。
3. 点击运行（`Cmd + R`）即可启动应用。

## 项目结构
```
DaysCountdown/
├── DaysCountdown.xcodeproj        # Xcode 工程文件
└── DaysCountdown/
    ├── Assets.xcassets            # 应用资源（包含 AppIcon）
    ├── ContentView.swift          # 主界面和倒计时逻辑
    ├── DaysCountdownApp.swift     # 应用入口
    ├── Info.plist                 # 应用配置
    └── Preview Content/           # SwiftUI 预览资源
```

## 自定义
- 在应用界面中直接修改事件名称。
- 如果希望默认目标日期不同，可以在 `ContentView.swift` 中调整 `targetDate` 的初始值。
- 如需更换 App 图标，可替换 `Assets.xcassets/AppIcon.appiconset` 下的图像。

## 使用 GitHub Actions 打包
仓库已经配置 [`macOS build`](.github/workflows/macos-build.yml) 工作流，用于在 GitHub Actions 的 macOS 运行器上构建 Release 版本：
1. 确保仓库的 Actions 功能已启用，将代码推送到 `main` 分支或创建 Pull Request 时会自动触发构建。
2. 工作流会使用 Xcode 15 构建项目，并在成功后于构件列表中上传 `DaysCountdown.zip` 压缩包。
3. 在 GitHub 的 Actions 页面选择对应的运行记录，点击 **Artifacts** 中的 `DaysCountdown-macOS` 即可下载未签名的 `.app` 包，按需进一步签名或打包发布。
