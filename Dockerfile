FROM node:18.17.0-alpine3.18 as builder
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
ENV LIBVIPS_VERSION=8.15.1
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
RUN npm install
ENTRYPOINT ["node" , "/usr/app/index.js"]