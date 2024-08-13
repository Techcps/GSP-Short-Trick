
# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)


## 🚨Copy and run the below commands in Cloud Shell:
```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Apply%20RFM%20method%20to%20segment%20customer%20data/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh
```

## 🚨 Go to BigQuery Studio, click + Compose new query and run the below query
```
SELECT
 user_id AS customer_id,
 COUNT(order_id) as frequency,
FROM `thelook_ecommerce.orders`
WHERE created_at >= '2022-01-01' and created_at < '2023-01-01'
GROUP BY customer_id
ORDER BY frequency DESC
LIMIT 10;
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
