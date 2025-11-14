// 当前天气数据接口
interface CurrentWeather {
  temperature: number;    // 温度
  humidity: number;       // 湿度
  pressure: number;       // 气压
  windSpeed: number;      // 风速
  windDirection: string;  // 风向
  visibility: number;     // 能见度
  uvIndex: number;        // 紫外线指数
  weatherDesc: string;    // 天气描述
  icon: string;           // 天气图标
}

// 天气预报数据接口
interface WeatherForecast {
  date: string;   // 日期
  high: number;   // 最高温度
  low: number;    // 最低温度
  desc: string;   // 天气描述
  icon: string;   // 天气图标
  rain: number;   // 降雨概率
}

// 天气预警数据接口
interface WeatherAlert {
  type: string;    // 预警类型
  title: string;   // 预警标题
  content: string; // 预警内容
  level: string;   // 预警等级
  time: string;    // 预警时间
}

@Component
export default struct WeatherIntegrationPage {
  @State currentWeather: CurrentWeather = {
    temperature: 28.5,
    humidity: 72,
    pressure: 1013.2,
    windSpeed: 12.5,
    windDirection: '东北风',
    visibility: 15.6,
    uvIndex: 6,
    weatherDesc: '多云',
    icon: '☁️'
  };

  @State weatherForecast: WeatherForecast[] = [
    { date: '今天', high: 30, low: 22, desc: '多云', icon: '☁️', rain: 20 },
    { date: '明天', high: 32, low: 24, desc: '晴', icon: '☀️', rain: 5 },
    { date: '后天', high: 28, low: 20, desc: '小雨', icon: '🌧️', rain: 80 },
    { date: '周四', high: 26, low: 18, desc: '中雨', icon: '🌦️', rain: 90 },
    { date: '周五', high: 29, low: 21, desc: '阴', icon: '☁️', rain: 30 }
  ];

  @State weatherAlerts: WeatherAlert[] = [
    { type: 'warning', title: '大风预警', content: '预计明日风速将达到15m/s，请注意防护', level: '黄色', time: '2024-03-15 10:30' },
    { type: 'info', title: '降雨提醒', content: '后天有中雨，建议暂停灌溉作业', level: '蓝色', time: '2024-03-15 08:00' }
  ];

  @State lastUpdateTime: string = '2024-03-15 14:30:25';
  @State isRefreshing: boolean = false;
  @State showDetailDialog: boolean = false;

  aboutToAppear() {
    this.fetchWeatherData();
  }

  private async fetchWeatherData(): Promise<void> {
    try {
      this.isRefreshing = true;
      await new Promise<void>(resolve => setTimeout(resolve, 1000));
      
      this.currentWeather.temperature = 25 + Math.random() * 10;
      this.currentWeather.humidity = 60 + Math.random() * 30;
      this.lastUpdateTime = new Date().toLocaleString();
      
      console.log('【天气数据】获取天气信息：', this.currentWeather);
    } catch (error) {
      console.error('获取天气数据失败:', error);
    } finally {
      this.isRefreshing = false;
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column({ space: 16 }) {
          // 页面标题和刷新按钮
          this.HeaderSection()

          // 当前天气卡片
          this.CurrentWeatherCard()

          // 5天预报
          this.WeatherForecastSection()

          // 气象指数
          this.WeatherIndexSection()

          // 天气预警
          this.WeatherAlertsSection()
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FAFAFA')

      // 详情对话框
      if (this.showDetailDialog) {
        this.WeatherDetailDialog()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  HeaderSection() {
    Column() {
      Row() {
        Column({ space: 4 }) {
          Text('天气集成')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')

          Text(`更新时间：${this.lastUpdateTime}`)
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.8)')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Button() {
          Row({ space: 6 }) {
            if (this.isRefreshing) {
              LoadingProgress()
                .width(16)
                .height(16)
                .color('#FFFFFF')
            } else {
              Text('🔄')
                .fontSize(14)
            }
            Text('刷新')
              .fontSize(14)
              .fontColor('#FFFFFF')
          }
        }
        .backgroundColor('rgba(255, 255, 255, 0.2)')
        .borderRadius(20)
        .height(40)
        .padding({ left: 20, right: 20 })
        .enabled(!this.isRefreshing)
        .onClick(() => {
          this.fetchWeatherData();
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 20 })
    }
    .width('100%')
    .linearGradient({
      angle: 135,
      colors: [[0x1890FF, 0.0], [0x52C41A, 1.0]]
    })
    .shadow({
      radius: 12,
      color: '#1890FF30',
      offsetX: 0,
      offsetY: 4
    })
  }

  @Builder
  CurrentWeatherCard() {
    Column({ space: 20 }) {
      // 主要天气展示区域
      Row() {
        Column({ space: 12 }) {
          Row({ space: 16 }) {
            Text(this.currentWeather.icon)
              .fontSize(72)

            Column({ space: 4 }) {
              Text(`${this.currentWeather.temperature.toFixed(1)}°`)
                .fontSize(56)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1F2329')

              Text(this.currentWeather.weatherDesc)
                .fontSize(18)
                .fontColor('#666666')
            }
            .alignItems(HorizontalAlign.Start)
          }

          // 风向风速
          Row({ space: 12 }) {
            Row({ space: 6 }) {
              Text('🧭')
                .fontSize(16)
              Text(this.currentWeather.windDirection)
                .fontSize(14)
                .fontColor('#666666')
            }
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#F0F5FF')
            .borderRadius(16)

            Row({ space: 6 }) {
              Text('💨')
                .fontSize(16)
              Text(`${this.currentWeather.windSpeed} m/s`)
                .fontSize(14)
                .fontColor('#666666')
            }
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#F0F9F0')
            .borderRadius(16)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }

      // 分隔线
      Divider()
        .color('#F0F0F0')

      // 详细数据网格
      Row() {
        Column({ space: 8 }) {
          Row({ space: 6 }) {
            Text('💧')
              .fontSize(20)
            Column({ space: 4 }) {
              Text('湿度')
                .fontSize(12)
                .fontColor('#8A8A8A')
              Text(`${this.currentWeather.humidity}%`)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1890FF')
            }
            .alignItems(HorizontalAlign.Start)
          }
        }
        .layoutWeight(1)

        Column({ space: 8 }) {
          Row({ space: 6 }) {
            Text('📊')
              .fontSize(20)
            Column({ space: 4 }) {
              Text('气压')
                .fontSize(12)
                .fontColor('#8A8A8A')
              Text(`${this.currentWeather.pressure}`)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#52C41A')
            }
            .alignItems(HorizontalAlign.Start)
          }
        }
        .layoutWeight(1)

        Column({ space: 8 }) {
          Row({ space: 6 }) {
            Text('👁️')
              .fontSize(20)
            Column({ space: 4 }) {
              Text('能见度')
                .fontSize(12)
                .fontColor('#8A8A8A')
              Text(`${this.currentWeather.visibility}km`)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FAAD14')
            }
            .alignItems(HorizontalAlign.Start)
          }
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .margin({ left: 16, right: 16, top: -30 })
    .shadow({
      radius: 16,
      color: '#00000015',
      offsetX: 0,
      offsetY: 6
    })
  }

  @Builder
  WeatherDetailItem(label: string, value: string) {
    Column({ space: 4 }) {
      Text(label)
        .fontSize(12)
        .fontColor('#8A8A8A')
      
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1F2329')
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  WeatherForecastSection() {
    Column({ space: 12 }) {
      Row() {
        Text('5天预报')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2329')
          .layoutWeight(1)

        Button() {
          Row({ space: 6 }) {
            Text('查看详情')
              .fontSize(14)
              .fontColor('#1890FF')
            Text('→')
              .fontSize(14)
              .fontColor('#1890FF')
          }
        }
        .backgroundColor('transparent')
        .onClick(() => {
          // 【功能点】打开天气详情对话框
          this.showDetailDialog = true;
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      Scroll(new Scroller()) {
        Row({ space: 12 }) {
          ForEach(this.weatherForecast, (item: WeatherForecast, index: number) => {
            this.ForecastCard(item)
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
  }

  @Builder
  ForecastCard(forecast: WeatherForecast) {
    Column({ space: 8 }) {
      Text(forecast.date)
        .fontSize(12)
        .fontColor('#8A8A8A')
      
      Text(forecast.icon)
        .fontSize(24)
      
      Text(forecast.desc)
        .fontSize(12)
        .fontColor('#1F2329')
        .textAlign(TextAlign.Center)
      
      Row({ space: 4 }) {
        Text(`${forecast.high}°`)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2329')
        
        Text(`${forecast.low}°`)
          .fontSize(14)
          .fontColor('#8A8A8A')
      }
      
      Row({ space: 4 }) {
        Text('💧')
          .fontSize(10)
        Text(`${forecast.rain}%`)
          .fontSize(12)
          .fontColor('#1890FF')
      }
    }
    .width(80)
    .height(120)
    .padding(12)
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
  WeatherIndexSection() {
    Column({ space: 12 }) {
      Text('气象指数')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1F2329')
        .alignSelf(ItemAlign.Start)
        .margin({ left: 16 })

      Grid() {
        GridItem() {
          this.IndexCard('紫外线', `${this.currentWeather.uvIndex}级`, '强', '#FF6B35')
        }
        GridItem() {
          this.IndexCard('穿衣指数', '舒适', '建议穿薄外套', '#52C41A')
        }
        GridItem() {
          this.IndexCard('运动指数', '适宜', '适合户外运动', '#1890FF')
        }
        GridItem() {
          this.IndexCard('洗车指数', '不宜', '可能有降雨', '#FAAD14')
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(12)
      .rowsGap(12)
      .height(200)
      .padding({ left: 16, right: 16 })
    }
  }

  @Builder
  IndexCard(title: string, value: string, desc: string, color: string) {
    Column({ space: 8 }) {
      Text(title)
        .fontSize(14)
        .fontColor('#8A8A8A')
      
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
      
      Text(desc)
        .fontSize(12)
        .fontColor('#666666')
        .textAlign(TextAlign.Center)
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
  WeatherAlertsSection() {
    Column({ space: 12 }) {
      Text('天气预警')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1F2329')
        .alignSelf(ItemAlign.Start)
        .margin({ left: 16 })

      if (this.weatherAlerts.length > 0) {
        ForEach(this.weatherAlerts, (alert: WeatherAlert, index: number) => {
          this.AlertCard(alert)
        })
      } else {
        this.EmptyAlertCard()
      }
    }
    .margin({ bottom: 20 })
  }

  @Builder
  AlertCard(alert: WeatherAlert) {
    Row({ space: 12 }) {
      Circle({ width: 8, height: 8 })
        .fill(alert.level === '红色' ? '#FF4D4F' : 
              alert.level === '黄色' ? '#FAAD14' : 
              alert.level === '蓝色' ? '#1890FF' : '#52C41A')
      
      Column({ space: 4 }) {
        Row() {
          Text(alert.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1F2329')
            .layoutWeight(1)
          
          Text(alert.level)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .padding({ top: 2, bottom: 2, left: 8, right: 8 })
            .backgroundColor(alert.level === '红色' ? '#FF4D4F' : 
                            alert.level === '黄色' ? '#FAAD14' : 
                            alert.level === '蓝色' ? '#1890FF' : '#52C41A')
            .borderRadius(10)
        }
        .width('100%')
        
        Text(alert.content)
          .fontSize(14)
          .fontColor('#666666')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        
        Text(alert.time)
          .fontSize(12)
          .fontColor('#8A8A8A')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ left: 16, right: 16 })
    .shadow({
      radius: 8,
      color: '#00000010',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  EmptyAlertCard() {
    Column({ space: 8 }) {
      Text('🌤️')
        .fontSize(32)

      Text('暂无天气预警')
        .fontSize(16)
        .fontColor('#8A8A8A')

      Text('当前天气状况良好')
        .fontSize(14)
        .fontColor('#999999')
    }
    .width('100%')
    .height(120)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ left: 16, right: 16 })
    .shadow({
      radius: 8,
      color: '#00000010',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  WeatherDetailDialog() {
    Stack() {
      // 半透明背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .onClick(() => {
          this.showDetailDialog = false;
        })

      // 对话框内容
      Column({ space: 20 }) {
        // 标题栏
        Row() {
          Text('📊 天气详情')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2329')
            .layoutWeight(1)

          Text('✕')
            .fontSize(24)
            .fontColor('#666666')
            .onClick(() => {
              this.showDetailDialog = false;
            })
        }
        .width('100%')

        Scroll() {
          Column({ space: 16 }) {
            // 当前天气详情
            Column({ space: 12 }) {
              Text('🌡️ 当前天气')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2329')
                .alignSelf(ItemAlign.Start)

              Column({ space: 16 }) {
                this.DetailRow('天气状况', this.currentWeather.weatherDesc, this.currentWeather.icon)
                this.DetailRow('温度', `${this.currentWeather.temperature.toFixed(1)}°C`, '🌡️')
                this.DetailRow('湿度', `${this.currentWeather.humidity}%`, '💧')
                this.DetailRow('气压', `${this.currentWeather.pressure} hPa`, '📊')
                this.DetailRow('风速', `${this.currentWeather.windSpeed} m/s`, '💨')
                this.DetailRow('风向', this.currentWeather.windDirection, '🧭')
                this.DetailRow('能见度', `${this.currentWeather.visibility} km`, '👁️')
                this.DetailRow('紫外线指数', `${this.currentWeather.uvIndex}级`, '☀️')
              }
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(12)
            }

            // 未来天气预报
            Column({ space: 12 }) {
              Text('📅 未来5天预报')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2329')
                .alignSelf(ItemAlign.Start)

              Column({ space: 12 }) {
                ForEach(this.weatherForecast, (item: WeatherForecast) => {
                  Row() {
                    Text(item.icon)
                      .fontSize(24)
                      .width(40)

                    Column({ space: 4 }) {
                      Text(item.date)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor('#1F2329')
                      Text(item.desc)
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)

                    Row({ space: 12 }) {
                      Text(`${item.high}°`)
                        .fontSize(16)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#FF6B35')
                      Text('/')
                        .fontSize(14)
                        .fontColor('#8A8A8A')
                      Text(`${item.low}°`)
                        .fontSize(16)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#1890FF')
                    }

                    Row({ space: 4 }) {
                      Text('💧')
                        .fontSize(12)
                      Text(`${item.rain}%`)
                        .fontSize(14)
                        .fontColor('#1890FF')
                    }
                    .width(60)
                  }
                  .width('100%')
                  .padding(12)
                  .backgroundColor('#FFFFFF')
                  .borderRadius(8)
                })
              }
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(12)
            }

            // 农业建议
            Column({ space: 12 }) {
              Text('🌾 农业建议')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2329')
                .alignSelf(ItemAlign.Start)

              Column({ space: 12 }) {
                this.SuggestionCard('灌溉建议', '当前土壤湿度适中，建议在傍晚进行灌溉', '#52C41A')
                this.SuggestionCard('施肥建议', '天气晴朗，适合进行叶面施肥', '#1890FF')
                this.SuggestionCard('病虫害防治', '注意防范高温高湿引起的病害', '#FAAD14')
              }
              .padding(16)
              .backgroundColor('#F8F9FA')
              .borderRadius(12)
            }
          }
        }
        .layoutWeight(1)

        // 关闭按钮
        Button('关闭')
          .width('100%')
          .height(48)
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#1890FF')
          .borderRadius(8)
          .onClick(() => {
            this.showDetailDialog = false;
          })
      }
      .width('85%')
      .height('80%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({
        radius: 20,
        color: '#00000020',
        offsetX: 0,
        offsetY: 4
      })
    }
    .width('100%')
    .height('100%')
    .position({ x: 0, y: 0 })
    .zIndex(1000)
  }

  @Builder
  DetailRow(label: string, value: string, icon: string) {
    Row() {
      Row({ space: 8 }) {
        Text(icon)
          .fontSize(20)
        Text(label)
          .fontSize(14)
          .fontColor('#666666')
      }
      .layoutWeight(1)

      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1F2329')
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
  }

  @Builder
  SuggestionCard(title: string, content: string, color: string) {
    Row({ space: 12 }) {
      Column()
        .width(4)
        .height(40)
        .backgroundColor(color)
        .borderRadius(2)

      Column({ space: 4 }) {
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2329')
        Text(content)
          .fontSize(12)
          .fontColor('#666666')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
  }
}