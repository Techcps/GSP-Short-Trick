
# Bigtable: Qwik Start - Command Line [GSP099]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

## Task 1. Create a Cloud Bigtable instance

```
export ZONE=
```

```
gcloud services enable bigtable.googleapis.com bigtableadmin.googleapis.com

gcloud bigtable instances create quickstart-instance --display-name="Quickstart instance" --cluster-storage-type=SSD --cluster-config=id=quickstart-instance-c1,zone=$ZONE,nodes=1
```

## Task 2. Connect to your instance

```
echo project = `gcloud config get-value project` > ~/.cbtrc

echo instance = quickstart-instance >> ~/.cbtrc
```

## Task 3. Read and write data

```
cbt createtable my-table
```
```
cbt ls

cbt createfamily my-table cf1

cbt ls my-table

cbt set my-table r1 cf1:c1=test-value

cbt read my-table

cbt deletetable my-table

```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
