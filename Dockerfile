# Use a specific version of Python
FROM python:3.8

# Install dependencies
RUN apt-get update && apt-get install -y python3-distutils

# Set the working directory
WORKDIR /data

# Install Django 3.2
RUN pip install django==3.2

# Copy the project files into the container
COPY . .

# Run Django migrations
RUN python manage.py migrate

# Expose port (Optional, depending on your app)
EXPOSE 8000

# Command to run the application (Optional, depending on your app)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
