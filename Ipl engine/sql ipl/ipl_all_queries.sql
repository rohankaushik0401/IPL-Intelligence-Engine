use ipl; 


-- Project--


-- 1. False strike rate --

select fal.batter,round(false_st,2) as st_wo_bdry,round(strike_rate,2) as strike_r,100-(bal/ba)*100 as bdry_percent from 
(select batter ,sum(runs_batter)*100/count(ball) false_st,sum(runs_batter) bal from ipl where runs_batter<4 group by batter) as fal join
(select batter, sum(runs_batter)*100/count(ball) strike_rate ,sum(runs_batter) ba from ipl group by batter) 
as career on fal.batter=career.batter;


-- 2. Run rate by phases of successfull chases or 200 + sets--

select round(avg(por),2)  powerplay_rr ,round(avg(mi),2) middle_rr, round(avg(de),2) death_rr ,batting_team as team from
(select batting_team,match_id,match_won_by,sum(runs_total) runs,innings,
round(sum(case when `over`<6 then runs_total else 0 end)/((count(case when `over`<6 and valid_ball=1 then ball end))/6),2) as por,
round(sum(case when `over`>=6 and `over`<15 then runs_total else 0 end)/
((count(case when `over`>=6 and `over`<15 and valid_ball=1 then ball end))/6),2)as mi,
round(sum(case when `over`>=15 then runs_total else 0 end)/((count(case when `over`>=15 and valid_ball=1 then ball end))/6),2) as de
from ipl group by batting_team,match_id,match_won_by,innings) as bb where (innings=2 and batting_team = match_won_by) or  
(innings=1 and runs>200) group by batting_team;


-- 3. Each teams nemesis--

select tb1.bowling_team,tb1.batter,tb1.runs,tb2.bowler,tb2.wickets from(
select bowling_team,batter,sum(runs_batter) as runs,
rank() over(partition by bowling_team order by sum(runs_batter) desc) as rn
from ipl group by bowling_team,batter) as tb1 join(
select batting_team,bowler,sum(bowler_wicket) as wickets,
rank() over(partition by batting_team order by sum(bowler_wicket) desc) as rn from ipl
group by batting_team,bowler) as tb2 on tb1.bowling_team=tb2.batting_team
where tb1.rn=1 and tb2.rn=1;


-- 4. Chase collapse analysis --

select wickets_lost,
round(sum(case when batting_team=match_won_by then 1 else 0 end)*100/count(*),2) as win_percentage from(
select match_id,innings,batting_team,match_won_by,max(team_wicket) as wickets_lost
from ipl where `over`<6 and innings=2
group by match_id,innings,batting_team,match_won_by,venue) as nul
group by wickets_lost
order by wickets_lost;


-- 5. Dot ball % and strike rate of batsman in powerplay --

select batter,round(sum(runs_batter)*100/count(ball),2) as strike_rate,
round(sum(case when runs_batter=0 then 1 else 0 end)*100/count(ball),2) as dot_ball_percentage,
sum(runs_batter) as runs from ipl where `over`<6 and valid_ball=1
group by batter order by runs desc;


-- 6. Rolling Form analysis --

select sum(runss) runs, avg(runss) as rolling_average ,batter from
(select batter,match_id,sum(runs_batter) as runss ,
rank() over(partition by batter order by match_id desc) roll
from ipl group by batter,match_id) as tb where roll<6 group by batter order by rolling_average desc;


-- 7. Pressure performance when required rr >10 --

select batter,sum(runs_batter) as runs,rank() over(order by sum(runs_batter)desc) as `rank` 
from ipl where innings=2 and (runs_target-team_runs)/((120-team_balls)/6)>10 group by batter;


-- 8. Momentum shift analysis --

select momentum,abs(momentum-lag(momentum)over()) as moment_shift ,`over` from
(select `over`, sum(case when runs_batter =6 then 6
            when runs_batter =4 then 4
            when runs_bowler =0 then -1
            when bowler_wicket=1 then -10
            else 0
            end )as momentum from ipl group by `over`) as nu;


-- 9. Impact of powerplay runs on win% --

select powerplay_runs,round(sum(case when batting_team=match_won_by then 1 else 0 end)*100/count(*),2) as win_percentage
from(select sum(runs_total) as pp_runs,match_id,innings,batting_team,match_won_by,venue,
case when sum(runs_total)<30 then '<30'
     when sum(runs_total) between 30 and 60 then '30-60'
     when sum(runs_total) between 60 and 80 then '60-80'
	else '>80'
	end as powerplay_runs from ipl where `over`<6 group by match_id,innings,batting_team,match_won_by,venue) as nul
group by powerplay_runs order by win_percentage desc;


-- 10. Death stats compared to career stats --

select career.bowler,career.economy as career_economy,death.economy as death_economy,career.strike_rate as career_strike_rate,
death.strike_rate as death_strike_rate,round(death.economy-career.economy,2) as economy_change,
round(death.strike_rate-career.strike_rate,2) as strike_rate_change from(
select bowler,round(sum(runs_bowler)/(count(case when valid_ball=1 then ball end)/6),2) as economy,
round(count(case when valid_ball=1 then ball end)/nullif(sum(bowler_wicket),0),2) as strike_rate
from ipl group by bowler having sum(bowler_wicket)>20) as career 
join(select bowler,round(sum(runs_bowler)/(count(case when valid_ball=1 then ball end)/6),2) as economy,
round(count(case when valid_ball=1 then ball end)/nullif(sum(bowler_wicket),0),2) as strike_rate from ipl
where `over`>=16 group by bowler having sum(bowler_wicket)>10) as death
on career.bowler=death.bowler order by economy_change;


-- 11. Batsman Classification --

with innings_stats as (
select
match_id,
batter,
sum(runs_batter) as runs,
count(*) as balls
from ipl
where bat_pos < 7
group by match_id,batter
),
player_stats as (
select
batter,
count(*) as innings,
round(stddev(runs),1) as stdev,
round(sum(runs)*100.0/sum(balls),2) as strike_rate,
round(avg(runs),2) as average
from innings_stats
group by batter
having count(*) >= 20
),
benchmarks as (
select
avg(stdev) as avg_stdev,
avg(strike_rate) as avg_sr,
avg(average) as avg_avg
from player_stats
)
select
p.batter,
p.innings,
p.average,
p.strike_rate,
p.stdev,
case
when p.stdev > b.avg_stdev and p.strike_rate > b.avg_sr and p.average > b.avg_avg then 'double geared'
when p.stdev < b.avg_stdev and p.strike_rate > b.avg_sr and p.average > b.avg_avg then 'elite'
when p.stdev > b.avg_stdev and p.strike_rate < b.avg_sr and p.average > b.avg_avg then 'anchor'
when p.stdev < b.avg_stdev and p.strike_rate < b.avg_sr and p.average > b.avg_avg then 'accumulator'
when p.stdev < b.avg_stdev and p.strike_rate > b.avg_sr and p.average < b.avg_avg then 'measured hitter'
when p.stdev > b.avg_stdev and p.strike_rate > b.avg_sr and p.average < b.avg_avg then 'slogger'
when p.stdev > b.avg_stdev and p.strike_rate < b.avg_sr and p.average < b.avg_avg then 'poor'
else 'poor'
end as class
from player_stats p
cross join benchmarks b
order by average desc;


-- 12. Bowler Classification --

with bowler_stats as (
select
match_id,
bowler,
sum(runs_bowler) as runs,
sum(bowler_wicket) as wickets,
count(ball) as balls
from ipl
where valid_ball = 1
group by match_id,bowler
),
player_stats as (
select
bowler,
count(*) as innings,
sum(runs) as runs_conceded,
sum(wickets) as wickets,
sum(balls) as balls_bowled,
round(sum(runs)/(sum(balls)/6),2) as economy,
round(sum(balls)/sum(wickets),2) as strike_rate,
round(sum(runs)/sum(wickets),2) as average
from bowler_stats
group by bowler
having count(*) >= 20
and sum(wickets) > 0
),
benchmarks as (
select
avg(economy) as avg_eco,
avg(strike_rate) as avg_sr,
avg(average) as avg_avg
from player_stats
)
select
p.bowler,
p.innings,
p.wickets,
p.average,
p.strike_rate,
p.economy,
case
when p.economy > b.avg_eco and p.strike_rate > b.avg_sr and p.average > b.avg_avg then 'bad'
when p.economy < b.avg_eco and p.strike_rate > b.avg_sr and p.average > b.avg_avg then 'economist'
when p.economy > b.avg_eco and p.strike_rate < b.avg_sr and p.average > b.avg_avg then 'expensive wicket taker'
when p.economy < b.avg_eco and p.strike_rate < b.avg_sr and p.average > b.avg_avg then 'wicket specialist'
when p.economy < b.avg_eco and p.strike_rate > b.avg_sr and p.average < b.avg_avg then 'Choker'
when p.economy > b.avg_eco and p.strike_rate > b.avg_sr and p.average < b.avg_avg then 'expensive wicket taker'
when p.economy > b.avg_eco and p.strike_rate < b.avg_sr and p.average < b.avg_avg then 'runs-wickets trader'
else 'elite'
end as class
from player_stats p
cross join benchmarks b
order by wickets desc;


-- 13. Matchup analysis --

select runs.batter,ut.bowler, runs,outs,runs/outs average, runs*100/ball Strike_rate,innings 
from((select batter,bowler,sum(runs_batter) runs,count(ball) ball ,count(distinct match_id) innings 
from ipl group by batter,bowler) as runs join
(select bowler, batter,count(ball) outs from ipl where bowler_wicket=1 group by batter,bowler) as ut on ut.batter=runs.batter) 
where runs.bowler=ut.bowler order by innings desc;


-- 14. Match Control Index


select match_id,innings,batting_team,match_won_by, powerplay_runs,powerplay_wickets,
        case when max(powerplay_runs) over(partition by match_id) >powerplay_runs then 'lost' else'won'end as powerplay_control,
        middle_runs,middle_wickets, 
        case when max(middle_runs) over(partition by match_id) >middle_runs then 'lost' else'won'end as middle_control,
        death_runs,death_wickets, 
        case when max(death_runs) over(partition by match_id) >death_runs then 'lost' else'won'end as death_control
 from
(select match_id,innings,batting_team,match_won_by,
sum(case when `over` < 6 then runs_total else 0 end) as powerplay_runs,
sum(case when `over`<6 then bowler_wicket else 0 end) as powerplay_wickets,
sum(case when `over`>=6 and `over`<  15 then runs_total else 0 end) as middle_runs,
sum(case when `over`>=6 and `over`< 15  then bowler_wicket else 0 end) as middle_wickets,
sum(case when `over` >= 15 then runs_total else 0 end) as death_runs,
sum(case when `over`>=15 then bowler_wicket else 0 end) as death_wickets from ipl
 group by match_id,innings,batting_team,match_won_by) as perf ;
 


-- 15. Defendable Target by Venue --

select avg(target_defended) as defendable_total,venue from
(select distinct match_id,venue,sum(runs_total) as target_defended
from ipl where innings = 1 and batting_team=match_won_by group by venue,match_id) as tb2 
group by venue order by defendable_total;


-- 16. % conversion of starts --

select batter,
       sum(case when runs<25 then 1 else 0 end) as no_start,
       sum(case when runs between 25 and 50 then 1 else 0 end) as failed_conversion,
       sum(case when runs>50 then 1 else 0 end) as converted,
       round(
       100.0*sum(case when runs >50 then 1 else 0 end)/
       nullif(
       (sum(case when runs between 25 and 50 then 1 else 0 end)+
        sum(case when runs>50 then 1 else 0 end)),0)
       ,2) as start_conversion_percentage
from(
select batter,sum(runs_batter) as runs,match_id from ipl group by batter,match_id) as nul
group by batter order by start_conversion_percentage desc;


-- 17. Dependency on one player per season --

select round(runs*100/run,2) percencetage_dependency,top.batter,tot.batting_team,tot.season from 
(select sum(runs_batter) run, batting_team,season from ipl group by batting_team, season) as tot
join (select runs,batter,season,batting_team from 
(select sum(runs_batter) runs,batter,season,batting_team,rank() over(partition by season,batting_team order by sum(runs_batter) desc) rnk
from ipl group by season,batter,batting_team) as nul where rnk=1) as top on top.batting_team=tot.batting_team and tot.season=top.season  
where top.season!=2026 order by percencetage_dependency desc;


-- 18. Champion team analysis --

select * from(
select batting_team as team, batting.season,runs_scored,bat_rr,highest_score,boundries,runs_conceded,bowl_rr,
  wickets,wins from((select bnd.batting_team,bnd.season,runs_scored,bat_rr,highest_score,boundries,bat_rank from
(select batting_team,season,count(ball) boundries from ipl where runs_batter>3 group by batting_team,season) as bnd join
(select batting_team,season,sum(runs_total) runs_scored,
sum(runs_total)/(count(ball)/6) bat_rr,max(team_runs) as highest_score,
rank() over(partition by season order by sum(runs_total) desc) bat_rank
from ipl group by batting_team,season) as bat on bat.batting_team=bnd.batting_team and bat.season=bnd.season) as batting join 
(select bal.bowling_team,bal.season,runs_conceded,bowl_rr,wickets,wins,lowest_total from
(select bowling_team,season,sum(runs_total) runs_conceded,sum(runs_total)/(count(ball)/6) as bowl_rr,sum(bowler_wicket) as wickets,
min(runs_total) as lowest_total from ipl group by bowling_team,season) as bal join (select bowling_team,season, 
count(distinct match_id) wins from ipl where match_won_by=bowling_team group by bowling_team,season) as bow
on bow.season=bal.season and bow.bowling_team=bal.bowling_team) as bowling on batting.season=bowling.season)
where batting_team=bowling_team order by batting.season) as stats join
(select match_won_by champions,season from ipl where stage='Final' group by season,match_won_by) as champ on stats.season=champ.season 
where team = champions order by champ.season;
