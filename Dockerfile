
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD wget --spider -q http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

