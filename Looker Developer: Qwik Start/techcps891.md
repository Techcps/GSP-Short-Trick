

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

## 🚨 First, click the toggle button to turn on the Development mode.

![Techcps](https://github.com/Techcps/GSP-Short-Trick/assets/104138529/ef540cc4-e6ce-4e81-bf76-75c9ab00a42b)

## 🚨 Go to Develop > qwiklabs-ecommerce LookML project.

## 🚨 Create view file:
```
users_limited
```

## 🚨 Remove the default code and paste the below code:

```
view: users_limited {
  sql_table_name: `cloud-training-demos.looker_ecomm.users` ;;
  
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }
  
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  
  measure: count {
    type: count
    drill_fields: [id, last_name, first_name]
  }
}

```

## 🚨 Open training_ecommerce.model file

## 🚨 Remove the default code and paste the below code:

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
  
  join: users_limited {
    type: left_outer
    sql_on: ${events.user_id} = ${users_limited.id};;
    relationship: many_to_one
  }  
}

```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
