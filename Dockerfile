# Step 1: Use an official lightweight version of nginx as the base image
FROM nginx:alpine

# Step 2: Copy your HTML files to the nginx web directory
COPY . /usr/share/nginx/html

COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Step 3: Expose port 80 to allow traffic to the web server
EXPOSE 80

# Step 4: Start the nginx server when the container starts
CMD ["nginx", "-g", "daemon off;"]

