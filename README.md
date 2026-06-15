# 🏏 IPL Intelligence Engine

### End-to-End Cricket Analytics, Statistical Modeling & Machine Learning Framework

![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-yellow)
![Python](https://img.shields.io/badge/Python-Analytics-green)
![Machine Learning](https://img.shields.io/badge/MachineLearning-RandomForest-red)

---

## 📌 Project Overview

The IPL Intelligence Engine is an end-to-end sports analytics project built using IPL ball-by-ball data (2008–2025).

The project moves beyond traditional cricket statistics by combining:

* Advanced SQL Analytics
* Statistical Hypothesis Testing
* Interactive Power BI Dashboards
* Machine Learning Models

to identify the factors that drive success in T20 cricket.

The objective was not simply to report historical performance but to create a decision-support framework capable of evaluating players, teams, venues and match situations.

---

## 🎯 Business Questions

This project was designed around five core questions:

### Batting Intelligence

* Which batters genuinely rotate strike?
* Which players convert starts into match-winning innings?
* Which batters perform best under pressure?

### Bowling Intelligence

* Which bowlers maintain performance in death overs?
* Which bowlers trade economy for wickets?
* Which bowlers consistently create pressure?

### Team Intelligence

* Which teams are overly dependent on individual players?
* What separates IPL champions from the rest?

### Venue Intelligence

* What constitutes a defendable score at each venue?
* Which venues favour chasing?

### Predictive Intelligence

* Can match outcomes be predicted?
* What score should a team expect after a given powerplay?

---

# 🏗 Project Architecture

IPL Dataset

⬇

SQL Analytics Layer

⬇

Statistical Validation

⬇

Power BI Dashboard

⬇

Machine Learning Models

⬇

Expected Score Intelligence Engine

---

# 📊 SQL Analytics Layer

A total of **18 advanced SQL analytical modules** were developed.

---

## 1. False Strike Rate Analysis

Purpose:

Evaluate strike rate after removing boundary contributions.

Insight:

Identifies batters who rely heavily on boundaries versus strike rotation.

---

## 2. Run Rate Structure of Successful Innings

Purpose:

Compare powerplay, middle-over and death-over scoring rates in:

* Successful chases
* 200+ first innings totals

Insight:

Death-over acceleration is a key characteristic of successful innings.

---

## 3. Team Nemesis Analysis

Purpose:

Identify:

* Batter scoring most runs against a team
* Bowler taking most wickets against a team

Insight:

Reveals long-term player-team dominance patterns.

---

## 4. Chase Collapse Analysis

Purpose:

Measure win percentage by powerplay wickets lost during a chase.

Insight:

Early wickets significantly reduce chase success probability.

---

## 5. Powerplay Efficiency Analysis

Metrics:

* Strike Rate
* Dot Ball %
* Runs Scored

Insight:

Lower dot-ball percentages correlate with stronger batting performances.

---

## 6. Rolling Form Analysis

Purpose:

Calculate rolling five-match averages.

Insight:

Recent form is often a better indicator than career averages.

---

## 7. Pressure Performance Analysis

Condition:

Required Run Rate > 10

Insight:

Identifies elite finishers who perform under extreme pressure.

---

## 8. Momentum Shift Analysis

Custom momentum metric based on:

* Boundaries
* Dot Balls
* Wickets

Insight:

Wickets generate larger momentum shifts than boundaries.

---

## 9. Powerplay Impact on Winning

Purpose:

Analyze win percentage by powerplay scoring brackets.

Insight:

Higher powerplay scores improve win probability but do not guarantee victory.

---

## 10. Death Overs Bowling Analysis

Purpose:

Compare:

* Career Economy vs Death Economy
* Career Strike Rate vs Death Strike Rate

Insight:

Death bowling is significantly more difficult than other phases.

---

## 11. Batter Classification Engine

Custom categories:

* Elite
* Anchor
* Accumulator
* Double Geared
* Measured Hitter
* Slogger

Metrics:

* Average
* Strike Rate
* Consistency

---

## 12. Bowler Classification Engine

Custom categories:

* Elite
* Economist
* Wicket Specialist
* Pressure Applier
* Expensive Wicket Taker

Metrics:

* Economy
* Strike Rate
* Average

---

## 13. Batter vs Bowler Matchup Analysis

Purpose:

Head-to-head performance tracking.

Metrics:

* Runs
* Outs
* Strike Rate
* Average

---

## 14. Match Control Index

Phase-wise tracking of:

* Runs
* Wickets

for:

* Powerplay
* Middle Overs
* Death Overs

Insight:

Winning teams typically dominate at least two phases.

---

## 15. Defendable Target by Venue

Purpose:

Calculate average defended totals.

Insight:

Defendable scores vary significantly across venues.

---

## 16. Start Conversion Analysis

Purpose:

Measure ability to convert starts into major scores.

Insight:

Conversion rate is a stronger quality indicator than batting average alone.

---

## 17. Team Dependency Analysis

Purpose:

Measure seasonal dependence on a team's highest run scorer.

Insight:

Higher dependency often leads to greater performance volatility.

---

## 18. Championship Team Analysis

Purpose:

Identify characteristics shared by IPL-winning teams.

Insight:

Champions display balanced batting and bowling performance rather than reliance on individual stars.

---

# 📈 Statistical Validation

## Correlation Analysis

Powerplay Runs vs Final Score

Correlation Coefficient:

r = 0.559

Interpretation:

Moderate positive relationship.

---

## Chi-Square Test

Toss Result vs Match Result

p-value < 0.001

Interpretation:

Statistically significant association.

---

## ANOVA

Venue vs Scoring Behaviour

Result:

Statistically significant differences between venues.

---

# 📊 Power BI Dashboard

Dashboard Pages:

1. Match Overview
2. Batting Intelligence
3. Bowling Intelligence
4. Venue Strategy
5. Team Intelligence
6. Championship Insights
7. Predictive Analysis

### Key Dashboard Features

* Classification Scatter Plots
* Venue Archetype Analysis
* Match Control Tracking
* Dependency Analysis
* Momentum Analysis
* Champion Team Benchmarking
* Predictive Score Engine
* Interactive slicers

---

# 🤖 Machine Learning

## Match Outcome Prediction

Target:

Win / Loss

Features:

* Powerplay Runs
* Powerplay Wickets
* Middle Runs
* Middle Wickets
* Death Runs
* Death Wickets

### Model Performance

| Model               | Accuracy |
| ------------------- | -------- |
| Logistic Regression | 71%      |
| Random Forest       | 72%      |
| XGBoost             | 70%      |

Best Model:

✅ Random Forest

---

# 🔮 Expected Score Intelligence Engine

Inputs:

* Venue
* Powerplay Runs
* Powerplay Wickets

Output:

Expected Final Score

Performance Above Expectation:

PAE = Actual Score − Expected Score

Applications:

* Detect batting overperformance
* Identify collapses
* Venue-adjusted performance evaluation

---

# 🔍 Key Findings

### Finding 1

Death overs are the strongest differentiator of match outcomes.

### Finding 2

Wickets create larger momentum shifts than boundaries.

### Finding 3

Championship teams exhibit balanced batting and bowling profiles.

### Finding 4

Powerplay scoring explains a meaningful portion of final score variation (r = 0.559).

### Finding 5

Match outcomes can be predicted with approximately 70–72% accuracy.

---

# 🚀 Future Scope

* Live Win Probability Model
* Player Valuation Framework
* Auction Recommendation Engine
* Fantasy Cricket Optimization
* SHAP-Based Model Explainability

---

# 👨‍💻 Author

**Rohan Kaushik**

Data Analytics | Sports Analytics | Machine Learning

This project demonstrates end-to-end analytics capability across SQL, Statistics, Power BI and Machine Learning.


---

## Dashboard Preview
<img width="1102" height="618" alt="Screenshot 2026-06-10 134352" src="https://github.com/user-attachments/assets/832aaa01-1c86-4864-86eb-546df99218f2" />

<img width="1110" height="610" alt="Screenshot 2026-06-10 134410" src="https://github.com/user-attachments/assets/4461589b-7b7d-4a52-9cc4-3c4d68bee194" />

<img width="1087" height="609" alt="Screenshot 2026-06-10 134425" src="https://github.com/user-attachments/assets/82a9cd83-6a1d-433b-85a3-1f617adfdeb2" />

<img width="1098" height="603" alt="Screenshot 2026-06-10 134442" src="https://github.com/user-attachments/assets/f22d6884-97f2-473b-805d-dbfafaf23c98" />

<img width="1088" height="616" alt="Screenshot 2026-06-10 134500" src="https://github.com/user-attachments/assets/ebf2934d-27a3-442c-9ad6-528a6688504e" />

<img width="1145" height="641" alt="Screenshot 2026-06-12 160346" src="https://github.com/user-attachments/assets/1c9ff44a-7d9e-435e-95bd-0b56d1e73267" />


<img width="1146" height="644" alt="Screenshot 2026-06-12 141627" src="https://github.com/user-attachments/assets/22c7122f-5f7c-4ff9-9b76-a31df2b06848" />


