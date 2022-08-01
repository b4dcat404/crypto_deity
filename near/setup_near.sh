#!/bin/bash
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/b4dcat404/crypto_deity/main/cryptodeity.sh | bash
echo "-----------------------------------------------------------------------------"
if lscpu | grep -P '(?=.*avx )(?=.*sse4.2 )(?=.*cx16 )(?=.*popcnt )' > /dev/null; then
  echo "Процессор поддерживается, начинаем установку!"
else
  echo "К сожалению, ваш процессор не поддерживается, установка невозможна!"
  kill -SIGINT $$
fi
sudo apt update && sudo apt upgrade -y && sudo apt install curl -y && sudo apt install curl jq
sudo apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo || 
sudo apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install build-essential nodejs -y
PATH="$PATH"
sudo apt install python3-pip -y
USER_BASE_BIN=$(python3 -m site --user-base)/bin
export PATH="$USER_BASE_BIN:$PATH"
sudo apt install clang build-essential make
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
sudo npm install -g near-cli
export NEAR_ENV=shardnet
echo 'export NEAR_ENV=shardnet' >> ~/.bashrc
git clone https://github.com/near/nearcore
cd nearcore
git fetch
git checkout c1b047b8187accbf6bd16539feb7bb60185bdc38
cargo build -p neard --release --features shardnet
./target/release/neard --home ~/.near init --chain-id shardnet --download-genesis
rm ~/.near/config.json
wget -O ~/.near/config.json https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
sudo apt-get install awscli -y
rm ~/.near/genesis.json
cd ~/.near
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/genesis.json
echo "Скопируйте ссылку и откройте её в браузере, затем предоставьте полный доступ к учётной записи. Подтвердите это, введя имя пользователя (Пример: yourname.shardnet.near)"
near login
while true; do
  read -p "Введите имя пользователя (Пример: yourname.shardnet.near): " name
  if [[ ${#name} -gt 14 ]]; then
    near generate-key $name 
    cp ~/.near-credentials/shardnet/$name.json ~/.near/validator_key.json
    break;
  else
    echo "Вы ввели некорректное имя пользователя!";
  fi
done
cat ~/.near/validator_key.json | grep public_key
while true; do
  read -p "Введите public key, который указан выше ( БЕЗ КАВЫЧЕК ): " publicKey
  if [[ ${#publicKey} -gt 35 ]]; then
    break;
  else
    echo "Вы ввели неккоректный public key!";
  fi
done
cat ~/.near/validator_key.json | grep private_key
while true; do
  read -p "Введите private key, который указан выше ( БЕЗ КАВЫЧЕК ): " privateKey
  if [[ ${#privateKey} -gt 35 ]]; then
    break;
  else
    echo "Вы ввели некорректный private key!";
  fi
done
echo "[Unit]
Description=NEARd Daemon Service

[Service]
Type=simple
User=root
#Group=near
WorkingDirectory=/root/.near
ExecStart=/root/nearcore/target/release/neard run
Restart=on-failure
RestartSec=30
KillSignal=SIGINT
TimeoutStopSec=45
KillMode=mixed

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/neard.service
sudo systemctl daemon-reload
sudo systemctl enable neard
sudo systemctl start neard
sudo apt install ccze
while true; do
  read -p "У вас уже есть стейкпинг пул? Y/N ( Если вы устанавливаете в первый раз, то пропишите N )" y
  case $y in
    [Yy]* ) break;;
    [Nn]* ) break;;
  esac
done
if [[ ${y} == [Nn]* ]]; then
echo "Разворачиваем новый стейкинг пул для валидатора"
fi
while true; do
  read -p "Введите название название пула (Пример: test123): " poolName
  if [[ ${#poolName} -gt 0 ]]; then
    echo "{\"account_id\": \"${poolName}.factory.shardnet.near\",\"public_key\": \"${publicKey}\",\"secret_key\": \"${privateKey}\"}" > ~/.near/validator_key.json;
    break;
  else
    echo "Вы ввели некорректное название пула!";
  fi
done
if [[ ${y} == [Nn]* ]]; then
while true; do
  read -p "Введите комиссию, которую будет взимать пул (Рекомендуется: 5): " poolCommission
  if [[ ${#poolCommission} -gt 0 ]]; then
    break;
  else
    echo "Вы ввели некорректную комиссию!";
  fi
done
while true; do
  read -p "Введите сумму NEAR для храненения (Минимально: 30, баланс NEAR можно посмотреть на кошельке, НЕ ПЕРЕПУТАЙТЕ кол-во долларов с монетами NEAR): " nearBalance
  if [[ ${#nearBalance} -gt 0 ]]; then
    break;
  else
    echo "Вы ввели некорректную комиссию!";
  fi
done
near call factory.shardnet.near create_staking_pool '{"staking_pool_id": "'${poolName}'", "owner_id": "'${name}'", "stake_public_key": "'${publicKey}'", "reward_fee_fraction": {"numerator": '${poolCommission}', "denominator": 100}, "code_hash":"DD428g9eqLL8fWUxv8QSpVFzyHi1Qd16P8ephYCTmMSZ"}' --accountId="${name}" --amount=$nearBalance --gas=300000000000000
fi
mkdir /home/logs
mkdir /home/${name}
mkdir /home/${name}/scripts
echo '#!/bin/sh
# Ping call to renew Proposal added to crontab

export NEAR_ENV=shardnet

echo "---" >> /home/logs/all.log
date >> /home/logs/all.log
near call '$poolName'.factory.shardnet.near ping '{}' --accountId '${name}' --gas=300000000000000 >> /home/logs/all.log
near proposals | grep '$poolName' >> /home/logs/all.log
near validators current | grep '$poolName' >> /home/logs/all.log
near validators next | grep '$poolName' >> /home/logs/all.log' > /home/${name}/scripts/ping.sh
crontab -l > mycron
echo "0 */2 * * * sh /home/${name}/scripts/ping.sh" >> mycron
crontab mycron
rm mycron
echo "Стейкинг пула запущен! Введите \"cat /home/logs/all.log\", чтобы проверить логи! ( Команда станет доступная после первого пинга )"
echo "Нода установлена! Введите \"journalctl -n 100 -f -u neard | ccze -A\", чтобы проверить логи!"