# Stage 0 - Development
# "build", based on Node.js, to build and compile the frontend
# "AS development" used in the docker-compose command: target: development, referencing a specific build stage in the Dockerfile
FROM node:16.16-alpine AS development
# Set the working directory in the container
WORKDIR /app 
# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
# Install dependencies
RUN npm install
# Copy the entire application code to the container
COPY . .
# Expose port 3000
EXPOSE 3000
# Start the app
CMD [ "npm", "run", "dev" ]



# Stage 0 - "Production"
# "build", based on Node.js, to build and compile the frontend
FROM node:16.16-alpine as build
# Set the working directory in the container
WORKDIR /app 
# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
# Install dependencies
RUN npm install
# Copy the entire application code to the container
COPY . .
# Build the React app
RUN npm run build


# Stage 1 - "Production"
# Use Nginx as the production server
# nginx:1.15
FROM nginx:1.25.3-alpine3.18 as production
# Copy the built React app to Nginx's web server directory
COPY --from=build /app/dist/ /usr/share/nginx/html
# Copying nginx configuration files to replace the default configuration
# Docker multi-stage trick, although it is Nginx image starting from scratch, it can copy files from a previous stage
COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 80 for the Nginx server
# This line is just for documentation that our application will work on port 80
EXPOSE 80
# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]