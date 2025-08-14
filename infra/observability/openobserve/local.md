# OpenObserve Local Development

localでの動かし方。


```sh
# Fetch 
git clone https://github.com/openobserve/openobserve
cd openobserve

# Run server
ZO_ROOT_USER_EMAIL="root@example.com" ZO_ROOT_USER_PASSWORD="Complexpass#123" cargo run

# Run UI
cd web
touch .env
echo "VITE_OPENOBSERVE_ENDPOINT=http://localhost:5080" >> .env
npm install
npm run dev
```
