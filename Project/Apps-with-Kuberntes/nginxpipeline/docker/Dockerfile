FROM us.gcr.io/just-slate-88918/nginx:alpine-3.8-nginx-1.14.0-vts-0.1.18
RUN rm /etc/nginx/conf.d/default.conf && mkdir -p /usr/share/nginx/html/akamai && echo -e "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam massa enim, tincidunt non hendrerit eget, malesuada et nisi. In hac habitasse platea dictumst. Praesent nec laoreet ante. Aenean tempus nisi in erat tempus tempus. Vestibulum imperdiet lobortis sapien eu tempus. Vivamus volutpat quam sed eros molestie vitae dignissim nulla ultricies. Vivamus dictum elit velit. Pellentesque pellentesque ornare ornare. Mauris vel gravida sapien. Praesent eleifend tristique ipsum nec tempor. Vestibulum cursus eleifend tellus, a egestas lectus euismod sed." > /usr/share/nginx/html/akamai/akamai-test-object.html && mkdir -p /etc/nginx/extra

COPY target/robots.txt /usr/share/nginx/html
COPY target/manifest.json /usr/share/nginx/html
COPY target/nginx.conf /etc/nginx
COPY target/extra.conf /etc/nginx/extra
COPY target/google42789106c82fabfb.html /usr/share/nginx/html
COPY target/google32235799fbac4bf2.html /usr/share/nginx/html
COPY target/googlefe65efb55a1e6371.html /usr/share/nginx/html
RUN mkdir /usr/share/nginx/html/icons
COPY target/icons/*.png /usr/share/nginx/html/icons/
ADD target/html/error /usr/share/nginx/html/