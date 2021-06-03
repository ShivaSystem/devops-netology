# Решение домашнего задания к занятию "3.9. Элементы безопасности информационных систем"
1. 1,2,3,4 пункты делал согласно инструкции из ДЗ
5. устновил nginx командой:
`sudo apt install -y nginx`
Конфиг nginx:
`` ''
server {
        listen          80;
        listen          [::]:80;
        server_name     test.example.com www.test.example.com;
        return 301      https://test.example.com$request_uri;
        return 301      https://www.test.example.com$request_uri;
}

server {
        listen              443 ssl http2;
        server_name         test.example.com www.test.example.com;
        ssl_certificate     /etc/nginx/certs/test.crt;
        ssl_certificate_key /etc/nginx/certs/test.key;
        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;

        location / {
                root    /var/www/html;
                index   index.html index.htm;
        }
}
`` ''
Выпущенные сертификаты положил как видно из конфига в /etc/nginx/certs/
6. После преобразовал сертификат intermediate.cert.pem в .crt командой:
'openssl x509 -in intermediate.cert.pem -inform PEM -out intermediate.cert.pem.crt'
Затем получившийся сертификат скопировал в /usr/share/ca-certificates/intermediate.cert.pem.crt командой:
'cp intermediate.cert.pem.crt /usr/share/ca-certificates/intermediate.cert.pem.crt'
Затем выполнил команду: 
'dpkg-reconfigure ca-certificates'
После проверил curl:
`` ''
root@vault:/home/vagrant# curl -I https://test.example.com
HTTP/2 200 
server: nginx/1.18.0 (Ubuntu)
date: Thu, 03 Jun 2021 09:22:23 GMT
content-type: text/html
content-length: 612
last-modified: Thu, 03 Jun 2021 08:45:14 GMT
etag: "60b8969a-264"
accept-ranges: bytes
`` ''
7. Let's encrypt использую регулярно.
! [сеrt]
()
