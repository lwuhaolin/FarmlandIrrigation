@Component
export default struct RealtimeDashboard {
  @State soilHumidity: number = 45.5; // 土壤湿度
  @State temperature: number = 24.8; // 环境温度
  @State airHumidity: number = 68.2; // 空气湿度
  @State lightIntensity: number = 32500; // 光照强度(lux)
  @State deviceStatus: string = '正常'; // 设备状态
  @State lastUpdateTime: string = '2024-03-15 14:30:25'; // 最后更新时间

  // 定时器用于模拟实时数据更新
  private timer: number = -1;

  aboutToAppear() {
    this.startDataUpdate();
  }

  aboutToDisappear() {
    if (this.timer !== -1) {
      clearInterval(this.timer);
    }
  }

  // 【数据请求点】获取实时传感器数据
  // 说明：此处应连接南向设备接口或云端API
  // 请求格式：GET /api/realtime-data?fieldId={农田ID}
  // 返回格式：{soilHumidity:float, temperature:float, airHumidity:float, lightIntensity:int, deviceStatus:string, timestamp:long}
  // 建议存储方式：定时向时序数据库写入实时数据，便于历史查询
  private async fetchRealtimeData(): Promise<void> {
    try {
      // 模拟数据获取（实际应替换为HTTP请求）
      this.soilHumidity = 40 + Math.random() * 40; // 40-80%
      this.temperature = 20 + Math.random() * 15; // 20-35°C
      this.airHumidity = 50 + Math.random() * 40; // 50-90%
      this.lightIntensity = Math.random() * 80000; // 0-80000 lux
      this.lastUpdateTime = new Date().toLocaleString();
      
      // 【数据存储点】保存实时数据到本地缓存
      // 建议存储格式：timestamp + sensorData JSON对象
      console.log('【数据存储点】保存实时数据：', {
        timestamp: Date.now(),
        soilHumidity: this.soilHumidity,
        temperature: this.temperature,
        airHumidity: this.airHumidity,
        lightIntensity: this.lightIntensity
      });
    } catch (error) {
      console.error('获取实时数据失败:', error);
    }
  }

  private startDataUpdate(): void {
    // 每30秒更新一次数据
    this.timer = setInterval(() => {
      this.fetchRealtimeData();
    }, 30000);
    
    // 立即获取一次数据
    this.fetchRealtimeData();
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        // 页面标题和更新时间
        Row() {
          Column() {
            Text('实时数据监控')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2329')
            
            Text(`最后更新：${this.lastUpdateTime}`)
              .fontSize(12)
              .fontColor('#8A8A8A')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          // 设备状态指示器
          Row({ space: 8 }) {
            Circle({ width: 8, height: 8 })
              .fill(this.deviceStatus === '正常' ? '#52C41A' : '#FF4D4F')
            
            Text(this.deviceStatus)
              .fontSize(14)
              .fontColor(this.deviceStatus === '正常' ? '#52C41A' : '#FF4D4F')
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16 })


        // 主要指标卡片区域
        Grid() {
          GridItem() {
            this.DataCard('土壤湿度', `${this.soilHumidity.toFixed(1)}%`, '#1890FF')
          }
          GridItem() {
            this.DataCard('环境温度', `${this.temperature.toFixed(1)}°C`, '#FF6B35')
          }
          GridItem() {
            this.DataCard('空气湿度', `${this.airHumidity.toFixed(1)}%`, '#52C41A')
          }
          GridItem() {
            this.DataCard('光照强度', `${Math.round(this.lightIntensity)} lux`, '#FAAD14')
          }
        }
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(12)
        .height(280)
        .padding({ left: 16, right: 16 })

        // 详细数据列表
        Column({ space: 12 }) {
          Text('详细数据')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1F2329')
            .alignSelf(ItemAlign.Start)

          this.DetailItem('土壤湿度', `${this.soilHumidity.toFixed(2)}%`, this.getHumidityStatus())
          this.DetailItem('环境温度', `${this.temperature.toFixed(2)}°C`, this.getTemperatureStatus())
          this.DetailItem('空气湿度', `${this.airHumidity.toFixed(2)}%`, '正常')
          this.DetailItem('光照强度', `${Math.round(this.lightIntensity)} lux`, this.getLightStatus())
        }
        .padding({ left: 16, right: 16 })
        .alignItems(HorizontalAlign.Start)

        // 操作按钮区域
        Row({ space: 16 }) {
          Button('手动刷新')
            .layoutWeight(1)
            .backgroundColor('#1890FF')
            .onClick(() => {
              this.fetchRealtimeData();
            })

          Button('灌溉控制')
            .layoutWeight(1)
            .backgroundColor('#52C41A')
            .onClick(() => {
              // 跳转到灌溉设置页面
              console.log('跳转到灌溉控制');
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  DataCard(title: string, value: string, color: string) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontColor('#8A8A8A')
        .margin({ bottom: 8 })

      Text(value)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .justifyContent(FlexAlign.Center)
    .shadow({
      radius: 8,
      color: '#00000010',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  DetailItem(label: string, value: string, status: string) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor('#1F2329')
        .layoutWeight(1)

      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1F2329')
        .margin({ right: 12 })

      Text(status)
        .fontSize(14)
        .fontColor(status === '正常' ? '#52C41A' : 
                  status === '偏低' || status === '偏高' ? '#FAAD14' : '#FF4D4F')
        .padding({ top: 8, bottom: 8, left: 4, right: 4 })
        .backgroundColor(status === '正常' ? '#F6FFED' : 
                        status === '偏低' || status === '偏高' ? '#FFFBE6' : '#FFF2F0')
        .borderRadius(4)
    }
    .width('100%')
    .height(48)
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .shadow({
      radius: 4,
      color: '#00000008',
      offsetX: 0,
      offsetY: 1
    })
  }

  // 获取湿度状态
  private getHumidityStatus(): string {
    if (this.soilHumidity < 30) return '偏低';
    if (this.soilHumidity > 70) return '偏高';
    return '正常';
  }

  // 获取温度状态
  private getTemperatureStatus(): string {
    if (this.temperature < 15 || this.temperature > 35) return '异常';
    if (this.temperature < 18 || this.temperature > 30) return '偏离';
    return '正常';
  }

  // 获取光照状态
  private getLightStatus(): string {
    if (this.lightIntensity < 10000) return '偏低';
    if (this.lightIntensity > 60000) return '偏高';
    return '正常';
  }
}