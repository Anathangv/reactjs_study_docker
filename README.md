# Dockerized App

An educational React app exploring Docker containerization. Utilized Docker Compose to manage development and production environments.


## Tech Stack

**Client:** 
 - [Vite](https://vitejs.dev/)
 - [Typescript](https://www.typescriptlang.org/)
 - [React](https://reactjs.org/)



**Requirements**
 - [Docker](https://www.docker.com/products/docker-desktop/)
 - [Node.js](https://nodejs.org/en)

## Run Locally

Clone the project

```bash
  git clone https://github.com/Anathangv/reactjs_study_docker.git
```

Go to the project directory

```bash
  cd reactjs_study_docker
```

Install dependencies

```bash
  npm install
```

Start the application development mode

```bash
  docker-compose -f docker-compose.dev.yml up

  #or run in detached mode
  docker-compose -f docker-compose.dev.yml up -d
```

Open the URL in the browser: *http://localhost:3000/*

Start the application production mode

```bash
  docker-compose up

  #or run in detached mode
  docker-compose up -d
```

Open the URL in the browser: *http://localhost:8080/*

## Documentation
 - Additional details and insights can be found within the code comments provided in certain sections
 - In the project directory add .dockerignore file
```text
  node_modules
```

 - Create a Dockerfile
```dockerfile
  # Stage 0 - Development
  FROM node:16.16-alpine AS development
  WORKDIR /app 
  COPY package*.json ./
  RUN npm install
  COPY . .
  EXPOSE 3000
  CMD [ "npm", "run", "dev" ]


  # Stage 0 - "Production"
  FROM node:16.16-alpine as build
  WORKDIR /app 
  COPY package*.json ./
  RUN npm install
  COPY . .
  RUN npm run build

  # Stage 1 - "Production"
  FROM nginx:1.25.3-alpine3.18 as production
  COPY --from=build /app/dist/ /usr/share/nginx/html
  COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf
  EXPOSE 80
  CMD ["nginx", "-g", "daemon off;"]
```

- Create the file nginx.conf within the new folder called nginx 
```text
  server {
      listen 80;
      location / {
          root /usr/share/nginx/html;
          index index.html index.htm;
          try_files $uri $uri/ /index.html =404;
      }
  }
```

- Create the docker-compose.dev.yml file for development environment

```yaml
  version: "3.8"
  services:
    app:
      container_name: app-dev
      image: app-dev
      build:
        context: .
        target: development
      volumes:
        - ./src:/app/src
      ports:
        - 3000:3000
```

- When using Vite, it's necessary to modify the 'vite.config.ts' file to ensure that the application functions correctly in the web browser
```ts
  export default defineConfig({
    plugins: [react()],
    server: {
      host: true,
      port: 3000, // This is the port which we will use in docker
      watch: {
        usePolling: true
      } 
    }
  })
```

- Create the docker-compose.yml file for production environment
```yaml
  version: "3.8"
  services:
    nginx-react:
      container_name: my-docker-app-container
      image: my-docker-app
      build:
        context: .
        dockerfile: Dockerfile
      ports:
        - 8080:80
```

## Screenshots

Development:

![image](https://github.com/Anathangv/reactjs_study_docker/assets/14235259/c3a2c785-6d1b-4a1c-9754-d44c80935658)


Production:

![image](https://github.com/Anathangv/reactjs_study_docker/assets/14235259/a4e033b5-1421-42e9-bafb-cdb6a142af52)

Docker Desktop - Images:

![image](https://github.com/Anathangv/reactjs_study_docker/assets/14235259/5a526d15-4276-4b41-9a9f-d525c8c629a7)


