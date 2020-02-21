# BUILDING
FROM node:lts-alpine AS builder

# base on work of llitfkitfk@gmail.com
LABEL maintainer="chibing.fy@alibaba-inc.com"

WORKDIR /app

# cache dependencies
COPY package.json ./

# 在国内打开下面一行加速
#RUN npm config set registry https://registry.npm.taobao.org/

# instal dependencies
RUN npm install typescript -g && \
    npm install

# build
COPY . ./
RUN npm run build

# RUNNING
FROM node:lts-alpine

# base on work of llitfkitfk@gmail.com
LABEL maintainer="chibing.fy@alibaba-inc.com"
# use China mirror of: https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-linux.tar.gz
RUN wget http://rap2-taobao-org.oss-cn-beijing.aliyuncs.com/pandoc-2.7.3-linux.tar.gz?Expires=1582252106&OSSAccessKeyId=TMP.hj1o4zTDHufhSdzcAPX7FhDV9f53GNerVKW4ksYB1pPhJBgsLUDxiG33hFh7SWbg8VL7Q8NzJBZN8SM8b5ChKhNN33DZKADwXJHrEwVs7u8bhFrMqJDBrYqDmTyDaR.tmp&Signature=K%2BXgFRoWBjJBf7KhpgTk8aB99A8%3D && \
    tar -xf pandoc-2.7.3-linux.tar.gz && \
    cp pandoc-2.7.3/bin/* /usr/bin/ && \
    pandoc -v && \
    rm -rf pandoc-2.7.3-linux.tar.gz pandoc-2.7.3

WORKDIR /app
COPY --from=builder /app/public .
COPY --from=builder /app/dist .
COPY --from=builder /app/node_modules ./node_modules
