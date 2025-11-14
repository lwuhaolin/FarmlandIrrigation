import { router } from '@kit.ArkUI';

// 灌溉策略数据模型
interface IrrigationThresholds {
  minMoisture: number; // 最低土壤湿度阈值(%)
  maxMoisture: number; // 最高土壤湿度阈值(%)
}

interface IrrigationSettings {
  duration: number; // 单次灌溉时长(分钟)
  flowRate: number; // 流量(升/分钟)
  interval: number; // 灌溉间隔(小时)
}

interface IrrigationStrategy {
  id: string;
  name: string;
  fieldAreaId: string;
  fieldAreaName: string;
  thresholds: IrrigationThresholds;
  irrigationSettings: IrrigationSettings;
  isActive: boolean;
  createdTime: number;
  lastModified: number;
}

interface FieldArea {
  id: string;
  name: string;
  size: number;
  cropType: string;
}

interface GeneratedTypeLiteralInterface_1 {
  name: string;
  fieldAreaId: string;
  minMoisture: number;
  maxMoisture: number;
  duration: number;
  flowRate: number;
  interval: number;
}

@Component
export default struct IrrigationStrategyPage {
  @State strategies: IrrigationStrategy[] = [];
  @State fieldAreas: FieldArea[] = [];
  @State showAddDialog: boolean = false;
  @State editingStrategy: IrrigationStrategy | null = null;
  @State isLoading: boolean = false;
  // 父组件传递的返回回调
  onNavigateBack?: () => void;
  @State formData: GeneratedTypeLiteralInterface_1 = {
    name: '',
    fieldAreaId: '',
    minMoisture: 30,
    maxMoisture: 80,
    duration: 15,
    flowRate: 10,
    interval: 6
  };

  aboutToAppear() {
    this.loadData();
  }

  private async loadData() {
    this.isLoading = true;
    try {
      // 模拟数据加载
      await new Promise<void>(resolve => setTimeout(resolve, 1000));

      this.fieldAreas = [
        {
          id: '1',
          name: '东区田块A1',
          size: 10.5,
          cropType: '水稻'
        },
        {
          id: '2',
          name: '西区田块B2',
          size: 8.2,
          cropType: '玉米'
        },
        {
          id: '3',
          name: '南区田块C3',
          size: 15.0,
          cropType: '小麦'
        }
      ];

      this.strategies = [
        {
          id: '1',
          name: '水稻精准灌溉策略',
          fieldAreaId: '1',
          fieldAreaName: '东区田块A1',
          thresholds: { minMoisture: 30, maxMoisture: 80 },
          irrigationSettings: { duration: 20, flowRate: 12, interval: 8 },
          isActive: true,
          createdTime: Date.now() - 86400000,
          lastModified: Date.now() - 3600000
        }
      ];
    } catch (error) {
      console.error('加载数据失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  private openAddDialog() {
    this.editingStrategy = null;
    this.formData = {
      name: '',
      fieldAreaId: '',
      minMoisture: 30,
      maxMoisture: 80,
      duration: 15,
      flowRate: 10,
      interval: 6
    };
    this.showAddDialog = true;
  }

  private closeDialog() {
    this.showAddDialog = false;
    this.editingStrategy = null;
  }

  private async saveStrategy() {
    if (!this.formData.name || !this.formData.fieldAreaId) {
      return;
    }

    const fieldArea = this.fieldAreas.find(area => area.id === this.formData.fieldAreaId);
    if (!fieldArea) {
      return;
    }

    const strategy: IrrigationStrategy = {
      id: this.editingStrategy?.id || Date.now().toString(),
      name: this.formData.name,
      fieldAreaId: this.formData.fieldAreaId,
      fieldAreaName: fieldArea.name,
      thresholds: {
        minMoisture: this.formData.minMoisture,
        maxMoisture: this.formData.maxMoisture
      },
      irrigationSettings: {
        duration: this.formData.duration,
        flowRate: this.formData.flowRate,
        interval: this.formData.interval
      },
      isActive: this.editingStrategy?.isActive || false,
      createdTime: this.editingStrategy?.createdTime || Date.now(),
      lastModified: Date.now()
    };

    if (this.editingStrategy) {
      const index = this.strategies.findIndex(s => s.id === this.editingStrategy!.id);
      if (index !== -1) {
        this.strategies[index] = strategy;
      }
    } else {
      this.strategies.push(strategy);
    }

    this.closeDialog();
  }

  // 切换策略激活状态
  private toggleStrategyActive(strategy: IrrigationStrategy): void {
    const index = this.strategies.findIndex(s => s.id === strategy.id);
    if (index !== -1) {
      this.strategies[index].isActive = !this.strategies[index].isActive;
      this.strategies[index].lastModified = Date.now();
      console.log(`策略 "${strategy.name}" 已${this.strategies[index].isActive ? '启动' : '停止'}`);
    }
  }

  // 打开编辑对话框
  private openEditDialog(strategy: IrrigationStrategy): void {
    this.editingStrategy = strategy;
    this.formData = {
      name: strategy.name,
      fieldAreaId: strategy.fieldAreaId,
      minMoisture: strategy.thresholds.minMoisture,
      maxMoisture: strategy.thresholds.maxMoisture,
      duration: strategy.irrigationSettings.duration,
      flowRate: strategy.irrigationSettings.flowRate,
      interval: strategy.irrigationSettings.interval
    };
    this.showAddDialog = true;
  }

  // 删除策略
  private deleteStrategy(strategyId: string): void {
    const index = this.strategies.findIndex(s => s.id === strategyId);
    if (index !== -1) {
      const strategyName = this.strategies[index].name;
      this.strategies.splice(index, 1);
      console.log(`策略 "${strategyName}" 已删除`);
    }
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Button('返回')
          .onClick(() => {
            if (this.onNavigateBack) {
              this.onNavigateBack();
            } else {
              router.back();
            }
          })
          .backgroundColor('#52C41A')
          .fontColor('#FFFFFF')
          .borderRadius(8)
          .margin({ right: 16 })

        Text('灌溉策略配置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2329')
          .layoutWeight(1)

        Button('+ 新建策略')
          .onClick(() => this.openAddDialog())
          .backgroundColor('#1890FF')
          .fontColor('#FFFFFF')
          .borderRadius(8)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .shadow({
        radius: 8,
        color: '#00000010',
        offsetX: 0,
        offsetY: 2
      })

      // 策略列表
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
            .color('#1890FF')
          Text('加载中...')
            .fontSize(14)
            .fontColor('#8A8A8A')
            .margin({ top: 16 })
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else {
        Scroll() {
          Column({ space: 12 }) {
            ForEach(this.strategies, (strategy: IrrigationStrategy) => {
              this.StrategyCard(strategy)
            })

            if (this.strategies.length === 0) {
              this.EmptyState()
            }
          }
          .padding(16)
        }
        .layoutWeight(1)
      }

      // 美化的弹窗
      if (this.showAddDialog) {
        this.ModernDialog()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  StrategyCard(strategy: IrrigationStrategy) {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 4 }) {
          Text(strategy.name)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2329')

          Text(strategy.fieldAreaName)
            .fontSize(14)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Text(strategy.isActive ? '运行中' : '已停止')
          .fontSize(12)
          .fontColor(strategy.isActive ? '#52C41A' : '#8A8A8A')
          .backgroundColor(strategy.isActive ? '#F6FFED' : '#F5F5F5')
          .padding({
            left: 8,
            right: 8,
            top: 4,
            bottom: 4
          })
          .borderRadius(12)
      }

      Row({ space: 16 }) {
        Text(`湿度: ${strategy.thresholds.minMoisture}-${strategy.thresholds.maxMoisture}%`)
          .fontSize(12)
          .fontColor('#666666')

        Text(`时长: ${strategy.irrigationSettings.duration}分钟`)
          .fontSize(12)
          .fontColor('#666666')

        Text(`流量: ${strategy.irrigationSettings.flowRate}L/min`)
          .fontSize(12)
          .fontColor('#666666')
      }

      Row({ space: 8 }) {
        Button(strategy.isActive ? '停止' : '启动')
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor(strategy.isActive ? '#FF4D4F' : '#52C41A')
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            // 【功能点】切换灌溉策略的激活状态
            this.toggleStrategyActive(strategy);
          })

        Button('编辑')
          .fontSize(12)
          .fontColor('#1890FF')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#1890FF' })
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            // 【功能点】编辑灌溉策略
            this.openEditDialog(strategy);
          })

        Button('删除')
          .fontSize(12)
          .fontColor('#FF4D4F')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#FF4D4F' })
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            // 【功能点】删除灌溉策略
            this.deleteStrategy(strategy.id);
          })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: '#00000010',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  EmptyState() {
    Column({ space: 16 }) {
      Text('🚰')
        .fontSize(48)

      Text('暂无灌溉策略')
        .fontSize(16)
        .fontColor('#8A8A8A')

      Text('点击"新建策略"创建您的第一个灌溉策略')
        .fontSize(14)
        .fontColor('#999999')
        .textAlign(TextAlign.Center)

      Button('创建策略')
        .fontColor('#FFFFFF')
        .backgroundColor('#1890FF')
        .borderRadius(8)
        .onClick(() => this.openAddDialog())
    }
    .width('100%')
    .height(300)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
  }

  @Builder
  ModernDialog() {
    Column() {
      Column() {
        // 标题栏
        Row() {
          Text(this.editingStrategy ? '🚰 编辑灌溉策略' : '🚰 新建灌溉策略')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2329')
            .layoutWeight(1)

          Button() {
            Text('✕')
              .fontSize(16)
              .fontColor('#8A8A8A')
          }
          .backgroundColor('transparent')
          .width(32)
          .height(32)
          .onClick(() => this.closeDialog())
        }
        .margin({ bottom: 24 })

        Scroll() {
          Column({ space: 20 }) {
            // 基本信息
            Column({ space: 16 }) {
              Text('📋 基本信息')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2329')
                .alignSelf(ItemAlign.Start)

              Column({ space: 12 }) {
                Text('策略名称')
                  .fontSize(14)
                  .fontColor('#666666')
                  .alignSelf(ItemAlign.Start)

                TextInput({ text: this.formData.name, placeholder: '请输入策略名称' })
                  .onChange((value: string) => {
                    this.formData.name = value;
                  })
                  .borderRadius(8)
                  .backgroundColor('#FFFFFF')
                  .border({ width: 1, color: '#D9D9D9' })
                  .padding(12)

                Text('选择农田区域')
                  .fontSize(14)
                  .fontColor('#666666')
                  .alignSelf(ItemAlign.Start)

                Column({ space: 8 }) {
                  ForEach(this.fieldAreas, (area: FieldArea) => {
                    Row() {
                      Radio({ value: area.id, group: 'fieldAreaGroup' })
                        .checked(this.formData.fieldAreaId === area.id)
                        .onChange((isChecked: boolean) => {
                          if (isChecked) {
                            this.formData.fieldAreaId = area.id;
                          }
                        })

                      Column({ space: 2 }) {
                        Text(area.name)
                          .fontSize(14)
                          .fontColor('#1F2329')
                          .fontWeight(FontWeight.Medium)

                        Text(`${area.size}亩 · ${area.cropType}`)
                          .fontSize(12)
                          .fontColor('#8A8A8A')
                      }
                      .alignItems(HorizontalAlign.Start)
                      .margin({ left: 12 })
                      .layoutWeight(1)
                    }
                    .width('100%')
                    .padding(12)
                    .backgroundColor(this.formData.fieldAreaId === area.id ? '#E6F7FF' : '#FFFFFF')
                    .borderRadius(8)
                    .border({
                      width: 1,
                      color: this.formData.fieldAreaId === area.id ? '#1890FF' : '#E5E5E5'
                    })
                  })
                }
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(12)
              .border({ width: 1, color: '#E5E5E5' })
            }

            // 湿度阈值
            Column({ space: 16 }) {
              Text('💧 湿度阈值设置')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2329')
                .alignSelf(ItemAlign.Start)

              Column({ space: 16 }) {
                Column({ space: 8 }) {
                  Text(`最低湿度 (${this.formData.minMoisture}%)`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)

                  Slider({
                    value: this.formData.minMoisture,
                    min: 0,
                    max: 100,
                    style: SliderStyle.OutSet
                  })
                  .onChange((value: number) => {
                    this.formData.minMoisture = Math.round(value);
                  })
                  .trackColor('#E5E5E5')
                  .selectedColor('#1890FF')
                  .blockColor('#1890FF')
                  .trackThickness(6)
                }

                Column({ space: 8 }) {
                  Text(`最高湿度 (${this.formData.maxMoisture}%)`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)

                  Slider({
                    value: this.formData.maxMoisture,
                    min: 0,
                    max: 100,
                    style: SliderStyle.OutSet
                  })
                  .onChange((value: number) => {
                    this.formData.maxMoisture = Math.round(value);
                  })
                  .trackColor('#E5E5E5')
                  .selectedColor('#1890FF')
                  .blockColor('#1890FF')
                  .trackThickness(6)
                }
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(12)
              .border({ width: 1, color: '#E5E5E5' })
            }

            // 灌溉参数
            Column({ space: 16 }) {
              Text('⚙️ 灌溉参数')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2329')
                .alignSelf(ItemAlign.Start)

              Column({ space: 16 }) {
                Column({ space: 8 }) {
                  Text(`灌溉时长 (${this.formData.duration}分钟)`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)

                  Slider({
                    value: this.formData.duration,
                    min: 1,
                    max: 60,
                    style: SliderStyle.OutSet
                  })
                  .onChange((value: number) => {
                    this.formData.duration = Math.round(value);
                  })
                  .trackColor('#E5E5E5')
                  .selectedColor('#52C41A')
                  .blockColor('#52C41A')
                  .trackThickness(6)
                }

                Column({ space: 8 }) {
                  Text(`流量设置 (${this.formData.flowRate}L/min)`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)

                  Slider({
                    value: this.formData.flowRate,
                    min: 1,
                    max: 50,
                    style: SliderStyle.OutSet
                  })
                  .onChange((value: number) => {
                    this.formData.flowRate = Math.round(value);
                  })
                  .trackColor('#E5E5E5')
                  .selectedColor('#52C41A')
                  .blockColor('#52C41A')
                  .trackThickness(6)
                }

                Column({ space: 8 }) {
                  Text(`灌溉间隔 (${this.formData.interval}小时)`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .alignSelf(ItemAlign.Start)

                  Slider({
                    value: this.formData.interval,
                    min: 1,
                    max: 24,
                    style: SliderStyle.OutSet
                  })
                  .onChange((value: number) => {
                    this.formData.interval = Math.round(value);
                  })
                  .trackColor('#E5E5E5')
                  .selectedColor('#52C41A')
                  .blockColor('#52C41A')
                  .trackThickness(6)
                }
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(12)
              .border({ width: 1, color: '#E5E5E5' })
            }
          }
        }
        .layoutWeight(1)
        .margin({ bottom: 20 })

        // 底部按钮
        Row({ space: 12 }) {
          Button('取消')
            .onClick(() => this.closeDialog())
            .backgroundColor('#F5F5F5')
            .fontColor('#666666')
            .borderRadius(8)
            .layoutWeight(1)
            .height(48)

          Button(this.editingStrategy ? '保存修改' : '保存策略')
            .onClick(() => this.saveStrategy())
            .backgroundColor('#1890FF')
            .fontColor('#FFFFFF')
            .borderRadius(8)
            .layoutWeight(2)
            .height(48)
            .shadow({
              radius: 8,
              color: '#1890FF40',
              offsetX: 0,
              offsetY: 2
            })
        }
      }
      .width('90%')
      .height('85%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({
        radius: 24,
        color: '#00000020',
        offsetX: 0,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.6)')
    .justifyContent(FlexAlign.Center)
    .position({ x: 0, y: 0 })
    .zIndex(999)
  }

}