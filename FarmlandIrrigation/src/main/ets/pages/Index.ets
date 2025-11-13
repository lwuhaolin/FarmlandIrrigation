// Tabs, TabContent, and BarPosition are built-in components in HarmonyOS ArkTS
import RealtimeDashboard from './RealtimeDashboard';
import HistoryData from './HistoryDataPage';
import CropStageManagePage from './CropStageManagePage';
import IrrigationStrategyPage from './IrrigationStrategyPage';
import CostStatistics from './CostStatistics';
import AlertManagement from './AlertManagement';
import WeatherIntegrationPage from './WeatherIntegrationPage';

interface MenuItem {
  title: string;
}

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();

  // 定义菜单项数据
  private menuItems: Array<MenuItem> = [
    {title: '实时监控'},
    {title: '历史数据'},
    {title: '作物管理'}, 
    {title: '灌溉设置'},
    {title: '成本统计'},
    {title: '告警管理'},
    {title: '天气集成'}
  ];

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('智慧农田监测系统')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2329')
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#F5F5F5')

      // 水平滚动菜单
      Scroll() {
        Row() {
          ForEach(this.menuItems, (item: MenuItem, index: number) => {
            Column() {
              Text(item.title)
                .fontSize(14)
                .fontColor(this.currentIndex === index ? '#007DFF' : '#8A8A8A')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            }
            .backgroundColor(this.currentIndex === index ? '#E6F7FF' : '#FFFFFF')
            .borderRadius(20)
            .margin({ left: 8, right: 8 })
            .onClick(() => {
              this.currentIndex = index;
            })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(60)

      // 内容区域
      Column() {
        this.RenderCurrentPage()
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  RenderCurrentPage() {
    if (this.currentIndex === 0) {
      RealtimeDashboard()
    } else if (this.currentIndex === 1) {
      HistoryData()
    } else if (this.currentIndex === 2) {
      CropStageManagePage()
    } else if (this.currentIndex === 3) {
      IrrigationStrategyPage()
    } else if (this.currentIndex === 4) {
      CostStatistics()
    } else if (this.currentIndex === 5) {
      AlertManagement()
    } else if (this.currentIndex === 6) {
      WeatherIntegrationPage()
    } else {
      // 默认页面
      Column() {
        Text('功能开发中...')
          .fontSize(16)
          .fontColor('#888')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
  }

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontSize(12)
        .fontColor(this.currentIndex === targetIndex ? '#007DFF' : '#8A8A8A')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}