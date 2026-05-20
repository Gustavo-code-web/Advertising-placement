select * from 成本 limit 10;
select * from `渠道花费表` limit 10;
select * from `渠道行为表` limit 10;
select * from `用户回访表` limit 10;
select * from `用户信息表` limit 10;
select * from `用户行为表` limit 10;
select * from `用户状态表` limit 10;


select
a.渠道,曝光_前,曝光_中,曝光_后,(曝光_中-曝光_前)/曝光_前 增长率_前_中,(曝光_后-曝光_中)/曝光_中 增长率_中_后
from 
(select
渠道,avg(曝光) 曝光_前
from `渠道行为表`
where 日期 between '2024-10-29' and '2024-11-04' 
GROUP BY 渠道) a,
(
select
渠道,avg(曝光) 曝光_中
from `渠道行为表`
where 日期 between '2024-11-05' and '2024-11-11' 
GROUP BY 渠道) b,
(
select
渠道,avg(曝光) 曝光_后
from `渠道行为表`
where 日期 between '2024-11-12' and '2024-11-18' 
GROUP BY 渠道) c
where a.渠道=b.渠道 and a.渠道=c.渠道


SELECT 
    t.渠道,
    SUM(t.花费) AS 花费量级,
    CONCAT(ROUND((SUM(t.花费) / t1.总花费) * 100, 2), '%') AS 花费占比,
    SUM(t.注册) AS 注册量级,
    CONCAT(ROUND((SUM(t.注册) / t1.总注册) * 100, 2), '%') AS 注册占比,
    CONCAT(ROUND(((SUM(t.注册) / t1.总注册) / (SUM(t.花费) / t1.总花费)) * 100, 0), '%') AS 回报率,
    ROUND(SUM(t.花费) / SUM(t.注册), 2) AS 注册成本
FROM 
    `成本` t
JOIN (
    SELECT 
        SUM(花费) AS 总花费, 
        SUM(注册) AS 总注册 
    FROM 
        `成本`
) t1
GROUP BY 
    t.渠道, t1.总花费, t1.总注册
ORDER BY 
    ((SUM(t.注册) / t1.总注册) / (SUM(t.花费) / t1.总花费)) DESC;


with t1 as(
select
渠道,round(sum(花费),0) 总花费,sum(注册) 总注册,round(sum(花费)/sum(注册),2) 成本
from 成本
GROUP BY 渠道
order by 4),
t2 as(
select
渠道,round(sum(花费)/(select sum(花费) from 成本),4) 花费占比,round(sum(注册)/(select sum(注册) from 成本),4) 注册占比
from 成本
GROUP BY 渠道),
t3 as(select
a.渠道,总花费,总注册,成本,花费占比,注册占比,round(注册占比/花费占比,2) 回报率
from t1 a,t2 b where a.渠道=b.渠道),
t4 as(
  
)


select 渠道,round(sum(注册)/sum(曝光),4) 转化率
from 渠道行为表
group by 渠道
order by round(sum(注册)/sum(曝光),4) desc;







with t as(
select 
渠道,id,sum(`订单数量`) 总订单数
from `用户行为表`
GROUP BY 渠道,id
),
-- 用户到2019-12-13注册天数
t2 as (
select
id,DATEDIFF('2024-12-13',日期) 注册天数
from `用户信息表`
),

t3 as (
select 
渠道,a.id,总订单数,注册天数,总订单数/注册天数 日均订单量
from t a inner join t2 b on a.id=b.id
),

-- 每个渠道每个人日均订单量2
t4 as(
select
渠道,avg(日均订单量) 日均订单数量
from t3 group by 渠道
)
-- 每个渠道每个人均订量数量降序排列
select 渠道,日均订单数量,rank() over(order by 日均订单数量 desc) 日均订单排名 from t4 order by 日均订单数量 desc;






with t as(
select 
渠道,id,sum(`实际成交金额`) 总额
from `用户行为表`
GROUP BY 渠道,id
),
-- 用户到2019-12-13注册天数
t2 as (
select
id,DATEDIFF('2024-12-13',日期) 注册天数
from `用户信息表`
),

t3 as (
select 
渠道,a.id,总额,注册天数,总额/注册天数 日均成交额
from t a inner join t2 b on a.id=b.id
),

-- 每个渠道每个人日均订单量2
t4 as(
select
渠道,avg(日均成交额) 日均实际成交额
from t3 group by 渠道
)
-- 每个渠道每个人均订量数量降序排列
select 渠道,日均实际成交额,rank() over(order by 日均实际成交额 desc) 日均订单排名 from t4 order by 日均实际成交额 desc;



with t as(
select 
渠道,id,sum(`实际成交金额`) 总额
from `用户行为表`
GROUP BY 渠道,id
),
t2 as (
select
id,sum(订单数量) 总单
from `用户行为表`
where 日期 between '2024-01-01' and '2024-12-13'
group by id
),
t3 as (
select 
渠道,a.id,总额,总单,总额/总单 客单价
from t a inner join t2 b on a.id=b.id
),
t4 as(
select
渠道,avg(客单价) 日均客单价
from t3 group by 渠道
)
select 渠道,日均客单价,rank() over(order by 日均客单价 desc) 日均订单排名 from t4 order by 日均客单价 desc;




select 渠道,sum(行为) 量级,sum(行为)/sum(注册) 转化率
from `渠道行为表`
group by 渠道 
order by sum(行为)/sum(注册) desc;

with t as(
select
渠道,行为,行为/注册 转化率
from `渠道行为表`

)
select 渠道,sum(行为) 量级,avg(转化率) 转化率 from t GROUP BY 渠道 order by 3 desc;



SELECT
  渠道,
  count(id) 量级,
  sum(CASE WHEN 次日回访 = 0 THEN 1 END) 次日量级,
  sum(CASE WHEN 次日回访 = 0 THEN 1 END) / count(id) 次日回访率,
  sum(CASE WHEN 3日回访 = 0 THEN 1 END) 3日量级,
  sum(CASE WHEN 次日回访 = 0 THEN 1 END) / count(id) 3日回访率,
  sum(CASE WHEN 7日回访 = 0 THEN 1 END) 7日量级,
  sum(CASE WHEN 7日回访 = 0 THEN 1 END) / count(id) 7日回访率
FROM
  `用户回访表`
GROUP BY
  渠道;


select 渠道,count(id) 量级,
sum(CASE WHEN 会员 = 0 THEN 1 END) 会员数,
sum(CASE WHEN 会员 = 0 THEN 1 END)/count(id) 会员率
from `用户状态表`
GROUP BY 渠道;

with t as(
SELECT
渠道,
sum(花费) 总花费,rank() over(order by sum(花费) desc) 花费排名
from `渠道花费表` GROUP BY 渠道),
t2 as(
SELECT
渠道,sum(`曝光`) 总曝光,
sum(注册) 总注册,rank() over(order by sum(注册) desc) 注册量排名
from `渠道行为表` GROUP BY 渠道),
t3 as(
select
a.`渠道`,
总花费/总注册 成本
from 
(SELECT
渠道,
sum(花费) 总花费
from `渠道花费表` GROUP BY 渠道) a,
(
SELECT
渠道,
sum(注册) 总注册
from `渠道行为表` GROUP BY 渠道) b
where a.`渠道`=b.`渠道`),
t4 as (
select 渠道,成本,rank() over(order by 成本 asc ) 成本排名 from t3
),
t5 as (
select 渠道,总注册/总曝光,rank() over(order by 总注册/总曝光 desc ) 注册转化率排名 from 
t2 
),
t6 as (
SELECT
sum(花费) 所有花费
from `渠道花费表`
),
t7 as (
SELECT
sum(注册) 所有注册
from `渠道行为表`
),
t8 as (
select a.渠道,总花费,总注册 from 
(SELECT
渠道,
sum(花费) 总花费
from `渠道花费表` GROUP BY 渠道) a,
(
SELECT
渠道,
sum(注册) 总注册
from `渠道行为表` GROUP BY 渠道) b
where a.`渠道`=b.`渠道`
),
t9 as (
select 渠道,总花费/所有花费 花费占比,总注册/所有注册 注册占比 from t6,t7,t8
),
t10 as (
select 渠道,注册占比/花费占比 回报率,rank() over(order by 注册占比/花费占比 desc ) 回报率排名 from t9
),
t11 as (select p1.渠道,花费排名,注册量排名,成本排名,注册转化率排名,回报率排名,
(花费排名+注册量排名+成本排名+注册转化率排名+回报率排名) 综合排名
from t p1,t2 p2,t4 p4,t5 p5,t10 p10
where p1.渠道=p2.渠道 and p2.渠道=p4.渠道 and p4.渠道=p5.渠道 and p5.渠道=p10.渠道)
select 渠道,花费排名,注册量排名,成本排名,注册转化率排名,回报率排名,综合排名,
rank() over(order by 综合排名) 核心指标综合排名
from t11


WITH monthly_cpa AS (
    SELECT 
        渠道,
        YEAR(日期) AS year,
        MONTH(日期) AS month,
        SUM(花费) AS total_spend,
        SUM(注册) AS total_registrations,
        SUM(花费) / SUM(注册) AS cpa
    FROM 成本
    WHERE YEAR(日期) = 2019
    GROUP BY 渠道, YEAR(日期), MONTH(日期)
    HAVING total_registrations > 0
),

month_sequence AS (
    SELECT *,
        (year - 2019) * 12 + month AS month_num
    FROM monthly_cpa
),
-- 3. 相当于计算x ,y的平均值  (x月份序号的均值,y为cpa的均值)
month_sequence_with_avg AS (
    SELECT 
        渠道,
        month_num,
        cpa,
        AVG(month_num) OVER (PARTITION BY 渠道) AS avg_month_num,
        AVG(cpa) OVER (PARTITION BY 渠道) AS avg_cpa
    FROM month_sequence
),
-- 4. 计算斜率和截距
regression_params AS (
    SELECT 
        渠道,
        MAX(avg_cpa) AS avg_cpa,
        MAX(avg_month_num) AS avg_x,
        -- 计算斜率
        SUM((month_num - avg_month_num) * (cpa - avg_cpa)) / 
        SUM(POWER(month_num - avg_month_num, 2)) AS slope,
        -- 计算截距
        MAX(avg_cpa) - 
        (SUM((month_num - avg_month_num) * (cpa - avg_cpa)) / 
         SUM(POWER(month_num - avg_month_num, 2))) * 
        MAX(avg_month_num) AS intercept
    FROM month_sequence_with_avg
    GROUP BY 渠道
)

SELECT 
    渠道,
    ROUND(intercept + slope * 23, 2) AS predicted_cpa_nov_2024,
    slope AS monthly_trend  -- 正值表示每月成本上升，负值表示下降
FROM regression_params
ORDER BY 渠道;

-- 1. 首先计算2019年各月注册人数（reg）
WITH monthly_reg AS (
    SELECT 
        渠道,
        YEAR(日期) AS year,
        MONTH(日期) AS month,
        SUM(注册) AS total_registrations
    FROM 成本
    WHERE YEAR(日期) = 2019
    GROUP BY 渠道, YEAR(日期), MONTH(日期)
    HAVING total_registrations > 0
),

month_sequence AS (
    SELECT *,
        (year - 2019) * 12 + month AS month_num
    FROM monthly_reg
),
-- 3. 相当于计算x ,y的平均值  (x月份序号的均值,y为cpa的均值)
month_sequence_with_avg AS (
    SELECT 
        渠道,
        month_num,
                                total_registrations,
        AVG(month_num) OVER (PARTITION BY 渠道) AS avg_month_num,
        AVG(total_registrations) OVER (PARTITION BY 渠道) AS avg_reg
    FROM month_sequence
),
-- 4. 计算斜率和截距
regression_params AS (
    SELECT 
        渠道,
        MAX(avg_reg) AS avg_reg,
        MAX(avg_month_num) AS avg_x,
        -- 计算斜率
        SUM((month_num - avg_month_num) * (total_registrations - avg_reg)) / 
        SUM(POWER(month_num - avg_month_num, 2)) AS slope,
        -- 计算截距
        MAX(avg_reg) - 
        (SUM((month_num - avg_month_num) * (total_registrations - avg_reg)) / 
         SUM(POWER(month_num - avg_month_num, 2))) * 
        MAX(avg_month_num) AS intercept
    FROM month_sequence_with_avg
    GROUP BY 渠道
)

SELECT 
    渠道,
    ROUND(intercept + slope * 23, 0) AS predicted_reg_nov_2020,
    slope AS monthly_trend  -- 正值表示每月成本上升，负值表示下降
FROM regression_params
ORDER BY 渠道;
