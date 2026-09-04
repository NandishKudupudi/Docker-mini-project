🐳 Docker Production Mini Project

A production-style multi-container application built with Docker and
Docker Compose.

🎯 Project Objective

This project demonstrates containerization and production-oriented
Docker practices using a simple Nginx/HTML application.

Key concepts demonstrated

Dockerfile-based image creation

Docker Compose

Multiple services

Custom bridge networking

Service-to-service communication

Environment variables

Named volumes

Health checks

Restart policies

.dockerignore

Logs and container inspection

Failure simulation and troubleshooting

🏗️ Architecture

                         USER / BROWSER
                               |
                               | http://localhost:8080
                               v
                    +-----------------------+
                    |       WEB SERVICE     |
                    |      Nginx Alpine     |
                    |      docker-web       |
                    +-----------+-----------+
                                |
                         app-network
                                |
                    +-----------v-----------+
                    |    BACKEND SERVICE    |
                    |      Nginx Alpine     |
                    |    docker-backend     |
                    +-----------------------+

                         WEB SERVICE
                              |
                              v
                       +--------------+
                       |   web-data   |
                       | Named Volume |
                       +--------------+

A visual version is included as architecture.png.

🛠️ Technologies Used

Technology       Purpose

Docker           Containerization
Docker Compose   Multi-container management
Nginx Alpine     Lightweight container image
HTML             Sample application
Docker Network   Service communication
Docker Volume    Persistent data
Git/GitHub       Version control

📁 Project Structure

docker-mini-project/
│
├── compose.yaml
├── Dockerfile
├── index.html
├── .env
├── .dockerignore
├── .gitignore
├── architecture.png
└── README.md

🐳 Dockerfile

FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

HEALTHCHECK --interval=10s --timeout=3s --retries=3   CMD wget --spider -q http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

The image uses lightweight Nginx Alpine, copies the application into the
Nginx document root, adds a health check, documents port 80, and keeps
Nginx running in the foreground.

⚙️ Docker Compose

The Compose stack contains:

Web service

Builds the custom image

Publishes 8080:80

Reads configuration from .env

Uses the web-data named volume

Connects to app-network

Depends on a healthy backend

Uses unless-stopped

Backend service

Uses nginx:alpine

Connects to app-network

Has a health check

Uses unless-stopped

Network

networks:
  app-network:
    driver: bridge

Volume

volumes:
  web-data:

🔐 Environment Variables

Example .env:

APP_NAME=docker-mini-app
APP_ENV=production
APP_VERSION=1.0

Never commit real passwords, API keys, tokens, or other secrets to
GitHub.

🌐 Networking

The services communicate through the custom Docker network:

web  <------ app-network ------>  backend

The web container can reach the backend using the service name:

docker compose exec web sh
wget -qO- http://backend

Port mapping vs container networking

Host → Container
localhost:8080 → web:80

Port publishing is used for access from the host. Containers on the same
Docker network can communicate using service names without publishing
the internal service port to the host.

💾 Persistent Storage

The project uses the named volume:

web-data → /data

Test it:

docker compose exec web sh -c 'echo "Docker persistent data" > /data/test.txt'
docker compose exec web cat /data/test.txt

Then:

docker compose down
docker compose up -d
docker compose exec web cat /data/test.txt

The data remains because it is stored in the named volume.

❤️ Health Checks

Example:

healthcheck:
  test: ["CMD", "wget", "--spider", "-q", "http://localhost"]
  interval: 10s
  timeout: 5s
  retries: 3

A container being running does not automatically mean the
application is healthy. A health check provides an additional
application-level signal.

🔄 Restart Policy

restart: unless-stopped

This allows Docker to restart containers after failures or Docker/host
restarts while respecting a deliberate manual stop.

🚀 How to Run

docker compose config
docker compose up -d --build
docker compose ps

Open:

http://localhost:8080

View logs:

docker compose logs
docker compose logs -f

Stop:

docker compose down

Remove Compose-managed volumes too:

docker compose down -v

Use -v carefully because it removes stored volume data.

🔍 Troubleshooting

Recommended sequence:

docker compose ps
        ↓
docker compose logs <service>
        ↓
docker compose config
        ↓
Check image/configuration
        ↓
Check network
        ↓
Check port mapping
        ↓
Check health status
        ↓
Fix and recreate
        ↓
Verify

Useful commands:

docker compose ps
docker compose logs web
docker compose logs backend
docker compose config
docker inspect docker-web
docker inspect docker-backend
docker network ls
docker network inspect <network-name>
docker volume ls

🧪 Failure Simulation

Temporarily change:

image: nginx:alpine

to:

image: nginx:invalid-version

Then run:

docker compose up -d
docker compose ps
docker compose logs backend

Identify the issue, restore the correct image, restart the stack, and
verify the application is healthy.

📊 Verification Checklist

Dockerfile created

Custom image built

Compose configured

Multiple services running

Custom network configured

Service-name communication tested

Environment variables configured

Named volume configured

Persistence tested

Health checks configured

Restart policy configured

Logs and inspect commands practiced

Failure simulation completed

Troubleshooting practiced

Architecture documented

💡 Key DevOps Learnings

Containers are disposable; persistent data should live outside the
container filesystem.

Services should communicate through appropriate Docker networks and
service discovery.

Running is not the same as healthy; health checks provide better
application visibility.

Environment-specific configuration should be externalized.

Troubleshooting is a core DevOps skill.

🔮 Future Improvements

This project can later be extended with:

Real backend API

Database integration

CI/CD pipeline

Docker image registry

Kubernetes deployment

Terraform infrastructure

Prometheus monitoring

Grafana dashboards

Centralized logging

Container image security scanning

👨‍💻 Author

DevOps / Cloud Engineer --- Hands-on Learning Project

Learn → Build → Break → Troubleshoot → Document → 
