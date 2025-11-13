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
    const chartWidth = 280; // 设定固定宽度与Canvas对应
    const chartHeight = 180;
    const padding = 20;

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

    // 添加一些边距以避免点贴边
    const displayMin = minValue - valueRange * 0.1;
    const displayMax = maxValue + valueRange * 0.1;
    const displayRange = displayMax - displayMin;

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

      // 计算x位置（添加左边距）
      const x = padding + (index / Math.max(this.historyData.length - 1, 1)) * (chartWidth - 2 * padding);
      // 计算y位置（添加上下边距，y轴从上到下）
      const normalizedValue = (value - displayMin) / displayRange;
      const y = chartHeight - padding - (normalizedValue * (chartHeight - 2 * padding));

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
        Button('← 返回')
          .onClick(() => router.back())
          .backgroundColor('#4CAF50')
          .fontColor(Color.White)
          .borderRadius(20)
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .fontSize(14)
          .margin({ right: 16 })

        Text('历史数据分析')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)

        Button('📊 导出')
          .onClick(() => this.exportData())
          .backgroundColor('#2196F3')
          .fontColor(Color.White)
          .borderRadius(20)
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .fontSize(14)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 8, color: '#00000010', offsetY: 2 })

      Scroll() {

        Column() {
          // 时间范围选择
          Row() {
            Text('📅 时间范围')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ right: 16 })

            Button('📆 按日')
              .onClick(() => this.switchTimeRange('day'))
              .backgroundColor(this.timeRange === 'day' ? '#4CAF50' : '#F5F5F5')
              .fontColor(this.timeRange === 'day' ? Color.White : '#666666')
              .borderRadius(18)
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
              .fontSize(14)
              .margin({ right: 12 })
              .shadow(this.timeRange === 'day' ?
                { radius: 8, color: '#4CAF5030', offsetY: 2 } :
                { radius: 0, color: Color.Transparent, offsetY: 0 })

            Button('📊 按周')
              .onClick(() => this.switchTimeRange('week'))
              .backgroundColor(this.timeRange === 'week' ? '#4CAF50' : '#F5F5F5')
              .fontColor(this.timeRange === 'week' ? Color.White : '#666666')
              .borderRadius(18)
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
              .fontSize(14)
              .shadow(this.timeRange === 'week' ?
                { radius: 8, color: '#4CAF5030', offsetY: 2 } :
                { radius: 0, color: Color.Transparent, offsetY: 0 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .margin({ left: 16, right: 16, top: 16 })
          .shadow({ radius: 4, color: '#00000008', offsetY: 1 })

          // 数据类型选择标签
          Row() {
            ForEach(this.dataTypes, (type: string, index: number) => {
              Button(type)
                .onClick(() => this.switchDataType(index))
                .backgroundColor(this.selectedTab === index ? '#4CAF50' : '#F5F5F5')
                .fontColor(this.selectedTab === index ? Color.White : '#666666')
                .borderRadius(16)
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .fontSize(13)
                .margin({ right: 8 })
                .shadow(this.selectedTab === index ?
                  { radius: 6, color: '#4CAF5028', offsetY: 2 } :
                  { radius: 0, color: Color.Transparent, offsetY: 0 })
            })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .margin({ left: 16, right: 16, top: 12 })
          .shadow({ radius: 4, color: '#00000008', offsetY: 1 })

          // 图表区域
          Column() {
            Text(`📈 ${this.dataTypes[this.selectedTab]}趋势图`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 20 })

            if (this.isLoading) {
              LoadingProgress()
                .width(50)
                .height(50)
                .margin(32)
                .color('#4CAF50')
            } else {
              // 改进的折线图实现
              Stack() {
                // 背景网格
                Column() {
                  ForEach([0, 1, 2, 3, 4], (item: number) => {
                    Divider()
                      .strokeWidth(1)
                      .color('#E8E8E8')
                      .margin({ top: item === 0 ? 0 : 40 })
                  })
                }
                .width('90%')
                .height(200)
                .alignItems(HorizontalAlign.Start)

                // Canvas图表
                if (this.chartData.length > 0) {
                  Stack() {
                    Canvas(this.drawChart.bind(this))
                      .width('90%')
                      .height(200)
                      .backgroundColor(Color.Transparent)
                      .onReady(() => {
                        // Canvas准备就绪，触发绘制
                        console.log('Canvas ready')
                      })
                  }
                  .width('100%')
                  .height(200)
                }
              }
              .width('100%')
              .height(220)
              .padding(16)
              .backgroundColor('#FAFAFA')
              .borderRadius(12)
              .border({ width: 1, color: '#E8E8E8' })

              // 数据统计信息
              Column() {
                Text('📊 统计信息')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 16 })

                if (this.chartData.length > 0) {
                  Row() {
                    Column() {
                      Text('📈 最大值')
                        .fontSize(12)
                        .fontColor('#999')
                        .margin({ bottom: 4 })
                      Text(`${Math.max(...this.chartData.map(p => p.value)).toFixed(1)}`)
                        .fontSize(20)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#4CAF50')
                    }
                    .width('33%')
                    .padding(12)
                    .backgroundColor('#F0F9F0')
                    .borderRadius(12)
                    .alignItems(HorizontalAlign.Center)

                    Column() {
                      Text('📉 最小值')
                        .fontSize(12)
                        .fontColor('#999')
                        .margin({ bottom: 4 })
                      Text(`${Math.min(...this.chartData.map(p => p.value)).toFixed(1)}`)
                        .fontSize(20)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#FF5722')
                    }
                    .width('33%')
                    .padding(12)
                    .backgroundColor('#FFF3F0')
                    .borderRadius(12)
                    .alignItems(HorizontalAlign.Center)
                    .margin({ left: 8, right: 8 })

                    Column() {
                      Text('➗ 平均值')
                        .fontSize(12)
                        .fontColor('#999')
                        .margin({ bottom: 4 })
                      Text(`${(this.chartData.reduce((sum, p) => sum + p.value, 0) / this.chartData.length).toFixed(1)}`)
                        .fontSize(20)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#2196F3')
                    }
                    .width('33%')
                    .padding(12)
                    .backgroundColor('#F0F7FF')
                    .borderRadius(12)
                    .alignItems(HorizontalAlign.Center)
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width('100%')
                }
              }
              .width('100%')
              .padding(16)
              .backgroundColor(Color.White)
              .borderRadius(12)
              .margin({ top: 16 })
              .shadow({ radius: 4, color: '#00000008', offsetY: 1 })
            }
          }
          .width('100%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .margin(16)
          .shadow({ radius: 8, color: '#00000010', offsetY: 2 })

          // 详细数据列表
          Column() {
            Text('📋 详细数据记录')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            List({ space: 12 }) {
              ForEach(this.historyData.slice().reverse(), (item: HistoryDataPoint, index: number) => {
                ListItem() {
                  Row() {
                    Column() {
                      Text(this.formatTime(item.timestamp))
                        .fontSize(14)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#333')
                      Text(new Date(item.timestamp).toLocaleDateString())
                        .fontSize(11)
                        .fontColor('#999')
                        .margin({ top: 2 })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .width('25%')

                    Column() {
                      Text(`${item.soilMoisture.toFixed(1)}%`)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor('#4CAF50')
                      Text('土壤湿度')
                        .fontSize(11)
                        .fontColor('#999')
                        .margin({ top: 2 })
                    }
                    .width('18%')

                    Column() {
                      Text(`${item.temperature.toFixed(1)}°C`)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor('#FF9800')
                      Text('温度')
                        .fontSize(11)
                        .fontColor('#999')
                        .margin({ top: 2 })
                    }
                    .width('18%')

                    Column() {
                      Text(`${item.humidity.toFixed(1)}%`)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor('#2196F3')
                      Text('湿度')
                        .fontSize(11)
                        .fontColor('#999')
                        .margin({ top: 2 })
                    }
                    .width('18%')

                    Column() {
                      Text(`${item.lightIntensity.toFixed(0)}`)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor('#FFC107')
                      Text('光照')
                        .fontSize(11)
                        .fontColor('#999')
                        .margin({ top: 2 })
                    }
                    .width('21%')
                  }
                  .width('100%')
                  .padding(16)
                  .backgroundColor(Color.White)
                  .borderRadius(12)
                  .shadow({ radius: 4, color: '#00000006', offsetY: 1 })
                }
              })
            }
            .width('100%')
            .height(300)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#F9F9F9')
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 16 })
          .shadow({ radius: 8, color: '#00000010', offsetY: 2 })
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

    const chartWidth = 280;
    const chartHeight = 180;

    // 清空画布
    context.clearRect(0, 0, chartWidth, chartHeight);

    // 绘制渐变背景区域
    context.save();
    context.beginPath();
    context.moveTo(this.chartData[0].x, chartHeight - 20);

    // 绘制到每个数据点
    this.chartData.forEach(point => {
      context.lineTo(point.x, point.y);
    });

    // 完成底部区域
    context.lineTo(this.chartData[this.chartData.length - 1].x, chartHeight - 20);
    context.closePath();

    // 创建渐变
    const gradient = context.createLinearGradient(0, 0, 0, chartHeight);
    gradient.addColorStop(0, 'rgba(76, 175, 80, 0.3)');
    gradient.addColorStop(1, 'rgba(76, 175, 80, 0.05)');
    context.fillStyle = gradient;
    context.fill();
    context.restore();

    // 绘制主折线
    context.save();
    context.beginPath();
    context.strokeStyle = '#4CAF50';
    context.lineWidth = 3;
    context.lineJoin = 'round';
    context.lineCap = 'round';

    this.chartData.forEach((point, index) => {
      if (index === 0) {
        context.moveTo(point.x, point.y);
      } else {
        context.lineTo(point.x, point.y);
      }
    });

    context.stroke();
    context.restore();

    // 绘制数据点
    this.chartData.forEach(point => {
      // 外圈（白色边框）
      context.save();
      context.beginPath();
      context.arc(point.x, point.y, 6, 0, 2 * Math.PI);
      context.fillStyle = '#FFFFFF';
      context.fill();
      context.restore();

      // 内圈（绿色）
      context.save();
      context.beginPath();
      context.arc(point.x, point.y, 4, 0, 2 * Math.PI);
      context.fillStyle = '#4CAF50';
      context.fill();
      context.restore();
    });

    // 绘制时间标签（仅显示首尾）
    context.save();
    context.fillStyle = '#999';
    context.font = '10px sans-serif';

    // 第一个标签
    if (this.chartData.length > 0) {
      const firstPoint = this.chartData[0];
      context.fillText(firstPoint.time, firstPoint.x - 15, chartHeight - 5);

      // 最后一个标签
      const lastPoint = this.chartData[this.chartData.length - 1];
      context.fillText(lastPoint.time, lastPoint.x - 15, chartHeight - 5);
    }

    context.restore();
  }
}