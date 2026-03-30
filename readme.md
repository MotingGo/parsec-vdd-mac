# parsec-vdd-mac

Mac 虚拟屏幕创建工具，配合 Sunshine + Moonlight 实现局域网串流。

## 功能

- 使用 macOS CGVirtualDisplay 私有 API 创建虚拟屏幕
- 系统自动识别为物理显示器，可被 Sunshine 捕获串流
- 支持自定义分辨率和刷新率

## 使用方法

```bash
# 默认 1920x1080 60fps
./parsec-vdd

# 自定义参数
./parsec-vdd --width 2560 --height 1440 --fps 60
```

## 串流步骤

1. 运行 `parsec-vdd`，记下输出的 Display ID
2. 启动 Sunshine，配置捕获对应的 Display ID
3. Windows 端打开 Moonlight，连接 Mac
4. 完成后 Ctrl+C 停止虚拟屏

## 构建

```bash
swift build -c release
```

## 要求

- macOS 12+ (Monterey)
- Apple Silicon (M1/M2/M3/M4)
