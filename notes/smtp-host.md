## temporary, quick

````shell
sudo apt update
sudo apt install python3-aiosmtpd -y
sudo python3 -m aiosmtpd -l 0.0.0.0:25
````


## test

````shell
swaks --server localhost --port 25 \
  --from sender@example.com \
  --to user1@example.com,user2@example.com,user3@example.com \
  --to user3@example.com \
  --to user4@example.com \
  --header "Subject: Test email from Swaks" \
  --body "This is a test email sent via Swaks"
````