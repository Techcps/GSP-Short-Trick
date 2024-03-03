
# Looker Functions and Operators [GSP857]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Channel](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

> 🚨 Turn on the Development mode

# Task 1. Pivot dimensions

```
# Place in `faa` model
explore: +flights {
  query: start_from_here{
      dimensions: [depart_week, distance_tiered]
      measures: [count]
      filters: [flights.depart_date: "2003"]
    }
  }
```

# Task 2. Reorder columns and remove fields

```
# Place in `faa` model
explore: +flights {
  query: start_from_here{
      dimensions: [aircraft_origin.state]
      measures: [percent_cancelled]
      filters: [flights.depart_date: "2000"]
    }
  }
```


# Task 3. Use table calculations to calculate simple percentages

```
# Place in `faa` model
explore: +flights {
    query: start_from_here{
      dimensions: [aircraft_origin.state]
      measures: [cancelled_count, count]
      filters: [flights.depart_date: "2004"]
    }
}
```

# Task 4. Use table calculations to calculate percentages of a total

```
# Place in `faa` model
explore: +flights {
    query: start_from_here{
      dimensions: [carriers.name]
      measures: [total_distance]
    }
}
```
# Task 5. Use functions in table calculations

```
# Place in `faa` model
explore: +flights {
    query:start_from_here {
      dimensions: [depart_year, distance_tiered]
      measures: [count]
      filters: [flights.depart_date: "after 2000/01/01"]
    }
}
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
