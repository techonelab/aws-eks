1. edit values for required variables accordingly "sourceme"
2. source sourceme to export all variables after editing
3. on same directory "prereq" do a tf init and apply to create:
   - s3 bucket for remote tf state
   - dynamodb for remote tf state