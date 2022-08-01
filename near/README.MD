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
Here's the Github Repository for NEAR CLI.: https://github.com/near/near-cli. To install NEAR-CLI, unless you are logged in as root, which is not recommended you will need to use `sudo` to install NEAR-CLI so that the near binary is saved to /usr/local/bin

```
sudo npm install -g near-cli
```
### Validator Stats

Now that NEAR-CLI is installed, let's test out the CLI and use the following commands to interact with the blockchain as well as to view validator stats. There are three reports used to monitor validator status:


###### Environment
The environment will need to be set each time a new shell is launched to select the correct network.

Networks:
- GuildNet
- TestNet
- MainNet
- **Shardnet** (this is the network we will use for Stake Wars)

Command:
```
export NEAR_ENV=shardnet
```

You can also run this command to set the Near testnet Environment persistent:
```
echo 'export NEAR_ENV=shardnet' >> ~/.bashrc
```

#### NEAR CLI Commands Guide:

###### Proposals
A proposal by a validator indicates they would like to enter the validator set, in order for a proposal to be accepted it must meet the minimum seat price.

Command:
```
near proposals
```

###### Validators Current
This shows a list of active validators in the current epoch, the number of blocks produced, number of blocks expected, and online rate. Used to monitor if a validator is having issues.

Command:
```
near validators current
```

###### Validators Next
This shows validators whose proposal was accepted one epoch ago, and that will enter the validator set in the next epoch.

Command:
```
near validators next
```

---


## We continue ?

[Setup and Run your Node](./002.md)


## Update log

Updated 2022-07-13: Creation

Updated 2022-07-13: Creation

Updated 2022-07-20: Clarified the rewards for solving the challenge