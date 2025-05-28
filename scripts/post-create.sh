
# cd to script directoy
cd "$(dirname "$0")"

bash ./getting-started.sh

pip install pandas

# install nushell
curl -fsSL https://apt.fury.io/nushell/gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
echo "deb https://apt.fury.io/nushell/ /" | tee /etc/apt/sources.list.d/fury.list
apt update && apt install -y

# show only prefixed histroy
echo 'bind "\e[A": history-search-backward' >> ~/.bashrc
echo 'bind "\e[B": history-search-forward' >> ~/.bashrc