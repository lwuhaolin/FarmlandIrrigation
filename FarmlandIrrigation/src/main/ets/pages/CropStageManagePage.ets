// 作物数据类型定义
interface Crop {
  id: string;
  name: string;
  variety: string;
  plantingDate: string;
  expectedHarvestDate: string;
  currentStage: string;
  progress: number;
  area: number;
  status: 'healthy' | 'attention' | 'critical';
  location: string;
  lastUpdated: string;
}

// 作物阶段定义
interface CropStage {
  name: string;
  duration: number;
  description: string;
  requirements: string[];
  icon: string;
}

// 种植计划数据
interface PlantingPlan {
  id: string;
  cropName: string;
  variety: string;
  area: number;
  plannedDate: string;
  expectedHarvest: string;
  notes: string;
}


interface CropType {
  name: string;
  varieties: string[];
  stages: CropStage[];
  totalDays: number;
}
@Component
export default struct CropStageManagePage {
  @State currentTab: number = 0;
  @State crops: Crop[] = [];
  @State plantingPlans: PlantingPlan[] = [];
  @State selectedCrop: Crop | null = null;
  @State showAddDialog: boolean = false;
  @State showPlanDialog: boolean = false;
  @State searchText: string = '';
  @State filterStatus: string = 'all';
  @State isLoading: boolean = false;
  @State lastRefresh: string = '';

  // 新建计划表单数据
  @State newPlanCropName: string = '';
  @State newPlanVariety: string = '';
  @State newPlanArea: string = '';
  @State newPlanDate: string = '';
  @State newPlanNotes: string = '';

  // 作物类型配置
  private readonly cropTypes: CropType[]  = [
    {
      name: '水稻',
      varieties: ['优质稻', '超级稻', '香米', '糯米'],
      stages: [
        { name: '播种', duration: 7, description: '种子萌发期', requirements: ['选种', '浸种', '催芽'], icon: '🌱' },
        { name: '发芽', duration: 10, description: '幼苗出土期', requirements: ['保湿', '温控', '光照'], icon: '🌿' },
        { name: '分蘖', duration: 25, description: '营养生长期', requirements: ['施肥', '灌水', '除草'], icon: '🌾' },
        { name: '拔节', duration: 20, description: '茎秆伸长期', requirements: ['追肥', '控水', '防虫'], icon: '🎋' },
        { name: '抽穗', duration: 15, description: '生殖生长期', requirements: ['充足水分', '防病'], icon: '🌾' },
        { name: '灌浆', duration: 30, description: '籽粒充实期', requirements: ['适度干湿', '防倒伏'], icon: '🌾' },
        { name: '成熟', duration: 15, description: '收获期', requirements: ['适时收割'], icon: '🌾' }
      ],
      totalDays: 122
    },
    {
      name: '玉米',
      varieties: ['甜玉米', '糯玉米', '饲料玉米', '爆裂玉米'],
      stages: [
        { name: '播种', duration: 5, description: '种子播种期', requirements: ['整地', '施底肥'], icon: '🌱' },
        { name: '出苗', duration: 8, description: '幼苗期', requirements: ['保墒', '间苗'], icon: '🌿' },
        { name: '拔节', duration: 30, description: '营养生长期', requirements: ['追肥', '培土'], icon: '🌽' },
        { name: '抽雄', duration: 10, description: '雄穗期', requirements: ['充足水分'], icon: '🌽' },
        { name: '吐丝', duration: 5, description: '雌穗期', requirements: ['授粉保护'], icon: '🌽' },
        { name: '灌浆', duration: 35, description: '籽粒形成期', requirements: ['防虫害'], icon: '🌽' },
        { name: '成熟', duration: 12, description: '收获期', requirements: ['适时收获'], icon: '🌽' }
      ],
      totalDays: 105
    },
    {
      name: '小麦',
      varieties: ['春小麦', '冬小麦', '硬质麦', '软质麦'],
      stages: [
        { name: '播种', duration: 7, description: '播种期', requirements: ['整地', '选种'], icon: '🌱' },
        { name: '出苗', duration: 10, description: '出苗期', requirements: ['保墒', '除草'], icon: '🌿' },
        { name: '分蘖', duration: 35, description: '分蘖期', requirements: ['追肥', '灌水'], icon: '🌾' },
        { name: '拔节', duration: 25, description: '拔节期', requirements: ['防倒伏'], icon: '🌾' },
        { name: '抽穗', duration: 12, description: '抽穗期', requirements: ['防病虫'], icon: '🌾' },
        { name: '开花', duration: 8, description: '开花期', requirements: ['适宜温度'], icon: '🌾' },
        { name: '灌浆', duration: 25, description: '灌浆期', requirements: ['充足水分'], icon: '🌾' },
        { name: '成熟', duration: 15, description: '成熟期', requirements: ['适时收割'], icon: '🌾' }
      ],
      totalDays: 137
    }
  ];

  aboutToAppear() {
    this.initializeData();
    this.loadCropData();
  }

  private initializeData(): void {
    this.lastRefresh = new Date().toLocaleString();
    this.generateMockData();
  }

  private generateMockData(): void {
    this.crops = [
      {
        id: '1',
        name: '水稻',
        variety: '优质稻',
        plantingDate: '2024-03-15',
        expectedHarvestDate: '2024-07-15',
        currentStage: '分蘖',
        progress: 45,
        area: 10.5,
        status: 'healthy',
        location: '东区田块A1',
        lastUpdated: '2024-03-28 14:30'
      },
      {
        id: '2',
        name: '玉米',
        variety: '甜玉米',
        plantingDate: '2024-04-01',
        expectedHarvestDate: '2024-07-20',
        currentStage: '出苗',
        progress: 20,
        area: 8.2,
        status: 'attention',
        location: '西区田块B2',
        lastUpdated: '2024-04-05 09:15'
      },
      {
        id: '3',
        name: '小麦',
        variety: '冬小麦',
        plantingDate: '2024-02-10',
        expectedHarvestDate: '2024-06-25',
        currentStage: '拔节',
        progress: 65,
        area: 15.0,
        status: 'healthy',
        location: '南区田块C3',
        lastUpdated: '2024-04-01 16:45'
      }
    ];

    this.plantingPlans = [
      {
        id: 'plan1',
        cropName: '水稻',
        variety: '香米',
        area: 12.0,
        plannedDate: '2024-04-20',
        expectedHarvest: '2024-08-20',
        notes: '计划在雨季前完成播种'
      },
      {
        id: 'plan2',
        cropName: '玉米',
        variety: '糯玉米',
        area: 6.5,
        plannedDate: '2024-05-01',
        expectedHarvest: '2024-08-15',
        notes: '适合制作玉米深加工产品'
      }
    ];
  }

  private async loadCropData(): Promise<void> {
    this.isLoading = true;
    try {
      await new Promise<void>(resolve => setTimeout(resolve, 1000));
      this.lastRefresh = new Date().toLocaleString();
    } catch (error) {
      console.error('加载作物数据失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  private getFilteredCrops(): Crop[] {
    return this.crops.filter(crop => {
      const matchesSearch = crop.name.includes(this.searchText) || 
                           crop.variety.includes(this.searchText) ||
                           crop.location.includes(this.searchText);
      const matchesStatus = this.filterStatus === 'all' || crop.status === this.filterStatus;
      return matchesSearch && matchesStatus;
    });
  }

  private getStatusColor(status: string): string {
    switch (status) {
      case 'healthy': return '#52C41A';
      case 'attention': return '#FAAD14';
      case 'critical': return '#FF4D4F';
      default: return '#8A8A8A';
    }
  }

  private getStatusText(status: string): string {
    switch (status) {
      case 'healthy': return '健康';
      case 'attention': return '需关注';
      case 'critical': return '异常';
      default: return '未知';
    }
  }

  // 执行种植计划
  private executePlan(plan: PlantingPlan): void {
    console.log(`执行种植计划: ${plan.cropName} - ${plan.variety}`);
    // 【功能点】执行种植计划
    // 将计划转换为实际的作物记录
    const newCrop: Crop = {
      id: `crop_${Date.now()}`,
      name: plan.cropName,
      variety: plan.variety,
      plantingDate: plan.plannedDate,
      expectedHarvestDate: plan.expectedHarvest,
      currentStage: '播种',
      progress: 0,
      area: plan.area,
      status: 'healthy',
      location: '待分配',
      lastUpdated: new Date().toLocaleString()
    };

    this.crops.push(newCrop);

    // 从计划列表中移除
    const index = this.plantingPlans.findIndex(p => p.id === plan.id);
    if (index > -1) {
      this.plantingPlans.splice(index, 1);
    }

    console.log('计划已执行，作物已添加到作物列表');
  }

  // 删除种植计划
  private deletePlan(planId: string): void {
    const index = this.plantingPlans.findIndex(p => p.id === planId);
    if (index > -1) {
      this.plantingPlans.splice(index, 1);
      console.log(`已删除种植计划: ${planId}`);
    }
  }

  // 添加新的种植计划
  private addNewPlan(): void {
    if (!this.newPlanCropName || !this.newPlanVariety || !this.newPlanArea || !this.newPlanDate) {
      console.log('请填写所有必填项');
      return;
    }

    const area = parseFloat(this.newPlanArea);
    if (isNaN(area) || area <= 0) {
      console.log('请输入有效的面积');
      return;
    }

    // 计算预期收获日期
    const expectedHarvest = this.calculateHarvestDate(this.newPlanCropName, this.newPlanDate);

    const newPlan: PlantingPlan = {
      id: `plan_${Date.now()}`,
      cropName: this.newPlanCropName,
      variety: this.newPlanVariety,
      area: area,
      plannedDate: this.newPlanDate,
      expectedHarvest: expectedHarvest,
      notes: this.newPlanNotes
    };

    this.plantingPlans.push(newPlan);
    this.showPlanDialog = false;
    this.resetPlanForm();

    console.log('新增种植计划成功:', newPlan);
  }

  // 计算预期收获日期
  private calculateHarvestDate(cropName: string, plantingDate: string): string {
    const crop = this.cropTypes.find(c => c.name === cropName);
    if (!crop) {
      return '';
    }

    // 验证日期格式并检查有效性
    if (!plantingDate || plantingDate.trim() === '') {
      return '';
    }

    const date = new Date(plantingDate);

    // 检查日期是否有效
    if (isNaN(date.getTime())) {
      return '';
    }

    date.setDate(date.getDate() + crop.totalDays);

    return date.toISOString().split('T')[0];
  }

  // 重置计划表单
  private resetPlanForm(): void {
    this.newPlanCropName = '';
    this.newPlanVariety = '';
    this.newPlanArea = '';
    this.newPlanDate = '';
    this.newPlanNotes = '';
  }

  // 获取当前选择作物的品种列表
  private getCurrentVarieties(): string[] {
    const crop = this.cropTypes.find(c => c.name === this.newPlanCropName);
    return crop ? crop.varieties : [];
  }

  build() {
    Column() {
      this.HeaderSection()

      if (this.currentTab === 0) {
        this.CropManagementTab()
      } else {
        this.PlantingPlanTab()
      }

      // 新建种植计划对话框
      if (this.showPlanDialog) {
        this.PlanDialogOverlay()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  HeaderSection() {
    Column() {
      Row() {
        Text('作物管理')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2329')
          .layoutWeight(1)

        Button() {
          Row({ space: 6 }) {
            if (this.isLoading) {
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
        .backgroundColor('#1890FF')
        .borderRadius(20)
        .height(36)
        .padding({ left: 16, right: 16 })
        .onClick(() => this.loadCropData())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16 })

      Text(`最后更新：${this.lastRefresh}`)
        .fontSize(12)
        .fontColor('#8A8A8A')
        .alignSelf(ItemAlign.Start)
        .margin({ left: 16, top: 4 })

      Row() {
        this.TabButton('作物监控', 0)
        this.TabButton('种植计划', 1)
      }
      .width('100%')
      .margin({ top: 16 })
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#FFFFFF')
    .shadow({
      radius: 8,
      color: '#00000010',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  TabButton(text: string, index: number) {
    Button(text)
      .fontSize(16)
      .fontColor(this.currentTab === index ? '#1890FF' : '#666666')
      .backgroundColor(this.currentTab === index ? '#E6F7FF' : 'transparent')
      .border({ width: this.currentTab === index ? 2 : 0, color: '#1890FF' })
      .borderRadius(8)
      .layoutWeight(1)
      .margin({ left: index > 0 ? 8 : 0 })
      .onClick(() => {
        this.currentTab = index;
      })
  }

  @Builder
  CropManagementTab() {
    Column({ space: 16 }) {
      this.SearchAndFilterSection()
      this.CropStatsSection()
      this.CropListSection()
    }
    .padding({ top: 16 })
    .layoutWeight(1)
  }

  @Builder
  SearchAndFilterSection() {
    Column({ space: 12 }) {
      Row({ space: 12 }) {
        TextInput({ placeholder: '搜索作物名称、品种或位置...' })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.searchText = value;
          })
          .borderRadius(8)

        Button('筛选')
          .backgroundColor('#52C41A')
          .borderRadius(8)
      }

      Row({ space: 8 }) {
        Text('状态筛选：')
          .fontSize(14)
          .fontColor('#666666')

        this.FilterChip('全部', 'all')
        this.FilterChip('健康', 'healthy')
        this.FilterChip('需关注', 'attention')
        this.FilterChip('异常', 'critical')
      }
    }
    .padding({ left: 16, right: 16 })
  }

  @Builder
  FilterChip(text: string, value: string) {
    Button(text)
      .fontSize(12)
      .fontColor(this.filterStatus === value ? '#FFFFFF' : '#666666')
      .backgroundColor(this.filterStatus === value ? '#1890FF' : '#F5F5F5')
      .borderRadius(16)
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .onClick(() => {
        this.filterStatus = value;
      })
  }

  @Builder
  CropStatsSection() {
    Row({ space: 12 }) {
      this.StatsCard('总作物', this.crops.length.toString(), '🌾', '#1890FF')
      this.StatsCard('健康状态', this.crops.filter(c => c.status === 'healthy').length.toString(), '✅', '#52C41A')
      this.StatsCard('需关注', this.crops.filter(c => c.status === 'attention').length.toString(), '⚠️', '#FAAD14')
      this.StatsCard('种植面积', `${this.crops.reduce((sum, c) => sum + c.area, 0).toFixed(1)}亩`, '📏', '#722ED1')
    }
    .padding({ left: 16, right: 16 })
  }

  @Builder
  StatsCard(title: string, value: string, icon: string, color: string) {
    Column({ space: 8 }) {
      Text(icon)
        .fontSize(24)

      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)

      Text(title)
        .fontSize(12)
        .fontColor('#666666')
    }
    .layoutWeight(1)
    .height(100)
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
  CropListSection() {
    Column() {
      Row() {
        Text('作物列表')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2329')
          .layoutWeight(1)

        Button('+ 添加作物')
          .fontSize(14)
          .fontColor('#1890FF')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#1890FF' })
          .borderRadius(8)
          .onClick(() => {
            this.showAddDialog = true;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })

      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.getFilteredCrops(), (crop: Crop) => {
            this.CropCard(crop)
          })

          if (this.getFilteredCrops().length === 0) {
            this.EmptyState()
          }
        }
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .layoutWeight(1)
    }
    .layoutWeight(1)
  }

  @Builder
  CropCard(crop: Crop) {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 4 }) {
          Row({ space: 8 }) {
            Text(crop.name)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F2329')

            Text(crop.variety)
              .fontSize(14)
              .fontColor('#666666')
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              .backgroundColor('#F5F5F5')
              .borderRadius(4)
          }

          Text(crop.location)
            .fontSize(14)
            .fontColor('#8A8A8A')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Column({ space: 4 }) {
          Text(this.getStatusText(crop.status))
            .fontSize(12)
            .fontColor('#FFFFFF')
            .backgroundColor(this.getStatusColor(crop.status))
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(12)

          Text(`${crop.area}亩`)
            .fontSize(12)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.End)
      }

      Row() {
        Column({ space: 4 }) {
          Text(`当前阶段：${crop.currentStage}`)
            .fontSize(14)
            .fontColor('#1F2329')

          Progress({
            value: crop.progress,
            total: 100,
            type: ProgressType.Linear
          })
          .width('100%')
          .height(6)
          .backgroundColor('#F5F5F5')
          .color('#1890FF')

          Text(`进度：${crop.progress}%`)
            .fontSize(12)
            .fontColor('#666666')
        }
        .layoutWeight(1)
      }

      Row({ space: 12 }) {
        Text(`播种：${crop.plantingDate}`)
          .fontSize(12)
          .fontColor('#666666')

        Text(`预计收获：${crop.expectedHarvestDate}`)
          .fontSize(12)
          .fontColor('#666666')

        Text(`更新：${crop.lastUpdated}`)
          .fontSize(12)
          .fontColor('#8A8A8A')
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }

      Row({ space: 8 }) {
        Button('查看详情')
          .fontSize(12)
          .fontColor('#1890FF')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#1890FF' })
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            this.selectedCrop = crop;
          })

        Button('编辑')
          .fontSize(12)
          .fontColor('#52C41A')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#52C41A' })
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            // 【功能点】编辑作物信息
            // 应打开编辑对话框，允许修改作物的各项信息
            console.log(`编辑作物: ${crop.name} (ID: ${crop.id})`);
            this.selectedCrop = crop;
            this.showAddDialog = true;
          })

        Button('记录')
          .fontSize(12)
          .fontColor('#FAAD14')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#FAAD14' })
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            // 【功能点】记录作物生长信息
            // 应打开记录对话框，记录浇水、施肥、病虫害等信息
            console.log(`记录作物生长信息: ${crop.name} (ID: ${crop.id})`);
            this.selectedCrop = crop;
            // TODO: 打开生长记录对话框
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
  PlantingPlanTab() {
    Column({ space: 16 }) {
      Row() {
        Text('种植计划')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2329')
          .layoutWeight(1)

        Button('+ 新建计划')
          .fontSize(14)
          .fontColor('#FFFFFF')
          .backgroundColor('#52C41A')
          .borderRadius(8)
          .onClick(() => {
            this.showPlanDialog = true;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16 })

      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.plantingPlans, (plan: PlantingPlan) => {
            this.PlanCard(plan)
          })

          if (this.plantingPlans.length === 0) {
            this.EmptyPlanState()
          }
        }
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .layoutWeight(1)
    }
    .layoutWeight(1)
  }

  @Builder
  PlanCard(plan: PlantingPlan) {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 4 }) {
          Text(`${plan.cropName} - ${plan.variety}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2329')

          Text(`面积：${plan.area}亩`)
            .fontSize(14)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Text('计划中')
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor('#1890FF')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(12)
      }

      Row({ space: 16 }) {
        Text(`计划播种：${plan.plannedDate}`)
          .fontSize(14)
          .fontColor('#666666')

        Text(`预计收获：${plan.expectedHarvest}`)
          .fontSize(14)
          .fontColor('#666666')
      }

      if (plan.notes) {
        Text(`备注：${plan.notes}`)
          .fontSize(14)
          .fontColor('#8A8A8A')
          .padding(8)
          .backgroundColor('#F8F9FA')
          .borderRadius(6)
      }

      Row({ space: 8 }) {
        Button('执行计划')
          .fontSize(12)
          .fontColor('#FFFFFF')
          .backgroundColor('#52C41A')
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            // 【功能点】执行种植计划
            // 将计划转换为实际作物记录并切换到作物监控标签
            this.executePlan(plan);
            this.currentTab = 0;
          })

        Button('编辑')
          .fontSize(12)
          .fontColor('#1890FF')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#1890FF' })
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            // 【功能点】编辑种植计划
            // 应打开编辑对话框，允许修改计划信息
            console.log(`编辑种植计划: ${plan.cropName} (ID: ${plan.id})`);
            this.showPlanDialog = true;
          })

        Button('删除')
          .fontSize(12)
          .fontColor('#FF4D4F')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#FF4D4F' })
          .borderRadius(6)
          .layoutWeight(1)
          .onClick(() => {
            // 【功能点】删除种植计划
            console.log(`删除种植计划: ${plan.cropName} (ID: ${plan.id})`);
            this.deletePlan(plan.id);
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
    Column({ space: 12 }) {
      Text('🌾')
        .fontSize(48)

      Text('暂无作物数据')
        .fontSize(16)
        .fontColor('#8A8A8A')

      Text('点击"添加作物"开始记录您的种植信息')
        .fontSize(14)
        .fontColor('#999999')
        .textAlign(TextAlign.Center)

      Button('添加第一个作物')
        .fontColor('#FFFFFF')
        .backgroundColor('#1890FF')
        .borderRadius(8)
        .onClick(() => {
          this.showAddDialog = true;
        })
    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)
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
  EmptyPlanState() {
    Column({ space: 12 }) {
      Text('📅')
        .fontSize(48)

      Text('暂无种植计划')
        .fontSize(16)
        .fontColor('#8A8A8A')

      Text('制定您的种植计划，合理安排作物种植时间')
        .fontSize(14)
        .fontColor('#999999')
        .textAlign(TextAlign.Center)

      Button('创建种植计划')
        .fontColor('#FFFFFF')
        .backgroundColor('#52C41A')
        .borderRadius(8)
        .onClick(() => {
          this.showPlanDialog = true;
        })
    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)
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
  PlanDialogOverlay() {
    Stack() {
      // 半透明背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .onClick(() => {
          this.showPlanDialog = false;
          this.resetPlanForm();
        })

      // 对话框内容
      Column({ space: 20 }) {
        // 标题栏
        Row() {
          Text('新建种植计划')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2329')
            .layoutWeight(1)

          Text('✕')
            .fontSize(24)
            .fontColor('#666666')
            .onClick(() => {
              this.showPlanDialog = false;
              this.resetPlanForm();
            })
        }
        .width('100%')

        Scroll() {
          Column({ space: 16 }) {
            // 作物类型选择
            Column({ space: 8 }) {
              Row() {
                Text('作物类型')
                  .fontSize(14)
                  .fontColor('#333333')
                Text('*')
                  .fontSize(14)
                  .fontColor('#FF4D4F')
              }

              Row({ space: 8 }) {
                ForEach(this.cropTypes, (crop: CropType) => {
                  Button(crop.name)
                    .fontSize(14)
                    .fontColor(this.newPlanCropName === crop.name ? '#FFFFFF' : '#666666')
                    .backgroundColor(this.newPlanCropName === crop.name ? '#52C41A' : '#F5F5F5')
                    .borderRadius(8)
                    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                    .onClick(() => {
                      this.newPlanCropName = crop.name;
                      this.newPlanVariety = ''; // 重置品种选择
                    })
                })
              }
            }
            .alignItems(HorizontalAlign.Start)

            // 品种选择
            if (this.newPlanCropName) {
              Column({ space: 8 }) {
                Row() {
                  Text('品种')
                    .fontSize(14)
                    .fontColor('#333333')
                  Text('*')
                    .fontSize(14)
                    .fontColor('#FF4D4F')
                }

                Row({ space: 8 }) {
                  ForEach(this.getCurrentVarieties(), (variety: string) => {
                    Button(variety)
                      .fontSize(14)
                      .fontColor(this.newPlanVariety === variety ? '#FFFFFF' : '#666666')
                      .backgroundColor(this.newPlanVariety === variety ? '#52C41A' : '#F5F5F5')
                      .borderRadius(8)
                      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                      .onClick(() => {
                        this.newPlanVariety = variety;
                      })
                  })
                }
              }
              .alignItems(HorizontalAlign.Start)
            }

            // 种植面积
            Column({ space: 8 }) {
              Row() {
                Text('种植面积（亩）')
                  .fontSize(14)
                  .fontColor('#333333')
                Text('*')
                  .fontSize(14)
                  .fontColor('#FF4D4F')
              }

              TextInput({ placeholder: '请输入种植面积', text: this.newPlanArea })
                .type(InputType.Number)
                .onChange((value: string) => {
                  this.newPlanArea = value;
                })
                .borderRadius(8)
            }
            .alignItems(HorizontalAlign.Start)

            // 计划播种日期
            Column({ space: 8 }) {
              Row() {
                Text('计划播种日期')
                  .fontSize(14)
                  .fontColor('#333333')
                Text('*')
                  .fontSize(14)
                  .fontColor('#FF4D4F')
              }

              TextInput({ placeholder: '格式：YYYY-MM-DD', text: this.newPlanDate })
                .type(InputType.Normal)
                .onChange((value: string) => {
                  this.newPlanDate = value;
                })
                .borderRadius(8)
            }
            .alignItems(HorizontalAlign.Start)

            // 预期收获日期（自动计算）
            if (this.newPlanCropName && this.newPlanDate) {
              Column({ space: 8 }) {
                Text('预期收获日期')
                  .fontSize(14)
                  .fontColor('#333333')

                Text(this.calculateHarvestDate(this.newPlanCropName, this.newPlanDate) || '请输入有效的日期格式 (YYYY-MM-DD)')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.calculateHarvestDate(this.newPlanCropName, this.newPlanDate) ? '#52C41A' : '#FF4D4F')
                  .padding(12)
                  .backgroundColor(this.calculateHarvestDate(this.newPlanCropName, this.newPlanDate) ? '#F0F9F0' : '#FFF1F0')
                  .borderRadius(8)
                  .width('100%')
              }
              .alignItems(HorizontalAlign.Start)
            }

            // 备注
            Column({ space: 8 }) {
              Text('备注')
                .fontSize(14)
                .fontColor('#333333')

              TextArea({ placeholder: '输入种植计划备注信息...', text: this.newPlanNotes })
                .height(80)
                .onChange((value: string) => {
                  this.newPlanNotes = value;
                })
                .borderRadius(8)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .padding({ left: 4, right: 4 })
        }
        .layoutWeight(1)

        // 底部按钮
        Row({ space: 12 }) {
          Button('取消')
            .fontSize(16)
            .fontColor('#666666')
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .layoutWeight(1)
            .onClick(() => {
              this.showPlanDialog = false;
              this.resetPlanForm();
            })

          Button('确认添加')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor('#52C41A')
            .borderRadius(8)
            .layoutWeight(1)
            .onClick(() => {
              this.addNewPlan();
            })
        }
      }
      .width('90%')
      .height('80%')
      .padding(16)
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
}