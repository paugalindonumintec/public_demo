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
# Authorize SSH Host
# ------------------------------------------
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# ------------------------------------------
# Add the keys and set permissions
# ------------------------------------------
COPY ./ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
#RUN eval "$(ssh-agent -s)" && echo "empty" | ssh-add /root/.ssh/id_rsa

# ------------------------------------------
# Requiere to work
# ------------------------------------------

RUN pip3 install git+ssh://git@github.com/paugalindonumintec/demo.git@${environ} -v

# ------------------------------------------
# Copy our source to the image
# ------------------------------------------
COPY . /home/appuser/app
RUN mkdir /etc/invoxcontact

RUN chown -R appuser:appuser /home/appuser/app/

USER appuser

# ------------------------------------------
# Execute app
# ------------------------------------------
CMD python3 worker.py