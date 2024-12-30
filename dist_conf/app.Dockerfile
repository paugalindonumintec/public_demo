# ------------------------------------------
# Specify the base of the image 
# ------------------------------------------
    FROM python:3.12-slim-bullseye

    # Prevents Python from writing pyc files.
    ENV PYTHONDONTWRITEBYTECODE=1
    
    # Keeps Python from buffering stdout and stderr to avoid situations where
    # the application crashes without emitting any logs due to buffering.
    ENV PYTHONUNBUFFERED=1
    
    #-------------------------------------------
    # Prepare environ from arguments
    #-------------------------------------------
    ARG git_user
    ARG git_token
    ARG environ
    
    # ------------------------------------------
    # Install the application dependencies 
    # ------------------------------------------
    RUN apt-get update && \
        apt-get install -y git gcc libmemcached-dev build-essential procps python3-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
        
        
    # ------------------------------------------
    # Specify the main directory of the image and manage user
    # ------------------------------------------
    
    # Create auser that the app will run under.
    # See https://docs.docker.com/go/dockerfile-user-best-practices/
    ARG UID=10001
    RUN adduser \
        --disabled-password \
        --gecos "" \
        --shell "/sbin/nologin" \
        --uid "${UID}" \
        appuser
    
    WORKDIR /home/appuser/app/
    
    # ------------------------------------------
    # Requiere to work
    # ------------------------------------------
    RUN pip install --upgrade pip \
                    requests \
                    boto3 \
                    jwcrypto \
                    pyjwt \
                    mysql-connector-python==8.0.28 \
                    soundfile \
                    numpy \
                    pandas \
                    xlwt \
                    openpyxl \
                    paramiko
    #               && \
    RUN pip install git+https://${git_user}:${git_token}@github.com/Numintec/common_libs.git@${environ}
    
    # ------------------------------------------
    # Copy our source to the image
    # ------------------------------------------
    COPY . /home/appuser/app
    RUN mkdir /etc/invoxcontact
    COPY system.conf /etc/invoxcontact/system.conf
    
    RUN chown -R appuser:appuser /home/appuser/app/
    
    USER appuser
    
    # ------------------------------------------
    # Execute app
    # ------------------------------------------
    CMD python3 worker_upbe_records.py