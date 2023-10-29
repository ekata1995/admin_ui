# Use an official Node.js runtime as a parent image
FROM node:14

# Copy all the source files to the working directory
COPY . .

# Set the working directory in the container
WORKDIR /client

# Install project dependencies
RUN npm install
# Build the Vue.js application
RUN npm run build

# Expose a port that the application will run on (typically 80 for HTTP)
EXPOSE 80

# Define the command to run your Vue.js application
CMD [ "npm", "run", "serve" ]
