# Must use a Cuda version 11+
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

RUN apt-get update && \
    apt-get install -y git ffmpeg && \
    apt-get install libsndfile1 -y && \
    apt-get clean

WORKDIR /

# Install git, ffmpeg and nvidia drivers
ARG DEBIAN_FRONTEND=noninteractive

# Install python packages
RUN pip3 install --upgrade pip
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# We add the banana boilerplate here
ADD server.py .

# Add your model weight files 
# (in this case we have a python script)
ADD download.py .
RUN python3 download.py


# Add your custom app code, init() and inference()
ADD app.py .

EXPOSE 8000

CMD python3 -u server.py
