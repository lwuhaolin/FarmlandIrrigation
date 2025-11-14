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
      // 整合的顶部区域（标题+菜单）
      Column() {
        // 标题行
        Row() {
          Text('智慧农田监测系统')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2329')
        }
        .width('100%')
        .height(48)
        .justifyContent(FlexAlign.Center)

        // 菜单栏
        Scroll() {
          Row() {
            ForEach(this.menuItems, (item: MenuItem, index: number) => {
              Column() {
                Text(item.title)
                  .fontSize(14)
                  .fontColor(this.currentIndex === index ? '#FFFFFF' : '#666666')
                  .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Normal)
              }
              .height(36)
              .padding({ left: 20, right: 20 })
              .backgroundColor(this.currentIndex === index ? '#1890FF' : 'transparent')
              .borderRadius(18)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.currentIndex = index;
              })
              .margin({ right: 8 })
            })
          }
          .padding({ left: 12, right: 12, bottom: 8 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
        .height(52)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .shadow({
        radius: 8,
        color: '#00000010',
        offsetX: 0,
        offsetY: 2
      })

      // 内容区域
      Column() {
        this.RenderCurrentPage()
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  RenderCurrentPage() {
    if (this.currentIndex === 0) {
      RealtimeDashboard({ onNavigateToIrrigation: () => {
        this.currentIndex = 3; // 跳转到灌溉设置页面（索引3）
      }})
    } else if (this.currentIndex === 1) {
      HistoryData()
    } else if (this.currentIndex === 2) {
      CropStageManagePage()
    } else if (this.currentIndex === 3) {
      IrrigationStrategyPage({ onNavigateBack: () => {
        this.currentIndex = 0; // 返回到实时监控页面（索引0）
      }})
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