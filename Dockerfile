# 使用官方的Nginx镜像作为基础镜像
FROM nginx:latest

# 将本地的index.html文件复制到容器的Nginx默认网页目录中
COPY ./index.html /usr/share/nginx/html/index.html

# 将本地的res文件夹复制到容器的Nginx默认网页目录中
COPY ./resource /usr/share/nginx/html/resource

# 确保Nginx配置正确指向容器内的资源
RUN chmod -R 755 /usr/share/nginx/html/resource

# 可以根据需要修改Nginx的配置文件
# COPY ./nginx.conf /etc/nginx/nginx.conf

# 暴露80端口
EXPOSE 80

# 启动Nginx服务
CMD ["nginx", "-g", "daemon off;"]