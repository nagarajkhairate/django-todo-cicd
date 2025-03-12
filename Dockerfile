# Use an official Python runtime as a parent image
FROM python:3

# Install distutils and other required dependencies
RUN apt-get update && apt-get install -y python3-distutils

# Set the working directory in the container
WORKDIR /data

# Install Django
RUN pip install django==3.2

# Copy the current directory contents into the container at /data
COPY . .

# Run the Django migrations
RUN python manage.py migrate

# Expose port (Optional, depending on your app)
EXPOSE 8000

# Command to run the application (Optional, depending on your app)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
