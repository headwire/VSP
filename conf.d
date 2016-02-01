upstream nodejs {
#       least_conn;
        server 127.0.0.1:3000;
}

server {
    listen 80 default_server;
    server_name vsp-construction.com www.vsp-construction.com;
#    return 301 https://vsp-construction.com$request_uri;
    keepalive_timeout 70;
    root /var/www/client/app;

    # Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
    location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
    }

    location ^~ /explorer {
        deny all;
        return 403;
    }

    location ~ ^/(images/|scripts/|styles/|fonts/|icons/|favicons/|modules/|index.html|robots.txt|humans.txt|favicon.ico|apple-touch-icon.png|apple-touch-icon-precomposed.png|favicon-16x16.png|favicon-32x32.png) {
#      root /var/www/dist;
      root /var/www/client/app;
      index index.html;
      access_log off;
      log_not_found off;
      add_header Cache-Control public;
      expires max;
    }

#    ssl_certificate        /etc/ssl/certs/euromet.pem;
#    ssl_certificate_key  /etc/ssl/private/server.key;

    proxy_read_timeout 30;
    server_name_in_redirect off;
    charset utf-8;

    location / {
        proxy_pass https://nodejs;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
        proxy_redirect off;
    }

#    location /api {
#       proxy_pass https://ec2-54-235-134-228.compute-1.amazonaws.com/api;
#        proxy_http_version 1.1;
#        proxy_set_header Upgrade $http_upgrade;
#        proxy_set_header Connection 'upgrade';
#        proxy_set_header Host $host;
#        proxy_set_header X-Forwarded-For $remote_addr;
#        proxy_set_header X-Real-IP $remote_addr;
#        proxy_cache_bypass $http_upgrade;
#        proxy_redirect off;
#    }
}
