import { router } from '@kit.ArkUI';

// 历史数据模型
interface HistoryDataPoint {
  timestamp: number; // 时间戳
  soilMoisture: number; // 土壤湿度
  temperature: number; // 温度
  humidity: number; // 湿度
  lightIntensity: number; // 光照强度
}

// 图表数据点
interface ChartPoint {
  x: number; // x坐标
  y: number; // y坐标
  value: number; // 原始值
  time: string; // 时间标签
}

@Entry
@Component
export default struct HistoryDataPage {
  @State selectedTab: number = 0; // 当前选中的数据类型
  @State timeRange: string = 'week'; // 时间范围：day/week
  @State historyData: HistoryDataPoint[] = [];
  @State chartData: ChartPoint[] = [];
  @State isLoading: boolean = false;

  // 数据类型选项
  private dataTypes: string[] = ['土壤湿度', '环境温度', '环境湿度', '光照强度'];
  private dataKeys: string[] = ['soilMoisture', 'temperature', 'humidity', 'lightIntensity'];

  aboutToAppear() {
    this.loadHistoryData();
  }

  // 【数据请求点】加载历史数据
  async loadHistoryData() {
    this.isLoading = true;
    
    try {
      // 【数据请求点】此处应连接历史数据API
      // 请求参数：{
      //   timeRange: this.timeRange, // 'day' | 'week'
      //   startTime: 起始时间戳,
      //   endTime: 结束时间戳,
      //   dataType: 'all' // 获取所有类型数据
      // }
      // 预期返回格式：{
      //   success: boolean,
      //   data: HistoryDataPoint[] // 按时间排序的历史数据数组
      // }
      
      // 模拟数据 - 实际应替换为API调用
      const mockData = this.generateMockHistoryData();
      this.historyData = mockData;
      this.updateChartData();
      
    } catch (error) {
      console.error('加载历史数据失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // 生成模拟历史数据
  private generateMockHistoryData(): HistoryDataPoint[] {
    const data: HistoryDataPoint[] = [];
    const now = Date.now();
    const interval = this.timeRange === 'day' ? 60 * 60 * 1000 : 24 * 60 * 60 * 1000; // 小时或天
    const count = this.timeRange === 'day' ? 24 : 7;

    for (let i = count - 1; i >= 0; i--) {
      data.push({
        timestamp: now - i * interval,
        soilMoisture: 45 + Math.random() * 20,
        temperature: 22 + Math.random() * 8,
        humidity: 60 + Math.random() * 20,
        lightIntensity: 300 + Math.random() * 200
      });
    }
    return data;
  }

  // 更新图表数据
  private updateChartData() {
    if (this.historyData.length === 0) return;

    const dataKey = this.dataKeys[this.selectedTab] as keyof HistoryDataPoint;
    const chartWidth = 300;
    const chartHeight = 200;

    // 计算数值范围
    const values = this.historyData.map(item => {
      switch (dataKey) {
        case 'soilMoisture':
          return item.soilMoisture;
        case 'temperature':
          return item.temperature;
        case 'humidity':
          return item.humidity;
        case 'lightIntensity':
          return item.lightIntensity;
        default:
          return 0;
      }
    });
    const minValue = Math.min(...values);
    const maxValue = Math.max(...values);
    const valueRange = maxValue - minValue || 1;

    this.chartData = this.historyData.map((item, index) => {
      let value: number;
      switch (dataKey) {
        case 'soilMoisture':
          value = item.soilMoisture;
          break;
        case 'temperature':
          value = item.temperature;
          break;
        case 'humidity':
          value = item.humidity;
          break;
        case 'lightIntensity':
          value = item.lightIntensity;
          break;
        default:
          value = 0;
      }

      const x = (index / (this.historyData.length - 1)) * chartWidth;
      const normalizedValue = (value - minValue) / valueRange;
      const y = chartHeight - (normalizedValue * chartHeight);
      const chartPoint: ChartPoint = {
        x,
        y,
        value,
        time: this.formatTime(item.timestamp)
      };
      return chartPoint;
    });

  }

  // 格式化时间显示
  private formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    if (this.timeRange === 'day') {
      return `${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`;
    } else {
      return `${date.getMonth() + 1}/${date.getDate()}`;
    }
  }

  // 切换数据类型
  private switchDataType(index: number) {
    this.selectedTab = index;
    this.updateChartData();
  }

  // 切换时间范围
  private switchTimeRange(range: string) {
    if (this.timeRange !== range) {
      this.timeRange = range;
      this.loadHistoryData();
    }
  }

  // 导出数据功能
  private exportData() {
    // 【数据请求点】导出历史数据
    // 此处应调用导出API，将当前查询的历史数据导出为Excel或CSV格式
    // 导出参数：{
    //   data: this.historyData,
    //   format: 'excel' | 'csv',
    //   filename: `农田数据_${this.timeRange}_${new Date().toISOString()}`
    // }
    console.log('导出数据功能待实现');
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

        Text('历史数据分析')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)

        Button('导出')
          .onClick(() => this.exportData())
          .backgroundColor('#2196F3')
          .fontColor(Color.White)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      .backgroundColor('#F5F5F5')

      Scroll() {

        Column() {
          // 时间范围选择
          Row() {
            Text('时间范围：')
              .fontSize(16)
              .margin({ right: 16 })

            Button('按日')
              .onClick(() => this.switchTimeRange('day'))
              .backgroundColor(this.timeRange === 'day' ? '#4CAF50' : '#E0E0E0')
              .fontColor(this.timeRange === 'day' ? Color.White : Color.Black)
              .margin({ right: 8 })

            Button('按周')
              .onClick(() => this.switchTimeRange('week'))
              .backgroundColor(this.timeRange === 'week' ? '#4CAF50' : '#E0E0E0')
              .fontColor(this.timeRange === 'week' ? Color.White : Color.Black)
          }
          .width('100%')
          .padding(16)

          // 数据类型选择标签
          Row() {
            ForEach(this.dataTypes, (type: string, index: number) => {
              Button(type)
                .onClick(() => this.switchDataType(index))
                .backgroundColor(this.selectedTab === index ? '#4CAF50' : '#E0E0E0')
                .fontColor(this.selectedTab === index ? Color.White : Color.Black)
                .margin({ right: 8 })
                .fontSize(14)
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 16 })

          // 图表区域
          Column() {
            Text(`${this.dataTypes[this.selectedTab]}趋势图`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            if (this.isLoading) {
              LoadingProgress()
                .width(50)
                .height(50)
                .margin(32)
            } else {
              // 简化的折线图实现
              Stack() {
                // 背景网格
                Column() {
                  ForEach([0, 1, 2, 3, 4], (item: number) => {
                    Divider()
                      .strokeWidth(1)
                      .color('#E0E0E0')
                      .margin({ top: item === 0 ? 0 : 40 })
                  })
                }
                .width(300)
                .height(200)
                .alignItems(HorizontalAlign.Start)

                // 数据点和连线
                if (this.chartData.length > 0) {
                  Canvas(this.drawChart.bind(this))
                    .width(300)
                    .height(200)
                }
              }
              .width(300)
              .height(200)
              .backgroundColor('#FAFAFA')
              .border({ width: 1, color: '#E0E0E0' })

              // 数据统计信息
              Column() {
                Text('统计信息')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 8 })

                if (this.chartData.length > 0) {
                  Row() {
                    Column() {
                      Text('最大值')
                        .fontSize(12)
                        .fontColor('#666')
                      Text(`${Math.max(...this.chartData.map(p => p.value)).toFixed(1)}`)
                        .fontSize(16)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#4CAF50')
                    }
                    .margin({ right: 24 })

                    Column() {
                      Text('最小值')
                        .fontSize(12)
                        .fontColor('#666')
                      Text(`${Math.min(...this.chartData.map(p => p.value)).toFixed(1)}`)
                        .fontSize(16)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#FF5722')
                    }
                    .margin({ right: 24 })

                    Column() {
                      Text('平均值')
                        .fontSize(12)
                        .fontColor('#666')
                      Text(`${(this.chartData.reduce((sum, p) => sum + p.value, 0) / this.chartData.length).toFixed(1)}`)
                        .fontSize(16)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#2196F3')
                    }
                  }
                  .justifyContent(FlexAlign.SpaceAround)
                  .width('100%')
                }
              }
              .width('100%')
              .padding(16)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .margin({ top: 16 })
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .margin(16)

          // 详细数据列表
          Column() {
            Text('详细数据记录')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            List({ space: 8 }) {
              ForEach(this.historyData.slice().reverse(), (item: HistoryDataPoint, index: number) => {
                ListItem() {
                  Row() {
                    Column() {
                      Text(this.formatTime(item.timestamp))
                        .fontSize(14)
                        .fontWeight(FontWeight.Bold)
                      Text(new Date(item.timestamp).toLocaleDateString())
                        .fontSize(12)
                        .fontColor('#666')
                    }
                    .alignItems(HorizontalAlign.Start)
                    .width('25%')

                    Column() {
                      Text(`${item.soilMoisture.toFixed(1)}%`)
                        .fontSize(14)
                      Text('土壤湿度')
                        .fontSize(12)
                        .fontColor('#666')
                    }
                    .width('18%')

                    Column() {
                      Text(`${item.temperature.toFixed(1)}°C`)
                        .fontSize(14)
                      Text('温度')
                        .fontSize(12)
                        .fontColor('#666')
                    }
                    .width('18%')

                    Column() {
                      Text(`${item.humidity.toFixed(1)}%`)
                        .fontSize(14)
                      Text('湿度')
                        .fontSize(12)
                        .fontColor('#666')
                    }
                    .width('18%')

                    Column() {
                      Text(`${item.lightIntensity.toFixed(0)}`)
                        .fontSize(14)
                      Text('光照')
                        .fontSize(12)
                        .fontColor('#666')
                    }
                    .width('21%')
                  }
                  .width('100%')
                  .padding(12)
                  .backgroundColor(Color.White)
                  .borderRadius(8)
                }
              })
            }
            .width('100%')
            .height(300)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#F9F9F9')
          .borderRadius(8)
          .margin({ left: 16, right: 16, bottom: 16 })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F0F0F0')
  }

  // 绘制折线图
  private drawChart(context: CanvasRenderingContext2D) {
    if (this.chartData.length === 0) return;

    context.clearRect(0, 0, 300, 200);
    
    // 绘制折线
    context.beginPath();
    context.strokeStyle = '#4CAF50';
    context.lineWidth = 2;
    
    this.chartData.forEach((point, index) => {
      if (index === 0) {
        context.moveTo(point.x, point.y);
      } else {
        context.lineTo(point.x, point.y);
      }
    });
    
    context.stroke();
    
    // 绘制数据点
    context.fillStyle = '#4CAF50';
    this.chartData.forEach(point => {
      context.beginPath();
      context.arc(point.x, point.y, 4, 0, 2 * Math.PI);
      context.fill();
    });
  }
}