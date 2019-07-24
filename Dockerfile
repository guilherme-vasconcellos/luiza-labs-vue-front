# ======================================================================
# @author: Guilherme Vasconcellos <guiyllw@hotmail.com>
# @version: 1.0.0
#
# @description: Dockerfile to build challenge LuizaLabs frontend app
# ======================================================================
FROM nginx:1.16.0-alpine

COPY ./dist /usr/share/nginx/html

CMD [ "nginx", "-g", "daemon off;" ]
