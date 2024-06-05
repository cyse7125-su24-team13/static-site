# Use the official Caddy image
FROM caddy:2.4.3-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY static-html.html /usr/share/caddy
EXPOSE 8080
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
