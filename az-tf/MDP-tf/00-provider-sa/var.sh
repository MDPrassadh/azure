$env:SUBSCRIPTION_ID="b26ea690-075c-4743-bfcc-f52e42839c44"

az ad sp create-for-rbac `
  --name az_login_sp `
  --role Contributor `
  --scopes "/subscriptions/$env:SUBSCRIPTION_ID"
