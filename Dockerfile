FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

# Define the command to run your app
CMD ["node", "src/index.js"]
