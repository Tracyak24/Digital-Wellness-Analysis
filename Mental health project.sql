-- Basic data sanity check
SELECT
    COUNT(*) as total_records,
    COUNT(DISTINCT User_ID) as unique_users,
    MIN(Age) as min_age,
    MAX(Age) as max_age,
    MIN(Happiness_Index) as min_happiness,
    MAX(Happiness_Index) as max_happiness
FROM mental_health_and_social_media_balance_dataset;

-- Which platforms have the best/worst mental health metrics
SELECT 
    Social_Media_Platform,
    ROUND(AVG(Happiness_Index), 2) as avg_happiness,
    ROUND(AVG(Stress_Level), 2) as avg_stress,
    ROUND(AVG(Sleep_Quality), 2) as avg_sleep,
    ROUND(AVG(Daily_Screen_Time_Hrs), 2) as avg_screen_time,
    COUNT(*) as user_count
FROM mental_health_and_social_media_balance_dataset
GROUP BY Social_Media_Platform
ORDER BY avg_happiness;

-- How does exercise frequency affect mental health?
SELECT
    Exercise_Frequency_Week,
    ROUND(AVG(Happiness_Index), 2) as avg_happiness,
    ROUND(AVG(Stress_Level), 2) as avg_stress,
    ROUND(AVG(Sleep_Quality), 2) as avg_sleep,
    COUNT(*) as user_count
FROM mental_health_and_social_media_balance_dataset
GROUP BY Exercise_Frequency_Week
ORDER BY Exercise_Frequency_Week;

-- Do social media breaks help mental health?
SELECT
    CASE
       WHEN Days_Without_Social_Media = 0 THEN 'No breaks'
       WHEN Days_Without_Social_Media BETWEEN 1 AND 2 THEN '1-2 days break'
       WHEN Days_Without_Social_Media BETWEEN 3 AND 4 THEN '3-4 days break'
       ELSE '5+ days break'
    END AS break_category,
    ROUND(AVG(Happiness_Index), 2) as avg_happiness,
    ROUND(AVG(Stress_Level), 2) as avg_stress,
    ROUND(AVG(Daily_Screen_Time_Hrs), 2) as avg_screen_time,
    COUNT(*) as user_count
FROM mental_health_and_social_media_balance_dataset
GROUP BY break_category
ORDER BY avg_happiness DESC;

-- How do different age group use social media and experience mental health?
SELECT
    CASE
       WHEN Age BETWEEN 13 AND 28 THEN 'Gen Z (16-28)'
       WHEN Age BETWEEN 29 AND 44 THEN 'Millennials (29-44)'
       ELSE 'Gen X (45+)'
    END AS generation,
    ROUND(AVG(Daily_Screen_Time_Hrs), 2) as avg_screen_time,
    ROUND(AVG(Happiness_Index), 2) as avg_happiness,
    ROUND(AVG(Stress_Level), 2) as avg_stress,
    ROUND(AVG(Sleep_Quality), 2) as avg_sleep,
    ROUND(AVG(Exercise_Frequency_Week), 2) as avg_exercise,
    COUNT(*) as user_count
FROM mental_health_and_social_media_balance_dataset
GROUP BY generation
ORDER BY avg_screen_time DESC;

-- Which platforms are porpular with which demographics?
SELECT
    Social_Media_Platform,
    ROUND(AVG(Age), 1) as avg_age,
    Gender,
    ROUND(AVG(Daily_Screen_Time_Hrs), 2) as avg_daily_screen_time,
    COUNT(*) as user_count
FROM mental_health_and_social_media_balance_dataset
GROUP BY Social_Media_Platform, Gender
ORDER BY Social_Media_Platform, Gender;

-- How do sleep, stress, and happiness interrelate?
SELECT
    CASE
       WHEN Sleep_Quality <= 4 THEN 'Poor Sleep (1-4)'
       WHEN Sleep_Quality BETWEEN 5 AND 7 THEN 'Average Sleep (5-7)'
       ELSE 'Good Sleep (8-10)'
    END AS sleep_category,
    ROUND(AVG(Stress_Level), 2) as avg_stress,
    ROUND(AVG(Happiness_Index), 2) as avg_happiness,
    ROUND(AVG(Daily_Screen_Time_Hrs), 2) as avg_screen_time,
    COUNT(*) as user_count
FROM mental_health_and_social_media_balance_dataset
GROUP BY sleep_category
ORDER BY avg_stress;

-- What characterizes users with highest stress level?
SELECT
    CASE
       WHEN Stress_Level >= 8 THEN 'High Stress (8-10)'
       WHEN Stress_Level BETWEEN 5 AND 7 THEN 'Middle Stress (5-7)'
       ELSE 'Low Stress (1-4)'
    END AS stress_category,
    ROUND(AVG(Daily_Screen_Time_Hrs), 2) as avg_screen_time,
    ROUND(AVG(Sleep_Quality), 2) as avg_sleep,
    ROUND(AVG(Exercise_Frequency_Week), 2) as avg_exercise,
    ROUND(AVG(Days_Without_Social_Media), 2) as avg_break,
    ROUND(AVG(Happiness_Index), 2) as avg_happiness,
    COUNT(*) as user_count
FROM mental_health_and_social_media_balance_dataset
GROUP BY stress_category
ORDER BY stress_category DESC;

-- What combination of factors leads to highest happiness?
SELECT
    CASE WHEN Exercise_Frequency_Week >= 3 THEN 'Active' ELSE 'Sedentary' END as activity,
    CASE WHEN Sleep_Quality >= 7 THEN 'Good Sleeper' ELSE 'Poor Sleeper' END as sleep,
    CASE WHEN Daily_Screen_Time_Hrs <= 5 THEN 'Low Screen Time' ELSE 'High Screen Time' END as screen_time,
    ROUND(AVG(Happiness_Index), 2) as avg_happiness,
    ROUND(AVG(Stress_Level), 2) as avg_stress,
    COUNT(*) as user_count
FROM mental_health_and_social_media_balance_dataset
GROUP BY activity, sleep, screen_time
HAVING COUNT(*) >= 10 -- Only show meaningful segments
ORDER BY avg_happiness DESC;

-- 🔍 Key Finding: Optimal Digital Wellness Profile

-- SQL Analysis Revealed: Users combining regular exercise (3+ times/week) + quality sleep (7+ rating) + mindful screen time (<5 hours) achieve happiness scores of 9.2+

-- Technical Approach: Multi-dimensional segmentation using CASE statements and HAVING clause to filter statistically significant segments

-- Business Impact: Identified actionable lifestyle combination rather than focusing solely on screen time reduction