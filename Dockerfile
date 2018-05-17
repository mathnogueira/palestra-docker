# Define the base image
FROM node:carbon as build
# Define where your work directory is inside the container
WORKDIR /tmp/app

# Copy the package.json and package-lock.json to restore the npm dependencies
COPY package*.json ./
# Install dependencies
RUN npm install

# Copy rest of the files
COPY . .

RUN npm run build

FROM node:carbon as production
WORKDIR /usr/app
RUN npm install -g forever

COPY package*.json ./
RUN npm install --only=production

COPY --from=build /tmp/app/dist ./dist

# Expose the port that will be used inside the container
 EXPOSE 3000

# Execute the command to start the server
CMD ["forever", "-w" ,"dist/server.js"]
# CMD ["npm", "start"]