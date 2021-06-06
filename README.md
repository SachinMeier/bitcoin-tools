# Bitcoin.Umbrella

## Setup 

  * Run ```echo "export SECRET_KEY_BASE=$(mix phx.gen.secret)" >> .env```


## Deploying to Gigalixir

  * Run ```cd apps/bitcoin_web/assets && npm run deploy && cd ../../..```
  * Run ```mix phx.digest.clean && mix phx.digest```

  * Git commit changes
  * Run ```git push gigalixir```
  * Run ```gigalixir ps``` to check status

## Building the Docker Image

  * Run ```docker-compose build```
  * Run ```docker-compose up```