
# Analyzing Billing Data with BigQuery [GSP621]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Channel](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

> In the GCP Console open the Cloud Shell and run the following commands:

```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Analyzing%20Billing%20Data%20with%20BigQuery/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh
```
? Go to BigQuery editer and run the following Queries:
```
SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item FROM `billing_dataset.enterprise_billing` GROUP BY 1
```
```
SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item, Count(*) as NUM FROM `billing_dataset.enterprise_billing` GROUP BY CONCAT(service.description, ' : ',sku.description)
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
