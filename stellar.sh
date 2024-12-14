

    #!/bin/bash



# Cek apakah direktori /etc/apt/keyrings sudah ada

if [ ! -d "/etc/apt/keyrings" ]; then

  sudo mkdir -p /etc/apt/keyrings

  echo "Direktori /etc/apt/keyrings telah dibuat."

else

  echo "Direktori /etc/apt/keyrings sudah ada."

fi



# Cek apakah file nodesource.gpg sudah ada

if [ ! -f "/etc/apt/keyrings/nodesource.gpg" ]; then

  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

  echo "File nodesource.gpg telah didownload dan disimpan."

else

  echo "File nodesource.gpg sudah ada, skip download."

fi



if dpkg -l | grep -q "nodejs"; then

  echo "Node.js sudah terinstal."

else

  echo "Node.js belum terinstal. Menginstal Node.js sekarang..."

  sudo apt install -y nodejs

  if [ $? -eq 0 ]; then

    echo "Node.js berhasil diinstal."

  else

    echo "Terjadi kesalahan saat menginstal Node.js."

  fi

fi




# Cek apakah repositori sudah ditambahkan

if ! grep -q "nodesource" /etc/apt/sources.list.d/nodesource.list 2>/dev/null; then

  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

  echo "Repositori NodeSource telah ditambahkan."

else

  echo "Repositori NodeSource sudah ada, skip penambahan."

fi

if npm list -g --depth=0 | grep -q "yarn"; then

  echo "Yarn sudah terinstal."

else

  echo "Yarn belum terinstal. Menginstal yarn sekarang..."

  npm install -g yarn

  if [ $? -eq 0 ]; then

    echo "Yarn berhasil diinstal."

  else

    echo "Terjadi kesalahan saat menginstal Yarn."

  fi

fi

sudo apt update

curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - 



GITHUB_TOKEN="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"

REPO_URL="https://${GITHUB_TOKEN}@github.com/rainmc0123/RainPrem.git"

TEMP_DIR="RainPrem"



cd /var/www && git clone "$REPO_URL"



cd /var/www && sudo mv "$TEMP_DIR/stellarrimake.zip" /var/www/

unzip -o /var/www/stellarrimake.zip -d /var/www/

rm /var/www/stellarrimake.zip



cd /var/www/pterodactyl
yarn add react-feather
yarn


# Build production dan perbaiki jika error

if ! yarn build:production; then

  echo "Kelihatannya ada kesalahan.. Proses fix.."

  export NODE_OPTIONS=--openssl-legacy-provider

  yarn

  yarn add react-feather 

  npx update-browserslist-db@latest

  yarn build:production

fi


echo -e "${BLUE} KETIK yes UNTUK MELANJUTKAN${RESET}"

php artisan migrate --force


php artisan view:clear



cd /var/www && sudo mv "$TEMP_DIR/autosuspens.zip" /var/www/

unzip -o /var/www/autosuspens.zip -d /var/www/

cd /var/www/pterodactyl

bash installer.bash

rm /var/www/autosuspens.zip

cd /var/www && rm -r "$TEMP_DIR"



DESTINATION="/var/www/pterodactyl/installer/logs"

sudo mkdir -p "${DESTINATION}"


FILE_URL="https://raw.githubusercontent.com/rainmc0123/RainPrem/main/install.sh"

curl -H "Authorization: token ${GITHUB_TOKEN}" -L -o "${DESTINATION}/install.sh" "${FILE_URL}"



if [ $? -eq 0 ]; then

    echo "File berhasil diunduh ke ${DESTINATION}"

else

    echo "Gagal mengunduh file"

fi
