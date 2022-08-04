<p align="center">
  <a href="https://near.org">
    <img src="https://avatars.githubusercontent.com/u/7613128?s=200&v=4" height="96">
  </a>
  <h3 align="center"><code>@near</code></h3>
  <p align="center">Developer platform to create apps that put users back in control of their data and assets.</p>
</p>

## Полезные ссылки

Кошелек: https://wallet.shardnet.near.org/

Обозреватель: https://explorer.shardnet.near.org/ 


### Создание кошелька
https://wallet.shardnet.near.org/


#### Установка NEAR-CLI

NEAR-CLI - это интерфейс командной строки, который взаимодействует с блокчейном NEAR с помощью удаленных вызовов процедур (RPC):

* Установка и настройка NEAR CLI
* Просмотре статистики валидатора

> Примечание: По соображениям безопасности рекомендуется, чтобы NEAR-CLI был установлен на компьютере, отличном от вашего узла проверки, и чтобы на вашем узле проверки не хранились ключи полного доступа.

Во-первых, давайте убедимся, что Linux обновлен.
```
sudo apt update && sudo apt upgrade -y
```

##### Установка иснтрументов разработчика, Node.js, и npm
Начнем с установки `Node.js` и `npm`:
```
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -  
sudo apt install build-essential nodejs
PATH="$PATH"
```

Проверяем `Node.js` и `npm` версию:
```
node -v
```
> v18.x.x

```
npm -v
```
> 8.x.x


##### Установка NEAR-CLI
Вот репозиторий Github для CLI NEAR.: https://github.com/near/near-cli . Чтобы установить NEAR-CLI, если вы не вошли в систему с правами root, что не рекомендуется, вам нужно будет использовать `sudo` для установки NEAR-CLI, чтобы двоичный файл near был сохранен в /usr/local/bin

```
sudo npm install -g near-cli
```
### Статус валидатора

Теперь, когда NEAR-CLI установлен, давайте протестируем CLI и используем следующие команды для взаимодействия с блокчейном, а также для просмотра статистики валидатора. Существует три отчета, используемых для мониторинга состояния валидатора:

###### Окружение
Среду необходимо будет настраивать каждый раз при запуске новой оболочки, чтобы выбрать правильную сеть.

Сети:
- GuildNet
- TestNet
- MainNet
- **Shardnet** (это сеть, которую мы будем использовать для Stake Wars)

Команда:
```
export NEAR_ENV=shardnet
```

Вы также можете выполнить эту команду, чтобы установить постоянную среду Near testnet:
```
echo 'export NEAR_ENV=shardnet' >> ~/.bashrc
```

#### NEAR CLI Гайд по командам:

###### Предложения
Предложение валидатора указывает на то, что он хотел бы войти в набор валидаторов, для того, чтобы предложение было принято, оно должно соответствовать минимальной цене места.

Команда:
```
near proposals
```

###### Текущие валидаторы
Здесь отображается список активных валидаторов в текущую эпоху, количество произведенных блоков, ожидаемое количество блоков и скорость онлайн. Используется для отслеживания проблем, возникающих у валидатора.

Команда:
```
near validators current
```

###### Следующие валидаторы
Это показывает валидаторов, чье предложение было принято одну эпоху назад, и которые войдут в набор валидаторов в следующую эпоху.

Команда:
```
near validators next
```

---

### Установка ноды
#### Требования к системе
Пожалуйста, ознакомьтесь с требованиями к оборудованию ниже:

| Hardware       | Chunk-Only Producer  Specifications                                   |
| -------------- | ---------------------------------------------------------------       |
| CPU            | 4-Core CPU with AVX support                                           |
| RAM            | 8GB DDR4                                                              |
| Storage        | 500GB SSD                                                             |


#### Установка необходимого программного обеспечения и настройка конфигурации

##### Предпосылки:
Перед началом работы вы можете убедиться, что на вашем компьютере установлены правильные функции процессора.

```
lscpu | grep -P '(?=.*avx )(?=.*sse4.2 )(?=.*cx16 )(?=.*popcnt )' > /dev/null \
  && echo "Supported" \
  || echo "Not supported"
```
> Supported


##### Установка инструментов разработчика:
```
sudo apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo
```
#####  Установка Python pip:

```
sudo apt install python3-pip
```
##### Настройка конфигурации:

```
USER_BASE_BIN=$(python3 -m site --user-base)/bin
export PATH="$USER_BASE_BIN:$PATH"
```

##### Установка Building env
```
sudo apt install clang build-essential make
```

##### Установка Rust & Cargo
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

You will see the following:

![img](https://github.com/near/stakewars-iii/blob/main/challenges/images/rust.png?raw=true)

Нажмите 1 и Enter

##### Источник окружения
```
source $HOME/.cargo/env
```

#### Клонируем `nearcore` проект с GitHub
Сначала клонируем [`nearcore` репозиторий](https://github.com/near/nearcore).

```
git clone https://github.com/near/nearcore
cd nearcore
git fetch
```


#### Компилируем `nearcore` бинарник
В папке `nearcore` запускаем следующую команду:

```
cargo build -p neard --release --features shardnet
```
Биарный путь `target/release/neard`. Если вы видите проблемы, возможно, что команда cargo не найдена. Компиляция двоичного файла `nearcore` может занять некоторое время.

#### Инициализируем рабочую папку

Для правильной работы NEAR ноде требуется рабочий каталог и пара файлов конфигурации. Создайте начальный требуемый рабочий каталог, выполнив:

```
./target/release/neard --home ~/.near init --chain-id shardnet --download-genesis
```

![img](https://github.com/near/stakewars-iii/blob/main/challenges/images/initialize.png?raw=true)

Эта команда создаст структуру каталогов и сгенерирует `config.json`, `node_key.json`, и `genesis.json` в сети, которую вы прошли.

- `config.json` - Параметры конфигурации, которые реагируют на то, как будет работать узел. Config.json содержит необходимую информацию для запуска узла в сети, о том, как взаимодействовать с одноранговыми узлами и как достичь консенсуса. Хотя некоторые параметры можно настроить. Как правило, валидаторы предпочитают использовать предоставленный по умолчанию файл config.json.

- `genesis.json` - Файл со всеми данными, с которых сеть начиналась в genesis. Он содержит начальные учетные записи, контракты, ключи доступа и другие записи, которые представляют начальное состояние блокчейна. Файл genesis.json представляет собой моментальный снимок состояния сети в определенный момент времени. В контактах учетные записи, балансы, активные валидаторы и другая информация о сети.

- `node_key.json` -  Файл, содержащий открытый и закрытый ключи для узла. Также включает необязательный параметр `account_id`, который необходим для запуска узла проверки (не рассматривается в этом документе).

- `data/` -  Папка, в которую NEAR узел запишет свое состояние.

#### Замена `config.json`

Из сгенерированного `config.json`, есть два параметра для изменения:
- `boot_nodes`: Если вы не указали загрузочные узлы для использования во время инициализации на шаге 3, сгенерированный файл `config.json` показывает пустой массив, поэтому нам нужно будет заменить его полным массивом с указанием загрузочных узлов.
- `tracked_shards`: В сгенерированном `config.json`, это поле является пустым. Вам придется заменить его на `"tracked_shards": [0]`

```
rm ~/.near/config.json
wget -O ~/.near/config.json https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
```

#### Получаем последний Snapshot

**ВАЖНО: НЕ ТРЕБУЕТСЯ ПОЛУЧАТЬ SNAPSHOT ПОСЛЕ ХАРДФОРКА В SHARDNET В ТЕЧЕНИЕ 2022-07-18**

Установка AWS Cli
```
sudo apt-get install awscli -y
```

Загрузка snapshot (genesis.json)
```
// ВАЖНО: НЕ ТРЕБУЕТСЯ ПОЛУЧАТЬ SNAPSHOT ПОСЛЕ ХАРДФОРКА В SHARDNET В ТЕЧЕНИЕ 2022-07-18
cd ~/.near
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/genesis.json
```

Если вышеуказанное не удастся, AWS CLI может быть удален в вашем репозитории дистрибутива. Вместо этого попробуйте:
```
pip3 install awscli --upgrade
```

#### Запуск ноды
Чтобы запустить свою ноду, просто выполните следующую команду:

```
cd ~/nearcore
./target/release/neard --home ~/.near run
```

![img](https://github.com/near/stakewars-iii/blob/main/challenges/images/download.png?raw=true)
Теперь узел запущен, и вы можете видеть выходные данные журнала в своей консоли. Ваш узел должен находить одноранговые узлы, загружать заголовки на 100%, а затем загружать блоки.

----



### Активация узла в качестве валидатора
##### Авторизация кошелька
Ключ полного доступа должен быть установлен локально, чтобы иметь возможность подписывать транзакции через NEAR-CLI.


* Вам нужно выполнить эту команду:

```
near login
```

> Примечание: Эта команда запускает веб-браузер, позволяющий локально копировать авторизацию полного ключа доступа.

1 – Скопируйте и вставьте ссылку в ваш браузер


![img](https://github.com/near/stakewars-iii/blob/main/challenges/images/1.png?raw=true)

2 – Разрешите доступ для Near CLI

![img](https://github.com/near/stakewars-iii/blob/main/challenges/images/3.png?raw=true)

3 – После предоставления разрешения вы увидите страницу, подобную этой, вернитесь в консоль

![img](https://github.com/near/stakewars-iii/blob/main/challenges/images/4.png?raw=true)

4 – Введите свой кошелек и нажмите Enter

![img](https://github.com/near/stakewars-iii/blob/main/challenges/images/5.png?raw=true)


#####  Проверка validator_key.json
* Выполните команду:
```
cat ~/.near/validator_key.json
```


> Примечание: Если файл validator_key.json отсутствует, выполните следующие действия, чтобы создать его

Создайте `validator_key.json` 

*   Сгенерируйте файл ключа:

```
near generate-key <pool_id>
```
<pool_id> ---> xx.factory.shardnet.near ГДЕ xx имя вашего пула

* Скопируйте сгенерированный файл в папку shardnet:
Обязательно замените <pool_id> на имя вашей учетной записи
```
cp ~/.near-credentials/shardnet/YOUR_WALLET.json ~/.near/validator_key.json
```
* Измените “account_id” => xx.factory.shardnet.near, где xx имя вашего пула
* Замените `private_key` на `secret_key`

> Примечание: Идентификатор учетной записи должен совпадать с именем контракта пула ставок, иначе вы не сможете подписывать блоки.\

Файл должен выглядить по следующему шаблону:
```
{
  "account_id": "xx.factory.shardnet.near",
  "public_key": "ed25519:HeaBJ3xLgvZacQWmEctTeUqyfSU4SDEnEwckWxd92W2G",
  "secret_key": "ed25519:****"
}
```

#####  Запуск ноды валидатора

```
target/release/neard run
```
* Создание сервиса
Команда:

```
sudo vi /etc/systemd/system/neard.service
```
Вставить:

```
[Unit]
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
WantedBy=multi-user.target
```

> ЗАМЕТКА: все выполняется из пол пользователя `root`

Команда:

```
sudo systemctl enable neard
```
Команда:

```
sudo systemctl start neard
```
Если вам нужно внести изменения в сервис из-за ошибки в файле. Его нужно перезагрузить:

```
sudo systemctl reload neard
```
###### Проверка логов
Команда:

```
journalctl -n 100 -f -u neard
```
Вывод логов с подсветкой синтаксиса

Команда:

```
sudo apt install ccze
```
Просмотр логов с подсветкой

Команда:

```
journalctl -n 100 -f -u neard | ccze -A
```
#### Становимся валидатором
Чтобы стать валидатором и войти в набор валидаторов, необходимо выполнить минимальный набор критериев успеха.

* Узел должен быть полностью синхронизирован
* `validator_key.json` должно быть на месте
* Контракт должен быть инициализирован с помощью public_key в `validator_key.json`
* Его account_id должен быть установлен на идентификатор контракта пула ставок
* Должно быть достаточно делегаций, чтобы соответствовать минимальной цене за место. Смотрите стоимость места [here](https://explorer.shardnet.near.org/nodes/validators).
* Предложение должно быть представлено путем пинга контракта
* Как только предложение принято, валидатор должен подождать 2-3 эпохи, чтобы ввести набор валидаторов
* После включения в набор валидатора валидатор должен выдавать более 90% назначенных блоков

Проверьте состояние работы узла валидатора. Если отображается “Валидатор”, ваш пул выбран в текущем списке валидаторов.