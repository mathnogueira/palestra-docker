# Define a imagem base para executar o build
# Este primeiro container é responsável únicamente por construir nossa aplicação
FROM node:carbon as build
# Define o local onde a aplicação ficará
WORKDIR /tmp/app

# Copia os arquivos de gerenciamento de dependência
COPY package*.json ./
# Instala as dependências
RUN npm install

# Copia o restante dos arquivos
COPY . .

# Executa o build da aplicação
RUN npm run build

# Esta imagem é responsável por copiar os arquivos de saída do build
# assim, a imagem a ser enviada para produção é a menor possível. Você pode
# saber mais sobre isso pesquisando sobre "Multistage build in docker"
FROM node:carbon as production
WORKDIR /usr/app

# Forever é uma ferramenta para detectar mudanças nos arquivos fontes que
# estão sendo executados, e reinicia a aplicação caso eles tenham alguma
# modificação.
RUN npm install -g forever

# Instala as dependências
COPY package*.json ./
RUN npm install --only=production

# Copia os arquivos que estão na pasta dist/ da imagem "build" para nosso diretório
# dist/ nesta imagem
COPY --from=build /tmp/app/dist/* ./dist/

# Expõe a porta que será usada pela aplicação
 EXPOSE 3000

# Inicia o servidor
CMD ["forever", "-w" ,"dist/server.js"]