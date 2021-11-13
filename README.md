# tf-cw-filter

Creates a simple metric filter with alarm for unstructured logs based on a specific pattern

## run
Modify profile name in scripts and template
```
terraform install
terraform apply

#Create logs
for run in {1..50}; do ./log.sh; done
```
check your data points, metrics, alerts 

remove your resources
```
terraform apply -destroy
```