
## 💡 Lab Link: [Connected Sheets: Qwik Start - GSP870](https://www.cloudskillsboost.google/focuses/18109?parent=catalog)

## 🚀 Lab Solution [Watch Here](https://www.youtube.com/@techcps)

---

## 🚀 In a new incognito window, open the [Google Sheets home page](https://docs.google.com/spreadsheets/)

---

## 🚨 Task 2. Connect to a BigQuery dataset

1. Select **Data** > **Data Connectors** > **Connect to BigQuery**
2. Select **YOUR PROJECT ID** > **Public datasets** > **chicago_taxi_trips** > **taxi_trips** and click **Connect**

---

## 🚨 Task 3. Formulas
1. Select **Function** > **COUNTUNIQUE** and add it to a **new sheet**

2. **row 1**, **column A** to this:
```
=COUNTUNIQUE(taxi_trips!company)
```
3. Click **Apply**

4. **row1**, **column D**
```
=COUNTIF(taxi_trips!tips,">0")
```
4. Click **Apply**

5. **row1**, **column E**:
```
=COUNTIF(taxi_trips!fare,">0")
```
6. Click **Apply**

7. **row1**, **column F**
```
=D1/E1
```
---

## 🚨 Task 4. Charts

1. Return to the **taxi_trips** tab Click **Chart** button. Ensure **New Sheet** > **Create**

2. Under **Chart** type, select **Pie chart**

3. **Label field** > **payment_type** Then **Value field** > **fare**

4. Under **Value** > **Fare**, change **Sum** to **Count** Click **Apply**

---

1. Return to the **taxi_trips** tab Click **Chart** button. Ensure **New Sheet** > **Create**

2. Click on the **Chart Type** select **Line**

3. **X-axis field** > **trip_start_timestamp** then **Group** > **Year-Month** and **Series field** > **fare**

4. Under **Filter** click Add > **payment_type** and Select the **Showing all items**

5. Click on the **Filter by Condition** select **Text contains** from the list

6. In the **Value field** type **mobile** click **ok** then **Apply**

---

## 🚨 Task 5. Pivot tables
1. Return to the **taxi_trips** tab Click **Pivot table** button. Ensure **New Sheet** > **Create** 

2. In the **Rows field** > **trip_start_timestamp** and  **Hour** for the **Group By option**

3. **Values field** > **fare** and Select **COUNTA** for the **Summarize by option**

4. **Columns field** > **trip_start_timestamp** and Select **Day of the week** under the **Group by option**

5. Click **Apply**

---

1. select **Format** > **Number** > **Number** select all **(first value for Sunday)** to **(last value for Saturday)**

2. click **Format** > **Conditional formatting** Select **Color scale** under **Preview** and choose **White to Green** Done

---

## 🚨 Task 6. Using Extract
1. Return to the **taxi_trips** tab Click **Extract** button. Ensure **New Sheet** > **Create** 

2. In the **Extract editor** window, click Edit under the **Columns section** and select the **columns trip_start_timestamp**, **fare**, **tips**, and **tolls**

3. Click Add under the **Sort** > select **trip_start_timestamp**. Click on **Desc**

4. Under **Row limit**, leave **25000** as it is to import **25000 rows** then Click **Apply**

---

## 🚨 Task 7. Calculated columns
1.Return to the **taxi_trips** tab and Click on the **Calculated columns** button

2. **Calculated column name** > **tip_percentage**

3. Copy and paste the following formula into the formula field:
```
=IF(fare>0,tips/fare*100,0)
```
4. Click **Add** and Click **Apply**

---

### Congratulations, you're all done with the lab 😄
---

### 🌐 Join our Community

- **Join our [Discussion Group](https://t.me/Techcpschat)** <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25">
- **Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)** <img src="https://github.com/user-attachments/assets/6ee41001-c795-467c-8d96-06b56c246b9c" alt="icon" width="25" height="25">
- **Join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)** <img src="https://github.com/user-attachments/assets/aa10b8b2-5424-40bc-8911-7969f29f6dae" alt="icon" width="25" height="25">
- **Join our [Telegram Channel](https://t.me/Techcps)** <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25">
- **Follow us on [LinkedIn](https://www.linkedin.com/company/techcps/)** <img src="https://github.com/user-attachments/assets/b9da471b-2f46-4d39-bea9-acdb3b3a23b0" alt="icon" width="25" height="25">

### Thanks for watching :)

