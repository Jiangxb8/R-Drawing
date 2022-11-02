library(ggplot2)
library(ggrepel)  #用于标记的包

# 读取火山图数据文件
data = read.delim("https://www.bioladder.cn/shiny/zyp/bioladder2/demoData/Volcano/Volcano.txt",# 这里读取了网络上的demo数据，将此处换成你自己电脑里的文件
                  header = T    # 指定第一行是列名
)
# 建议您的文件里对应的名称跟demo数据一致，这样不用更改后续代码中的变量名称

FC = 1.5 # 用来判断上下调，一般蛋白质组的项目卡1.5
PValue = 0.05 #用来判断上下调

# 判断每个基因的上下调,往数据框data里新增了sig列
data$sig[(-1*log10(data$PValue) < -1*log10(PValue)|data$PValue=="NA")|(log2(data$FC) < log2(FC))& log2(data$FC) > -log2(FC)] <- "NotSig"
data$sig[-1*log10(data$PValue) >= -1*log10(PValue) & log2(data$FC) >= log2(FC)] <- "Up"
data$sig[-1*log10(data$PValue) >= -1*log10(PValue) & log2(data$FC) <= -log2(FC)] <- "Down"

# 标记方式（一）
# 根据数据框中的Marker列，1的为标记，0的为不标记
data$label=ifelse(data$Marker == 1, as.character(data$Name), '')
# （或）标记方式（二）
# 根据PValue小于多少和log[2]FC的绝对值大于多少筛选出合适的点
# PvalueLimit = 0.0001
# FCLimit = 5
# data$label=ifelse(data$PValue < PvalueLimit & abs(log2(data$FC)) >= FCLimit, as.character(data$Name), '')

# 绘图
ggplot(data,aes(log2(data$FC),-1*log10(data$PValue))) +    # 加载数据，定义横纵坐标
  geom_point(aes(color = sig)) +                           # 绘制散点图，分组依据是数据框的sig列
  labs(title="volcanoplot",                                # 定义标题，x轴，y轴名称
       x="log[2](FC)", 
       y="-log[10](PValue)") + 
  # scale_color_manual(values = c("red","green","blue")) + # 自定义颜色，将values更改成你想要的三个颜色
  geom_hline(yintercept=-log10(PValue),linetype=2)+        # 在图上添加虚线
  geom_vline(xintercept=c(-log2(FC),log2(FC)),linetype=2)+ # 在图上添加虚线
  geom_text_repel(aes(x = log2(data$FC),                   # geom_text_repel 标记函数
                      y = -1*log10(data$PValue),          
                      label=label),                       
                  max.overlaps = 10000,                    # 最大覆盖率，当点很多时，有些标记会被覆盖，调大该值则不被覆盖，反之。
                  size=3,                                  # 字体大小
                  box.padding=unit(0.5,'lines'),           # 标记的边距
                  point.padding=unit(0.1, 'lines'), 
                  segment.color='black',                   # 标记线条的颜色
                  show.legend=FALSE)
