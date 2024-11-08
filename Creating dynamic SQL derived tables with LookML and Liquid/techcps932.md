

## 💡 Lab Link: [Creating dynamic SQL derived tables with LookML and Liquid - GSP932](https://www.cloudskillsboost.google/focuses/21215?parent=catalog)

## 🚀 Lab Solution [Watch Here](https://www.youtube.com/@techcps)

---

### ⚠️ Disclaimer
- **This script and guide are provided for  the educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

### ©Credit
- **DM for credit or removal request (no copyright intended) ©All rights and credits for the original content belong to Google Cloud [Google Cloud Skill Boost website](https://www.cloudskillsboost.google/)** 🙏

---

### 🚨 First, click the toggle button to turn on the Development mode.

![Techcps](https://github.com/Techcps/GSP-Short-Trick/assets/104138529/ef540cc4-e6ce-4e81-bf76-75c9ab00a42b)

### 🚨 Go to Develop > qwiklabs-ecommerce LookML project.

### 🚨 Create view file:
```
user_facts
```
- **Remove the default code and paste the below code:**

```
view: user_facts {
  derived_table: {
    sql: SELECT order_items.user_id AS user_id
          ,COUNT(distinct order_items.order_id) AS lifetime_order_count
          ,SUM(order_items.sale_price) AS lifetime_revenue
          ,MIN(order_items.created_at) AS first_order_date
          ,MAX(order_items.created_at) AS latest_order_date
      FROM cloud-training-demos.looker_ecomm.order_items
      GROUP BY user_id
      LIMIT 10
       ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }
  
  measure: average_lifetime_revenue {
    type: average
    sql: ${TABLE}.lifetime_revenue ;;
  }
  
  
  measure: average_lifetime_order_count {
    type: average
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}

```
---

### 🚨 Open training_ecommerce.model file
- **Remove the default code and paste the below code:**
```
connection: "bigquery_public_data_looker"

# include all the views
include: "/views/*.view"
include: "/z_tests/*.lkml"
include: "/**/*.dashboard"

datagroup: training_ecommerce_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: training_ecommerce_default_datagroup

label: "E-Commerce Training"

explore: order_items {
  join: user_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_facts.user_id};;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  join: event_session_facts {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
    relationship: many_to_one
  }
  join: event_session_funnel {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_funnel.session_id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

```

### ⚠️ Now just go and check your progress for Task 1, 2

---

### 🚨 Open user_factse.view file
- **Remove the default code and paste the below code:**
```
view: user_facts {
  derived_table: {
    sql: SELECT
           order_items.user_id AS user_id
          ,COUNT(distinct order_items.order_id) AS lifetime_order_count
          ,SUM(order_items.sale_price) AS lifetime_revenue
          ,MIN(order_items.created_at) AS first_order_date
          ,MAX(order_items.created_at) AS latest_order_date
          FROM cloud-training-demos.looker_ecomm.order_items
          WHERE {% condition select_date %} order_items.created_at {% endcondition %}
          GROUP BY user_id;;
  }
  
  filter: select_date {
    type: date
    suggest_explore: order_items
    suggest_dimension: order_items.created_date
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${TABLE}.lifetime_revenue ;;
  }


  measure: average_lifetime_order_count {
    type: average
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}

```


### Congratulations, you're all done with the lab 😄

---

### 🌐 Join our Community

- <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25"> **Join our [Telegram Channel](https://t.me/Techcps) for the latest updates & [Discussion Group](https://t.me/Techcpschat) for the lab enquiry**
- <img src="https://github.com/user-attachments/assets/aa10b8b2-5424-40bc-8911-7969f29f6dae" alt="icon" width="25" height="25"> **Join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A) for the latest updates**
- <img src="https://github.com/user-attachments/assets/b9da471b-2f46-4d39-bea9-acdb3b3a23b0" alt="icon" width="25" height="25"> **Follow us on [LinkedIn](https://www.linkedin.com/company/techcps/) for updates and opportunities.**
- <img src="https://github.com/user-attachments/assets/a045f610-775d-432a-b171-97a2d19718e2" alt="icon" width="25" height="25"> **Follow us on [TwitterX](https://twitter.com/Techcps_/) for the latest updates**
- <img src="https://github.com/user-attachments/assets/84e23456-7ed3-402a-a8a9-5d2fb5b44849" alt="icon" width="25" height="25"> **Follow us on [Instagram](https://instagram.com/techcps/) for the latest updates**
- <img src="https://github.com/user-attachments/assets/fc77ddc4-5b3b-42a9-a8da-e5561dce0c70" alt="icon" width="25" height="25"> **Follow us on [Facebook](https://facebook.com/techcps/) for the latest updates**

---

# <img src="https://github.com/user-attachments/assets/6ee41001-c795-467c-8d96-06b56c246b9c" alt="icon" width="45" height="45"> [Techcps](https://www.youtube.com/@techcps) Don't Forget to like share & subscribe

### Thanks for watching and stay connected :)
---
