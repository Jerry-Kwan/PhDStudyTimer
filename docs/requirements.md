# PhD Study Timer - Requirements Document

## 项目概述 (Project Overview)

PhD Study Timer 是一款为研究生和学者设计的 macOS 应用程序，旨在帮助用户追踪和记录他们的工作时间。该应用程序将作为 menu bar 应用运行，提供简单直观的界面来开始、暂停和结束工作会话，并查看历史工作记录。

## 功能需求 (Functional Requirements)

### 1. 工作会话管理 (Work Session Management)

#### 1.1 开始新工作会话
- 用户可以通过点击 menu bar 图标并选择相应选项来开始新的工作会话
- 开始会话时记录开始时间（日期和时间）
- 开始会话后，menu bar 图标将显示工作图标和当前会话持续时间

#### 1.2 暂停/恢复工作会话
- 用户可以手动暂停当前工作会话
- 当电脑锁屏时，工作会话将自动暂停
- 电脑解锁后，用户可以手动恢复工作会话
- 系统需记录每次暂停和恢复的时间点
- 暂停期间，计时器停止，但会话不会结束

#### 1.3 结束工作会话
- 用户可以手动结束当前工作会话
- 结束会话时记录结束时间
- 结束后，会话数据被保存到历史记录中
- 结束会话后，menu bar 图标将显示睡觉图标和"12H"文本

### 2. 历史记录功能 (History Tracking)

#### 2.1 会话数据记录
- 每个工作会话需记录以下数据：
  - 开始时间（日期和时间）
  - 结束时间（日期和时间）
  - 总工作时长
  - 暂停/恢复时间点列表
  - 实际工作时长（总时长减去暂停时间）

#### 2.2 历史记录查看
- 用户可以查看所有历史工作会话
- 提供按日期筛选功能
- 显示每个会话的详细信息
- 提供每日、每周、每月工作时间统计

### 3. 用户界面 (User Interface)

#### 3.1 Menu Bar 图标
- 双部分图标：左侧为状态图标，右侧为时间显示
- 工作状态：显示工作图标和当前会话持续时间（格式：HH:MM:SS）
- 非工作状态：显示睡觉图标和"12H"文本
- 点击图标显示下拉菜单，提供主要功能入口

#### 3.2 历史记录界面
- 美观的列表/表格视图显示历史会话
- 提供筛选和排序选项
- 详细视图显示单个会话的完整信息
- 图表展示工作时间趋势

### 4. 系统集成 (System Integration)

#### 4.1 锁屏检测
- 检测系统锁屏事件并自动暂停计时

#### 4.2 数据持久化
- 本地存储所有会话数据

## 非功能需求 (Non-functional Requirements)

### 1. 性能 (Performance)
- 应用启动时间不超过 2 秒
- 低 CPU 和内存占用，不影响其他应用性能
- 计时精度至少达到秒级

### 2. 用户体验 (User Experience)
- 符合 macOS 设计语言和交互模式
- 简洁直观的用户界面
- 响应迅速的交互体验

### 3. 安全性 (Security)
- 所有数据仅本地存储，不上传到云端
- 不收集用户个人信息

## 技术栈 (Technology Stack)

### 1. 开发环境
- Xcode 15+
- Swift 5.9+
- SwiftUI 框架
- AppKit 框架（用于 menu bar 功能）

### 2. 架构模式
- MVVM (Model-View-ViewModel) 架构
- 使用 Combine 框架进行响应式编程

### 3. 数据存储
- CoreData 用于本地数据持久化
- UserDefaults 用于应用设置

### 4. 系统集成
- NSWorkspace 用于检测系统状态
- NSNotificationCenter 用于系统事件监听

## 项目结构 (Project Structure)

### 1. 目录结构
```
PhDStudyTimer/
├── App/
│   ├── PhDStudyTimerApp.swift       # 应用入口
│   └── AppDelegate.swift            # 应用代理，处理系统事件
├── Models/
│   ├── WorkSession.swift            # 工作会话数据模型
│   ├── PauseRecord.swift            # 暂停记录数据模型
│   └── CoreDataManager.swift        # CoreData 管理器
├── Views/
│   ├── MenuBarView/
│   │   ├── MenuBarView.swift        # Menu Bar 视图
│   │   └── MenuBarViewModel.swift   # Menu Bar 视图模型
│   └── HistoryView/
│       ├── HistoryView.swift        # 历史记录视图
│       ├── HistoryViewModel.swift   # 历史记录视图模型
│       └── SessionDetailView.swift  # 会话详情视图
├── Services/
│   ├── TimerService.swift           # 计时器服务
│   ├── SessionManager.swift         # 会话管理服务
│   └── SystemMonitor.swift          # 系统状态监控服务
├── Utils/
│   ├── TimeFormatter.swift          # 时间格式化工具
│   └── Constants.swift              # 常量定义
├── Resources/
│   └── Assets.xcassets              # 资源文件
└── CoreData/
    └── PhDStudyTimer.xcdatamodeld   # CoreData 模型
```

### 2. 核心组件

#### 2.1 数据模型
- **WorkSession**: 工作会话模型，包含开始时间、结束时间、总时长等信息
- **PauseRecord**: 暂停记录模型，包含暂停时间和恢复时间

#### 2.2 服务层
- **TimerService**: 提供计时功能，包括开始、暂停、恢复和结束计时
- **SessionManager**: 管理工作会话，包括创建、更新和查询会话
- **SystemMonitor**: 监控系统状态，如锁屏和解锁事件

#### 2.3 视图层
- **MenuBarView**: Menu Bar 图标和下拉菜单
- **HistoryView**: 历史记录界面，显示过去的工作会话

## 开发计划 (Development Plan)

### 阶段一：基础架构
1. 搭建项目基础架构
2. 实现 CoreData 数据模型
3. 实现基本的 Menu Bar 功能
4. 实现计时器服务

### 阶段二：核心功能
1. 实现工作会话管理功能
2. 实现系统状态监控
3. 实现暂停/恢复功能
4. 完善 Menu Bar 界面

### 阶段三：历史记录功能
1. 实现历史记录查询功能
2. 实现历史记录界面
3. 实现统计功能
