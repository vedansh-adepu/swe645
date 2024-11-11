# Step 1: Use an official lightweight version of nginx as the base image
FROM nginx:alpine

# Step 2: Copy your custom nginx.conf to the Nginx configuration directory
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Step 3: Copy your HTML files to the nginx web directory
COPY . /usr/share/nginx/html

# Step 4: Expose port 80 to allow traffic to the web server
EXPOSE 80

# Step 5: Start the nginx server when the container starts
CMD ["nginx", "-g", "daemon off;"]
