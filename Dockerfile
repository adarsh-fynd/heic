FROM node:18.16.0-alpine3.17 as builder
RUN npm -g install npm@9.6.1
# RUN apk update && apk add python3-dev make alpine-sdk gcc g++ git build-base openssh openssl bash perl m4 libtool automake autoconf
RUN apk add libpng-dev libjpeg-turbo-dev libwebp-tools ffmpeg build-base libde265-dev x265-dev aom-dev libheif-dev vips-dev gobject-introspection-dev meson cmake

# Download and extract the libheif source code
ENV LIBHEIF_VERSION=1.17.6
RUN wget https://github.com/strukturag/libheif/releases/download/v$LIBHEIF_VERSION/libheif-$LIBHEIF_VERSION.tar.gz && \
   tar -xzf libheif-$LIBHEIF_VERSION.tar.gz && \
   cd libheif-$LIBHEIF_VERSION && \
   mkdir build && \
   cd build && \
   cmake --preset=release .. && \
   make && \
   make install && \
   make clean

# Download and extract the libvips source code
ENV LIBVIPS_VERSION=8.14.5
RUN wget https://github.com/libvips/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.xz && \
   tar xf vips-$LIBVIPS_VERSION.tar.xz && \
   cd vips-$LIBVIPS_VERSION && \
   meson setup build && \
   meson compile -C build && \
   meson install -C build && \
   cd .. && \
   rm -rf vips-$LIBVIPS_VERSION

WORKDIR /usr/app
COPY ./ /usr/app
RUN npm ci
ENTRYPOINT ["node" , "/usr/app/index.js"]