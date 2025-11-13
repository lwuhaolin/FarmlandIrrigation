// 成本统计模块页面
// 【数据存储点】需要读取历史灌溉记录，包含：灌溉时间、时长、设备功率、水流量等
// 【数据请求点】需要获取电费单价、水费单价等计费标准数据

// 成本统计数据接口
interface CostRecord {
  id: string;
  date: string;
  irrigationDuration: number; // 灌溉时长（分钟）
  devicePower: number; // 设备功率（瓦特）
  waterFlow: number; // 水流量（升）
  electricityCost: number; // 电费（元）
  waterCost: number; // 水费（元）
  totalCost: number; // 总成本（元）
  areaId: string; // 关联农田区域ID
  cropType: string; // 作物类型
}

// 设备功耗配置接口
interface DeviceConfig {
  id: string;
  name: string;
  type: 'pump' | 'valve' | 'sensor' | 'controller';
  power: number; // 功率（瓦特）
  waterFlowRate: number; // 出水量（升/分钟）
  enabled: boolean;
}

// 计费标准配置接口
interface BillingConfig {
  electricityRate: number; // 电费单价（元/千瓦时）
  waterRate: number; // 水费单价（元/升）
  peakElectricityRate: number; // 峰期电费单价
  offPeakElectricityRate: number; // 谷期电费单价
  peakHours: string[]; // 峰期时间段
  offPeakHours: string[]; // 谷期时间段
}

// 统计汇总数据接口
interface CostSummary {
  period: string; // 统计周期
  totalElectricityCost: number;
  totalWaterCost: number;
  totalCost: number;
  totalIrrigationTime: number;
  totalWaterUsage: number;
  avgDailyCost: number;
  costPerHectare: number;
}

@Entry
@Component
export default struct CostStatistics {
  @State currentPeriod: string = 'month'; // week, month, season, year
  @State costRecords: CostRecord[] = [];
  @State deviceConfigs: DeviceConfig[] = [
    {
      id: '1',
      name: '主灌溉泵',
      type: 'pump',
      power: 1500,
      waterFlowRate: 200,
      enabled: true
    },
    {
      id: '2', 
      name: '辅助灌溉泵',
      type: 'pump',
      power: 800,
      waterFlowRate: 120,
      enabled: true
    },
    {
      id: '3',
      name: '电磁阀组',
      type: 'valve',
      power: 50,
      waterFlowRate: 0,
      enabled: true
    },
    {
      id: '4',
      name: '控制器',
      type: 'controller',
      power: 30,
      waterFlowRate: 0,
      enabled: true
    }
  ];
  
  @State billingConfig: BillingConfig = {
    electricityRate: 0.65, // 0.65元/千瓦时
    waterRate: 0.003, // 0.003元/升
    peakElectricityRate: 0.95,
    offPeakElectricityRate: 0.35,
    peakHours: ['08:00-12:00', '18:00-22:00'],
    offPeakHours: ['23:00-07:00']
  };

  @State costSummary: CostSummary = {
    period: '本月',
    totalElectricityCost: 0,
    totalWaterCost: 0,
    totalCost: 0,
    totalIrrigationTime: 0,
    totalWaterUsage: 0,
    avgDailyCost: 0,
    costPerHectare: 0
  };

  @State farmlandArea: number = 2.5; // 农田面积（公顷）

  aboutToAppear() {
    this.loadDeviceConfigs();
    this.loadBillingConfig();
    this.loadCostRecords();
    this.calculateSummary();
  }

  // 【数据存储点】加载设备配置信息
  // 此处应连接数据库读取设备配置数据
  // 建议存储格式：device_configs表 (id, name, type, power, water_flow_rate, enabled)
  loadDeviceConfigs() {
    console.info('加载设备配置 - 此处应从数据库读取设备功耗配置');
  }

  // 【数据存储点】加载计费标准配置
  // 此处应连接数据库读取计费配置或从外部API获取实时电费、水费单价
  // 建议存储格式：billing_config表 (electricity_rate, water_rate, peak_rate, off_peak_rate, peak_hours, off_peak_hours)
  loadBillingConfig() {
    console.info('加载计费配置 - 此处应从配置数据库或外部API获取电费水费单价');
  }

  // 【数据存储点】加载历史灌溉成本记录
  // 此处应连接数据库读取历史灌溉记录，计算对应的成本数据
  // 依赖的记录字段：灌溉时间、时长、设备功率、水流量、关联农田区域、作物类型
  // 建议存储格式：cost_records表 (id, date, irrigation_duration, device_power, water_flow, electricity_cost, water_cost, total_cost, area_id, crop_type)
  loadCostRecords() {
    console.info('加载成本记录 - 此处应从数据库读取历史灌溉记录并计算成本数据');
    
    // 模拟历史成本记录数据
    const now = new Date();
    this.costRecords = [];
    
    for (let i = 0; i < 30; i++) {
      const date = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
      const duration = Math.floor(Math.random() * 120) + 30; // 30-150分钟
      const power = 1500 + Math.random() * 500; // 1500-2000瓦特
      const waterFlow = duration * 200; // 200升/分钟
      
      // 计算电费（考虑峰谷电价）
      const hour = Math.floor(Math.random() * 24);
      const isPeakHour = (hour >= 8 && hour < 12) || (hour >= 18 && hour < 22);
      const electricityRate = isPeakHour ? this.billingConfig.peakElectricityRate : 
                             (hour >= 23 || hour < 7) ? this.billingConfig.offPeakElectricityRate : 
                             this.billingConfig.electricityRate;
      
      const electricityCost = (power / 1000) * (duration / 60) * electricityRate;
      const waterCost = waterFlow * this.billingConfig.waterRate;
      
      this.costRecords.push({
        id: (i + 1).toString(),
        date: date.toISOString().split('T')[0],
        irrigationDuration: duration,
        devicePower: power,
        waterFlow: waterFlow,
        electricityCost: electricityCost,
        waterCost: waterCost,
        totalCost: electricityCost + waterCost,
        areaId: 'area_1',
        cropType: '水稻'
      });
    }
  }

  // 计算成本汇总
  calculateSummary() {
    const now = new Date();
    let filteredRecords: CostRecord[] = [];

    switch (this.currentPeriod) {
      case 'week':
        const weekStart = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        filteredRecords = this.costRecords.filter(record => 
          new Date(record.date) >= weekStart);
        this.costSummary.period = '本周';
        break;
      case 'month':
        const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
        filteredRecords = this.costRecords.filter(record => 
          new Date(record.date) >= monthStart);
        this.costSummary.period = '本月';
        break;
      case 'season':
        const seasonStart = new Date(now.getTime() - 90 * 24 * 60 * 60 * 1000);
        filteredRecords = this.costRecords.filter(record => 
          new Date(record.date) >= seasonStart);
        this.costSummary.period = '本季度';
        break;
      case 'year':
        const yearStart = new Date(now.getFullYear(), 0, 1);
        filteredRecords = this.costRecords.filter(record => 
          new Date(record.date) >= yearStart);
        this.costSummary.period = '本年';
        break;
    }

    // 计算汇总数据
    const totalElectricityCost = filteredRecords.reduce((sum, record) => sum + record.electricityCost, 0);
    const totalWaterCost = filteredRecords.reduce((sum, record) => sum + record.waterCost, 0);
    const totalIrrigationTime = filteredRecords.reduce((sum, record) => sum + record.irrigationDuration, 0);
    const totalWaterUsage = filteredRecords.reduce((sum, record) => sum + record.waterFlow, 0);
    
    this.costSummary = {
      period: this.costSummary.period,
      totalElectricityCost: totalElectricityCost,
      totalWaterCost: totalWaterCost,
      totalCost: totalElectricityCost + totalWaterCost,
      totalIrrigationTime: totalIrrigationTime,
      totalWaterUsage: totalWaterUsage,
      avgDailyCost: filteredRecords.length > 0 ? (totalElectricityCost + totalWaterCost) / filteredRecords.length : 0,
      costPerHectare: this.farmlandArea > 0 ? (totalElectricityCost + totalWaterCost) / this.farmlandArea : 0
    };
  }

  // 【数据存储点】保存设备配置
  // 此处应将设备配置更新保存到数据库
  saveDeviceConfig(config: DeviceConfig) {
    console.info(`保存设备配置 - 此处应将设备配置更新到数据库: ${JSON.stringify(config)}`);
    
    const index = this.deviceConfigs.findIndex(item => item.id === config.id);
    if (index >= 0) {
      // 修复：不使用展开运算符，直接逐个赋值
      this.deviceConfigs[index].name = config.name;
      this.deviceConfigs[index].type = config.type;
      this.deviceConfigs[index].power = config.power;
      this.deviceConfigs[index].waterFlowRate = config.waterFlowRate;
      this.deviceConfigs[index].enabled = config.enabled;
    }
  }

  // 【数据存储点】保存计费配置  
  // 此处应将计费配置保存到数据库
  saveBillingConfig() {
    console.info(`保存计费配置 - 此处应将计费配置保存到数据库: ${JSON.stringify(this.billingConfig)}`);
  }

  // 导出成本报告
  exportCostReport() {
    console.info('导出成本报告 - 此处应生成CSV或Excel文件并保存到本地');
    // 可以调用文件系统API生成报告文件
  }

  build() {
    Column({ space: 16 }) {
      // 标题栏
      Row() {
        Text('成本统计分析')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16 })

      Scroll() {
        Column({ space: 16 }) {
          // 统计周期选择
          Row() {
            Text('统计周期：')
              .fontSize(16)
              .fontColor('#666666')

            Radio({ value: 'week', group: 'period' })
              .checked(this.currentPeriod === 'week')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.currentPeriod = 'week';
                  this.calculateSummary();
                }
              })
            Text('周')
              .fontSize(14)
              .margin({ right: 16 })

            Radio({ value: 'month', group: 'period' })
              .checked(this.currentPeriod === 'month')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.currentPeriod = 'month';
                  this.calculateSummary();
                }
              })
            Text('月')
              .fontSize(14)
              .margin({ right: 16 })

            Radio({ value: 'season', group: 'period' })
              .checked(this.currentPeriod === 'season')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.currentPeriod = 'season';
                  this.calculateSummary();
                }
              })
            Text('季')
              .fontSize(14)
              .margin({ right: 16 })

            Radio({ value: 'year', group: 'period' })
              .checked(this.currentPeriod === 'year')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.currentPeriod = 'year';
                  this.calculateSummary();
                }
              })
            Text('年')
              .fontSize(14)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#F8F9FA')
          .borderRadius(8)
          .alignItems(VerticalAlign.Center)

          // 成本汇总卡片
          Column({ space: 12 }) {
            Text(`${this.costSummary.period}成本汇总`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')

            Grid() {
              GridItem() {
                this.SummaryCard('总成本', `¥${this.costSummary.totalCost.toFixed(2)}`, '#FF4D4F')
              }
              GridItem() {
                this.SummaryCard('电费', `¥${this.costSummary.totalElectricityCost.toFixed(2)}`, '#1890FF')
              }
              GridItem() {
                this.SummaryCard('水费', `¥${this.costSummary.totalWaterCost.toFixed(2)}`, '#52C41A')
              }
              GridItem() {
                this.SummaryCard('日均成本', `¥${this.costSummary.avgDailyCost.toFixed(2)}`, '#FA8C16')
              }
            }
            .columnsTemplate('1fr 1fr')
            .rowsTemplate('1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .height(160)

            Grid() {
              GridItem() {
                this.SummaryCard('灌溉时长', `${(this.costSummary.totalIrrigationTime / 60).toFixed(1)}小时`, '#722ED1')
              }
              GridItem() {
                this.SummaryCard('用水量', `${(this.costSummary.totalWaterUsage / 1000).toFixed(1)}吨`, '#13C2C2')
              }
              GridItem() {
                this.SummaryCard('单位成本', `¥${this.costSummary.costPerHectare.toFixed(2)}/公顷`, '#EB2F96')
              }
              GridItem() {
                this.SummaryCard('农田面积', `${this.farmlandArea}公顷`, '#666666')
              }
            }
            .columnsTemplate('1fr 1fr')
            .rowsTemplate('1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .height(160)
          }
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .shadow({ radius: 4, color: '#1F000000', offsetX: 0, offsetY: 2 })

          // 设备功耗配置
          Column({ space: 12 }) {
            Text('设备功耗配置')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')

            ForEach(this.deviceConfigs, (device: DeviceConfig) => {
              this.DeviceConfigCard(device)
            })
          }
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .shadow({ radius: 4, color: '#1F000000', offsetX: 0, offsetY: 2 })

          // 计费标准配置
          Column({ space: 12 }) {
            Text('计费标准配置')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')

            Row() {
              Text('电费单价：')
                .fontSize(14)
                .fontColor('#666666')
              
              TextInput({ text: this.billingConfig.electricityRate.toString() })
                .width(80)
                .height(32)
                .fontSize(12)
                .onChange((value: string) => {
                  this.billingConfig.electricityRate = parseFloat(value) || 0;
                  this.saveBillingConfig();
                })
              
              Text('元/千瓦时')
                .fontSize(12)
                .fontColor('#666666')
                .margin({ left: 4 })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            Row() {
              Text('水费单价：')
                .fontSize(14)
                .fontColor('#666666')
              
              TextInput({ text: this.billingConfig.waterRate.toString() })
                .width(80)
                .height(32)
                .fontSize(12)
                .onChange((value: string) => {
                  this.billingConfig.waterRate = parseFloat(value) || 0;
                  this.saveBillingConfig();
                })
              
              Text('元/升')
                .fontSize(12)
                .fontColor('#666666')
                .margin({ left: 4 })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            Row() {
              Text('峰期电价：')
                .fontSize(14)
                .fontColor('#666666')
              
              TextInput({ text: this.billingConfig.peakElectricityRate.toString() })
                .width(80)
                .height(32)
                .fontSize(12)
                .onChange((value: string) => {
                  this.billingConfig.peakElectricityRate = parseFloat(value) || 0;
                  this.saveBillingConfig();
                })
              
              Text('元/千瓦时')
                .fontSize(12)
                .fontColor('#666666')
                .margin({ left: 4 })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            Row() {
              Text('谷期电价：')
                .fontSize(14)
                .fontColor('#666666')
              
              TextInput({ text: this.billingConfig.offPeakElectricityRate.toString() })
                .width(80)
                .height(32)
                .fontSize(12)
                .onChange((value: string) => {
                  this.billingConfig.offPeakElectricityRate = parseFloat(value) || 0;
                  this.saveBillingConfig();
                })
              
              Text('元/千瓦时')
                .fontSize(12)
                .fontColor('#666666')
                .margin({ left: 4 })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .shadow({ radius: 4, color: '#1F000000', offsetX: 0, offsetY: 2 })

          // 详细记录列表
          Column({ space: 12 }) {
            Row() {
              Text('详细成本记录')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              
              Blank()
              
              Button('导出报告')
                .fontSize(12)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .backgroundColor('#007DFF')
                .borderRadius(4)
                .onClick(() => {
                  this.exportCostReport();
                })
            }
            .width('100%')

            Column({ space: 8 }) {
              // 表头
              Row() {
                Text('日期')
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('20%')
                Text('时长')
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('15%')
                Text('用水')
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('20%')
                Text('电费')
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('20%')
                Text('水费')
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('20%')
                Text('总计')
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('15%')
              }
              .width('100%')
              .padding({ left: 12, right: 12, top: 8, bottom: 8 })
              .backgroundColor('#F0F0F0')

              // 记录列表
              List() {
                ForEach(this.costRecords.slice(0, 10), (record: CostRecord) => {
                  ListItem() {
                    this.CostRecordRow(record)
                  }
                })
              }
              .height(300)
              .divider({ strokeWidth: 1, color: '#F0F0F0' })
            }
          }
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .shadow({ radius: 4, color: '#1F000000', offsetX: 0, offsetY: 2 })
        }
      }
      .layoutWeight(1)
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder SummaryCard(title: string, value: string, color: string) {
    Column({ space: 4 }) {
      Text(title)
        .fontSize(12)
        .fontColor('#666666')
      
      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F8F9FA')
    .borderRadius(6)
    .padding(8)
  }

  @Builder DeviceConfigCard(device: DeviceConfig) {
    Row() {
      Column({ space: 4 }) {
        Text(device.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
        
        Text(`功率: ${device.power}W${device.waterFlowRate > 0 ? ` | 流量: ${device.waterFlowRate}L/min` : ''}`)
          .fontSize(12)
          .fontColor('#666666')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Row({ space: 8 }) {
        TextInput({ text: device.power.toString() })
          .width(60)
          .height(28)
          .fontSize(12)
          .onChange((value: string) => {
            device.power = parseFloat(value) || 0;
            this.saveDeviceConfig(device);
          })
        
        Text('W')
          .fontSize(12)
          .fontColor('#666666')
        
        Toggle({ type: ToggleType.Switch, isOn: device.enabled })
          .selectedColor('#007DFF')
          .onChange((isOn: boolean) => {
            device.enabled = isOn;
            this.saveDeviceConfig(device);
          })
      }
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F8F9FA')
    .borderRadius(6)
    .alignItems(VerticalAlign.Center)
  }

  @Builder CostRecordRow(record: CostRecord) {
    Row() {
      Text(record.date)
        .fontSize(12)
        .fontColor('#333333')
        .width('20%')
      
      Text(`${Math.floor(record.irrigationDuration / 60)}h${record.irrigationDuration % 60}m`)
        .fontSize(12)
        .fontColor('#333333')
        .width('15%')
      
      Text(`${(record.waterFlow / 1000).toFixed(1)}吨`)
        .fontSize(12)
        .fontColor('#333333')
        .width('20%')
      
      Text(`¥${record.electricityCost.toFixed(2)}`)
        .fontSize(12)
        .fontColor('#1890FF')
        .width('20%')
      
      Text(`¥${record.waterCost.toFixed(2)}`)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('20%')
      
      Text(`¥${record.totalCost.toFixed(2)}`)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FF4D4F')
        .width('15%')
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
    .alignItems(VerticalAlign.Center)
  }
}