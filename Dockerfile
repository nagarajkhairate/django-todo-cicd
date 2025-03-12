# Use a specific version of Python
FROM python:3.8

# Install dependencies
RUN apt-get update && apt-get install -y python3-distutils

# Set the working directory
WORKDIR /data

# Install Django 3.2 and project dependencies
RUN pip install django==3.2
COPY requirements.txt .  # Add this if you have a requirements.txt
RUN pip install -r requirements.txt  # Install dependencies from requirements.txt

# Copy the project files into the container
COPY . .

# Expose port (Optional, depending on your app)
EXPOSE 8000

# Command to run the application (Optional, depending on your app)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
