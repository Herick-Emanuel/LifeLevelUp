# Usar a imagem base do Node.js
FROM node:16

# Definir o diretório de trabalho
WORKDIR /app

# Copiar os arquivos de configuração
COPY package*.json ./

# Instalar as dependências do projeto
RUN npm install

# Copiar o restante do código para o contêiner
COPY . .

# Expor a porta que o servidor usa
EXPOSE 3000

# Comando para iniciar o servidor
CMD ["node", "server.js"]
