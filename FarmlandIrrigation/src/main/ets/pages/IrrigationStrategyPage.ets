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

interface Schedule {
  enabled: boolean; // 是否启用定时灌溉
  times: string[]; // 定时时间点 ['06:00', '18:00']
}

interface GeneratedTypeLiteralInterface_1 {
  min: number;
  max: number;
}

interface Conditions {
  weatherCheck: boolean; // 是否检查天气
  temperatureRange: GeneratedTypeLiteralInterface_1; // 温度范围
  avoidRainyDays: boolean; // 避开雨天
}

interface IrrigationStrategy {
  id: string; // 策略ID
  name: string; // 策略名称
  fieldAreaId: string; // 关联农田区域ID
  fieldAreaName: string; // 农田区域名称
  thresholds: IrrigationThresholds;
  irrigationSettings: IrrigationSettings;
  schedule: Schedule;
  conditions: Conditions;
  isActive: boolean; // 策略是否激活
  createdTime: number; // 创建时间
  lastModified: number; // 最后修改时间
}

// 农田区域信息
interface FieldArea {
  id: string;
  name: string;
  size: number; // 面积(亩)
  cropType: string; // 作物类型
}

// 选择器选项接口
interface SelectOption {
  value: string;
  text: string;
}

interface GeneratedTypeLiteralInterface_2 {
  name: string;
  fieldAreaId: string;
  minMoisture: number;
  maxMoisture: number;
  duration: number;
  flowRate: number;
  interval: number;
  scheduleEnabled: boolean;
  scheduleTimes: string[];
  weatherCheck: boolean;
  tempMin: number;
  tempMax: number;
  avoidRainyDays: boolean;
}

@Entry
@Component
export default struct IrrigationStrategyPage {
  @State strategies: IrrigationStrategy[] = [];
  @State fieldAreas: FieldArea[] = [];
  @State showAddDialog: boolean = false;
  @State editingStrategy: IrrigationStrategy | null = null;
  @State isLoading: boolean = false;

  // 新增/编辑表单数据
  @State formData: GeneratedTypeLiteralInterface_2 = {
    name: '',
    fieldAreaId: '',
    minMoisture: 30,
    maxMoisture: 70,
    duration: 15,
    flowRate: 10,
    interval: 12,
    scheduleEnabled: false,
    scheduleTimes: ['06:00', '18:00'],
    weatherCheck: true,
    tempMin: 15,
    tempMax: 35,
    avoidRainyDays: true
  };

  aboutToAppear() {
    this.loadFieldAreas();
    this.loadStrategies();
  }

  // 【数据请求点】加载农田区域信息
  async loadFieldAreas(): Promise<void> {
    try {
      // 【数据请求点】此处应连接农田区域API
      // 请求参数：{ farmerId: '农户ID' }
      // 预期返回格式：{
      //   success: boolean,
      //   data: FieldArea[] // 农田区域列表
      // }

      // 模拟数据
      this.fieldAreas = [
        { id: 'field001', name: '东区稻田', size: 5.2, cropType: '水稻' },
        { id: 'field002', name: '西区麦田', size: 3.8, cropType: '小麦' },
        { id: 'field003', name: '南区菜地', size: 2.1, cropType: '蔬菜' },
        { id: 'field004', name: '北区玉米地', size: 4.5, cropType: '玉米' }
      ];

    } catch (error) {
      console.error('加载农田区域失败:', error);
    }
  }

  // 【数据请求点】加载灌溉策略
  async loadStrategies(): Promise<void> {
    this.isLoading = true;

    try {
      // 【数据请求点】此处应连接灌溉策略API
      // 请求参数：{ farmerId: '农户ID' }
      // 预期返回格式：{
      //   success: boolean,
      //   data: IrrigationStrategy[] // 策略列表
      // }

      // 模拟数据
      this.strategies = this.generateMockStrategies();

    } catch (error) {
      console.error('加载灌溉策略失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // 生成模拟策略数据
  private generateMockStrategies(): IrrigationStrategy[] {
    const now = Date.now();

    return [
      {
        id: 'strategy001',
        name: '水稻标准灌溉',
        fieldAreaId: 'field001',
        fieldAreaName: '东区稻田',
        thresholds: { minMoisture: 40, maxMoisture: 80 },
        irrigationSettings: { duration: 20, flowRate: 12, interval: 8 },
        schedule: { enabled: true, times: ['06:00', '18:00'] },
        conditions: {
          weatherCheck: true,
          temperatureRange: { min: 18, max: 32 },
          avoidRainyDays: true
        },
        isActive: true,
        createdTime: now - 7 * 24 * 60 * 60 * 1000,
        lastModified: now - 1 * 24 * 60 * 60 * 1000
      },
      {
        id: 'strategy002',
        name: '小麦节水灌溉',
        fieldAreaId: 'field002',
        fieldAreaName: '西区麦田',
        thresholds: { minMoisture: 35, maxMoisture: 65 },
        irrigationSettings: { duration: 15, flowRate: 8, interval: 12 },
        schedule: { enabled: false, times: [] },
        conditions: {
          weatherCheck: true,
          temperatureRange: { min: 15, max: 30 },
          avoidRainyDays: true
        },
        isActive: false,
        createdTime: now - 14 * 24 * 60 * 60 * 1000,
        lastModified: now - 3 * 24 * 60 * 60 * 1000
      }
    ];
  }

  // 【数据存储点】保存灌溉策略
  async saveStrategy(): Promise<void> {
    if (!this.validateForm()) return;

    try {
      const fieldArea = this.fieldAreas.find((area: FieldArea) => area.id === this.formData.fieldAreaId);

      const strategyData: IrrigationStrategy = {
        id: this.editingStrategy?.id || `strategy_${Date.now()}`,
        name: this.formData.name,
        fieldAreaId: this.formData.fieldAreaId,
        fieldAreaName: fieldArea?.name || '',
        thresholds: {
          minMoisture: this.formData.minMoisture,
          maxMoisture: this.formData.maxMoisture
        },
        irrigationSettings: {
          duration: this.formData.duration,
          flowRate: this.formData.flowRate,
          interval: this.formData.interval
        },
        schedule: {
          enabled: this.formData.scheduleEnabled,
          times: [...this.formData.scheduleTimes]
        },
        conditions: {
          weatherCheck: this.formData.weatherCheck,
          temperatureRange: { min: this.formData.tempMin, max: this.formData.tempMax },
          avoidRainyDays: this.formData.avoidRainyDays
        },
        isActive: true,
        createdTime: this.editingStrategy?.createdTime || Date.now(),
        lastModified: Date.now()
      };

      // 【数据存储点】此处应连接灌溉策略数据库
      // 存储格式说明：
      // - strategy_id: 策略唯一标识 (主键)
      // - strategy_name: 策略名称
      // - field_area_id: 关联农田区域ID (外键)
      // - min_moisture_threshold: 最低土壤湿度阈值 (百分比)
      // - max_moisture_threshold: 最高土壤湿度阈值 (百分比)
      // - irrigation_duration: 单次灌溉时长 (分钟)
      // - flow_rate: 灌溉流量 (升/分钟)
      // - irrigation_interval: 灌溉间隔 (小时)
      // - schedule_enabled: 是否启用定时灌溉 (布尔值)
      // - schedule_times: 定时时间点 (JSON格式: ["06:00","18:00"])
      // - weather_check_enabled: 是否启用天气检查 (布尔值)
      // - temperature_min: 最低温度限制 (摄氏度)
      // - temperature_max: 最高温度限制 (摄氏度)
      // - avoid_rainy_days: 是否避开雨天 (布尔值)
      // - is_active: 策略激活状态 (布尔值)
      // - created_time: 创建时间戳
      // - last_modified: 最后修改时间戳
      // - farmer_id: 农户ID (外键)
      // 建议存储方式：关系型数据库(MySQL/PostgreSQL)
      // 表结构: irrigation_strategies + field_areas (关联表)

      if (this.editingStrategy) {
        const index = this.strategies.findIndex((s: IrrigationStrategy) => s.id === this.editingStrategy!.id);
        if (index !== -1) {
          this.strategies[index] = strategyData;
        }
      } else {
        this.strategies.push(strategyData);
      }

      this.closeDialog();
      console.log('灌溉策略保存成功');

    } catch (error) {
      console.error('保存灌溉策略失败:', error);
    }
  }

  // 表单验证
  private validateForm(): boolean {
    if (!this.formData.name || !this.formData.fieldAreaId) {
      console.log('请填写策略名称和选择农田区域');
      return false;
    }

    if (this.formData.minMoisture >= this.formData.maxMoisture) {
      console.log('最低湿度阈值必须小于最高湿度阈值');
      return false;
    }

    if (this.formData.duration <= 0 || this.formData.flowRate <= 0) {
      console.log('灌溉时长和流量必须大于0');
      return false;
    }

    return true;
  }

  // 【数据存储点】切换策略激活状态
  private async toggleStrategyStatus(strategyId: string): Promise<void> {
    try {
      // 【数据存储点】此处应调用策略状态更新API
      // 更新参数：{
      //   strategyId: strategyId,
      //   isActive: !currentStatus,
      //   lastModified: Date.now()
      // }

      const index = this.strategies.findIndex((s: IrrigationStrategy) => s.id === strategyId);
      if (index !== -1) {
        this.strategies[index].isActive = !this.strategies[index].isActive;
        this.strategies[index].lastModified = Date.now();
      }

    } catch (error) {
      console.error('切换策略状态失败:', error);
    }
  }

  // 删除策略
  private async deleteStrategy(strategyId: string): Promise<void> {
    try {
      // 【数据存储点】此处应调用删除API
      this.strategies = this.strategies.filter((s: IrrigationStrategy) => s.id !== strategyId);
      console.log('策略删除成功');

    } catch (error) {
      console.error('删除策略失败:', error);
    }
  }

  // 打开添加对话框
  private openAddDialog(): void {
    this.editingStrategy = null;
    this.resetForm();
    this.showAddDialog = true;
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
      interval: strategy.irrigationSettings.interval,
      scheduleEnabled: strategy.schedule.enabled,
      scheduleTimes: [...strategy.schedule.times],
      weatherCheck: strategy.conditions.weatherCheck,
      tempMin: strategy.conditions.temperatureRange.min,
      tempMax: strategy.conditions.temperatureRange.max,
      avoidRainyDays: strategy.conditions.avoidRainyDays
    };
    this.showAddDialog = true;
  }

  // 重置表单
  private resetForm(): void {
    this.formData = {
      name: '',
      fieldAreaId: '',
      minMoisture: 30,
      maxMoisture: 70,
      duration: 15,
      flowRate: 10,
      interval: 12,
      scheduleEnabled: false,
      scheduleTimes: ['06:00', '18:00'],
      weatherCheck: true,
      tempMin: 15,
      tempMax: 35,
      avoidRainyDays: true
    };
  }

  // 关闭对话框
  private closeDialog(): void {
    this.showAddDialog = false;
    this.editingStrategy = null;
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Button('返回')
          .onClick(() => router.back())
          .backgroundColor('#4CAF50')
          .fontColor(Color.White)
          .margin({ right: 16 })

        Text('灌溉策略配置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)

        Button('新建策略')
          .onClick(() => this.openAddDialog())
          .backgroundColor('#2196F3')
          .fontColor(Color.White)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')

      // 策略列表
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
          Text('加载中...')
            .margin({ top: 16 })
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else {
        Scroll() {
          Column() {
            ForEach(this.strategies, (strategy: IrrigationStrategy) => {
              Column() {
                // 策略标题行
                Row() {
                  Column() {
                    Text(strategy.name)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                    Text(`农田: ${strategy.fieldAreaName}`)
                      .fontSize(14)
                      .fontColor('#666')
                      .margin({ top: 2 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .flexGrow(1)

                  Toggle({ type: ToggleType.Switch, isOn: strategy.isActive })
                    .onChange((isOn: boolean) => {
                      this.toggleStrategyStatus(strategy.id);
                    })
                }
                .width('100%')
                .margin({ bottom: 12 })

                // 策略配置信息
                Column() {
                  // 湿度阈值
                  Row() {
                    Text('湿度阈值:')
                      .fontSize(14)
                      .fontColor('#333')
                      .width(80)
                    Text(`${strategy.thresholds.minMoisture}% - ${strategy.thresholds.maxMoisture}%`)
                      .fontSize(14)
                      .fontColor('#666')
                  }
                  .margin({ bottom: 6 })

                  // 灌溉参数
                  Row() {
                    Text('灌溉设置:')
                      .fontSize(14)
                      .fontColor('#333')
                      .width(80)
                    Text(`${strategy.irrigationSettings.duration}分钟 / ${strategy.irrigationSettings.flowRate}L/min`)
                      .fontSize(14)
                      .fontColor('#666')
                  }
                  .margin({ bottom: 6 })

                  // 灌溉间隔
                  Row() {
                    Text('灌溉间隔:')
                      .fontSize(14)
                      .fontColor('#333')
                      .width(80)
                    Text(`${strategy.irrigationSettings.interval}小时`)
                      .fontSize(14)
                      .fontColor('#666')
                  }
                  .margin({ bottom: 6 })

                  // 定时设置
                  if (strategy.schedule.enabled) {
                    Row() {
                      Text('定时灌溉:')
                        .fontSize(14)
                        .fontColor('#333')
                        .width(80)
                      Text(strategy.schedule.times.join(', '))
                        .fontSize(14)
                        .fontColor('#666')
                    }
                    .margin({ bottom: 6 })
                  }

                  // 天气条件
                  if (strategy.conditions.weatherCheck) {
                    Row() {
                      Text('温度范围:')
                        .fontSize(14)
                        .fontColor('#333')
                        .width(80)
                      Text(`${strategy.conditions.temperatureRange.min}°C - ${strategy.conditions.temperatureRange.max}°C`)
                        .fontSize(14)
                        .fontColor('#666')
                    }
                    .margin({ bottom: 6 })
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ bottom: 12 })

                // 操作按钮
                Row() {
                  Button('编辑')
                    .onClick(() => this.openEditDialog(strategy))
                    .backgroundColor('#FF9800')
                    .fontColor(Color.White)
                    .fontSize(12)
                    .margin({ right: 8 })

                  Button('删除')
                    .onClick(() => this.deleteStrategy(strategy.id))
                    .backgroundColor('#F44336')
                    .fontColor(Color.White)
                    .fontSize(12)
                    .margin({ right: 8 })

                  Text(`最后修改: ${new Date(strategy.lastModified).toLocaleDateString()}`)
                    .fontSize(12)
                    .fontColor('#999')
                    .flexGrow(1)
                    .textAlign(TextAlign.End)
                }
                .width('100%')
              }
              .width('100%')
              .padding(16)
              .backgroundColor(strategy.isActive ? Color.White : '#F5F5F5')
              .borderRadius(8)
              .margin({ bottom: 12 })
              .border({
                width: strategy.isActive ? 2 : 1,
                color: strategy.isActive ? '#4CAF50' : '#E0E0E0'
              })
            })
          }
          .padding(16)
        }
        .layoutWeight(1)
      }

      // 添加/编辑对话框
      if (this.showAddDialog) {
        Column() {
          Column() {
            Text(this.editingStrategy ? '编辑策略' : '新建策略')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            Scroll() {
              Column() {
                // 基本信息
                Column() {
                  Text('基本信息')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 8 })
                    .alignSelf(ItemAlign.Start)

                  TextInput({ text: this.formData.name, placeholder: '请输入策略名称' })
                    .onChange((value: string) => {
                      this.formData.name = value;
                    })
                    .margin({ bottom: 12 })

                  // 使用简化的 Select 组件语法
                  Text('选择农田区域:')
                    .fontSize(14)
                    .margin({ bottom: 4 })
                    .alignSelf(ItemAlign.Start)
                  
                  Column() {
                    ForEach(this.fieldAreas, (area: FieldArea) => {
                      Row() {
                        Radio({ value: area.id, group: 'fieldAreaGroup' })
                          .checked(this.formData.fieldAreaId === area.id)
                          .onChange((isChecked: boolean) => {
                            if (isChecked) {
                              this.formData.fieldAreaId = area.id;
                            }
                          })
                        Text(`${area.name} (${area.size}亩, ${area.cropType})`)
                          .fontSize(14)
                          .margin({ left: 8 })
                          .flexGrow(1)
                      }
                      .width('100%')
                      .height(32)
                      .justifyContent(FlexAlign.Start)
                    })
                  }
                  .margin({ bottom: 16 })
                }
                .alignItems(HorizontalAlign.Start)

                // 湿度阈值设置
                Column() {
                  Text('湿度阈值设置')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 8 })
                    .alignSelf(ItemAlign.Start)

                  Row() {
                    Text('最低湿度: ')
                      .width(80)
                    Slider({
                      value: this.formData.minMoisture,
                      min: 0,
                      max: 100,
                      style: SliderStyle.OutSet
                    })
                      .onChange((value: number) => {
                        this.formData.minMoisture = Math.round(value);
                      })
                      .flexGrow(1)
                    Text(`${this.formData.minMoisture}%`)
                      .width(50)
                      .textAlign(TextAlign.End)
                  }
                  .margin({ bottom: 8 })

                  Row() {
                    Text('最高湿度: ')
                      .width(80)
                    Slider({
                      value: this.formData.maxMoisture,
                      min: 0,
                      max: 100,
                      style: SliderStyle.OutSet
                    })
                      .onChange((value: number) => {
                        this.formData.maxMoisture = Math.round(value);
                      })
                      .flexGrow(1)
                    Text(`${this.formData.maxMoisture}%`)
                      .width(50)
                      .textAlign(TextAlign.End)
                  }
                  .margin({ bottom: 16 })
                }
                .alignItems(HorizontalAlign.Start)

                // 灌溉参数设置
                Column() {
                  Text('灌溉参数设置')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 8 })
                    .alignSelf(ItemAlign.Start)

                  Row() {
                    Text('灌溉时长: ')
                      .width(80)
                    Slider({
                      value: this.formData.duration,
                      min: 5,
                      max: 60,
                      style: SliderStyle.OutSet
                    })
                      .onChange((value: number) => {
                        this.formData.duration = Math.round(value);
                      })
                      .flexGrow(1)
                    Text(`${this.formData.duration}分钟`)
                      .width(60)
                      .textAlign(TextAlign.End)
                  }
                  .margin({ bottom: 8 })

                  Row() {
                    Text('流量: ')
                      .width(80)
                    Slider({
                      value: this.formData.flowRate,
                      min: 1,
                      max: 30,
                      style: SliderStyle.OutSet
                    })
                      .onChange((value: number) => {
                        this.formData.flowRate = Math.round(value);
                      })
                      .flexGrow(1)
                    Text(`${this.formData.flowRate}L/min`)
                      .width(60)
                      .textAlign(TextAlign.End)
                  }
                  .margin({ bottom: 8 })

                  Row() {
                    Text('灌溉间隔: ')
                      .width(80)
                    Slider({
                      value: this.formData.interval,
                      min: 1,
                      max: 48,
                      style: SliderStyle.OutSet
                    })
                      .onChange((value: number) => {
                        this.formData.interval = Math.round(value);
                      })
                      .flexGrow(1)
                    Text(`${this.formData.interval}小时`)
                      .width(60)
                      .textAlign(TextAlign.End)
                  }
                  .margin({ bottom: 16 })
                }
                .alignItems(HorizontalAlign.Start)

                // 定时设置
                Column() {
                  Row() {
                    Text('定时灌溉')
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                    Toggle({ type: ToggleType.Switch, isOn: this.formData.scheduleEnabled })
                      .onChange((isOn: boolean) => {
                        this.formData.scheduleEnabled = isOn;
                      })
                      .margin({ left: 16 })
                  }
                  .margin({ bottom: 8 })

                  if (this.formData.scheduleEnabled) {
                    Text('定时时间点 (可添加多个)')
                      .fontSize(14)
                      .fontColor('#666')
                      .margin({ bottom: 8 })
                      .alignSelf(ItemAlign.Start)

                    ForEach(this.formData.scheduleTimes, (time: string, index?: number) => {
                      Row() {
                        TextInput({ text: time, placeholder: 'HH:MM' })
                          .onChange((value: string) => {
                            if (index !== undefined) {
                              this.formData.scheduleTimes[index] = value;
                            }
                          })
                          .flexGrow(1)

                        Button('删除')
                          .onClick(() => {
                            if (index !== undefined) {
                              this.formData.scheduleTimes.splice(index, 1);
                            }
                          })
                          .backgroundColor('#F44336')
                          .fontColor(Color.White)
                          .fontSize(12)
                          .margin({ left: 8 })
                      }
                      .margin({ bottom: 8 })
                    })

                    Button('添加时间点')
                      .onClick(() => {
                        this.formData.scheduleTimes.push('06:00');
                      })
                      .backgroundColor('#4CAF50')
                      .fontColor(Color.White)
                      .fontSize(12)
                      .margin({ bottom: 16 })
                  }
                }
                .alignItems(HorizontalAlign.Start)

                // 天气条件设置
                Column() {
                  Row() {
                    Text('天气检查')
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                    Toggle({ type: ToggleType.Switch, isOn: this.formData.weatherCheck })
                      .onChange((isOn: boolean) => {
                        this.formData.weatherCheck = isOn;
                      })
                      .margin({ left: 16 })
                  }
                  .margin({ bottom: 8 })

                  if (this.formData.weatherCheck) {
                    Row() {
                      Text('最低温度: ')
                        .width(80)
                      Slider({
                        value: this.formData.tempMin,
                        min: -10,
                        max: 50,
                        style: SliderStyle.OutSet
                      })
                        .onChange((value: number) => {
                          this.formData.tempMin = Math.round(value);
                        })
                        .flexGrow(1)
                      Text(`${this.formData.tempMin}°C`)
                        .width(50)
                        .textAlign(TextAlign.End)
                    }
                    .margin({ bottom: 8 })

                    Row() {
                      Text('最高温度: ')
                        .width(80)
                      Slider({
                        value: this.formData.tempMax,
                        min: -10,
                        max: 50,
                        style: SliderStyle.OutSet
                      })
                        .onChange((value: number) => {
                          this.formData.tempMax = Math.round(value);
                        })
                        .flexGrow(1)
                      Text(`${this.formData.tempMax}°C`)
                        .width(50)
                        .textAlign(TextAlign.End)
                    }
                    .margin({ bottom: 8 })

                    Row() {
                      Text('避开雨天')
                        .fontSize(14)
                      Toggle({ type: ToggleType.Switch, isOn: this.formData.avoidRainyDays })
                        .onChange((isOn: boolean) => {
                          this.formData.avoidRainyDays = isOn;
                        })
                        .margin({ left: 16 })
                    }
                    .margin({ bottom: 16 })
                  }
                }
                .alignItems(HorizontalAlign.Start)
              }
            }
            .layoutWeight(1)

            // 按钮组
            Row() {
              Button('取消')
                .onClick(() => this.closeDialog())
                .backgroundColor('#E0E0E0')
                .fontColor(Color.Black)
                .flexGrow(1)
                .margin({ right: 8 })

              Button('保存')
                .onClick(() => this.saveStrategy())
                .backgroundColor('#4CAF50')
                .fontColor(Color.White)
                .flexGrow(1)
            }
            .width('100%')
            .margin({ top: 16 })
          }
          .width('90%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(12)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .justifyContent(FlexAlign.Center)
        .position({ x: 0, y: 0 })
        .zIndex(999)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F0F0F0')
  }
}