{
  "app1.json" = "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n      {\n        \"Action\": [\n          \"ec2:Describe*\"\n        ],\n        \"Effect\": \"Allow\",\n        \"Resource\": \"*\"\n      }\n    ]\n  }\n  "
  "app2.json" = "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n            \"Action\": [\n                \"s3:List*\"\n            ],\n            \"Effect\": \"Allow\",\n            \"Resource\": \"*\"\n        }\n    ]\n}\n"
}
