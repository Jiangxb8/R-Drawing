library(venn)         #韦恩图（venn 包，适用样本数 2-7）
library(VennDiagram) 

# 读取数据文件
venn_dat <- read.delim('https://www.bioladder.cn/shiny/zyp/bioladder2/demoData/Venn/flower.txt')                      # 这里读取了网络上的demo数据，将此处换成你自己电脑里的文件
venn_list <- list(venn_dat[,1], venn_dat[,2], venn_dat[,3], venn_dat[,4], venn_dat[,5], venn_dat[,6], venn_dat[,7])   # 制作韦恩图搜所需要的列表文件
names(venn_list) <- colnames(venn_dat[1:7])    # 把列名赋值给列表的key值
venn_list = purrr::map(venn_list,na.omit)      # 删除列表中每个向量中的NA

#作图
venn(venn_list,
     zcolor='style', # 调整颜色，style是默认颜色，bw是无颜色，当然也可以自定义颜色
     opacity = 0.3,  # 调整颜色透明度
     box = F,        # 是否添加边框
     ilcs = 0.5,     # 数字大小
     sncs = 1        # 组名字体大小
)

# 查看交集详情,并导出结果
inter <- get.venn.partitions(venn_list)
for (i in 1:nrow(inter)) inter[i,'values'] <- paste(inter[[i,'..values..']], collapse = '|')
inter <- subset(inter, select = -..values.. )
inter <- subset(inter, select = -..set.. )
write.table(inter, "result.csv", row.names = FALSE, sep = ',', quote = FALSE)