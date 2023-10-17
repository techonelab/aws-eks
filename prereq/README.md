1. edit values for required variables accordingly "sourceme"
2. issue command "source sourceme" (a bit old approach but gold) to export all variables after editing
3. on same directory "prereq" do a tf init and apply to create:
   - s3 bucket for remote tf state
   - dynamodb for remote tf state
   #this was suppose to support the remote backend setup  during provisioning but for whatever reason terraform appears to not able to point to localstack locally hosted endpoint for s3 despite of correct configuration on provider.tf and main.tf, can only assume  for now that it is somehow a limitation(tech-debt) of tf and localstack connection, I will not remove this section and you may opt-out to use this on your live aws account (and I am not liable for the underlying cost for actual aws service that will be provisioned, so please, make sure to change some settings for the s3 bucket to stay on free tier if you are still exploring aws)