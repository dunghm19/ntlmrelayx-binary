FROM python:latest AS compile
WORKDIR /opt
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc python3-dev libffi-dev libssl-dev binutils && \
    rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install virtualenv
RUN virtualenv -p python venv
ENV PATH="/opt/venv/bin:$PATH"

# Install impacket from pip
RUN python3 -m pip install impacket

# Install pyinstaller
RUN python3 -m pip install pyinstaller

# Copy your custom ntlmrelayx.py
COPY ntlmrelayx.py /opt/ntlmrelayx.py

# Build the binary with all impacket modules included
RUN pyinstaller --onefile --name ntlmrelayx --clean \
    --collect-all impacket \
    --collect-submodules impacket.examples \
    --hidden-import impacket.examples.ntlmrelayx.clients \
    --hidden-import impacket.examples.ntlmrelayx.attacks \
    --hidden-import impacket.examples.ntlmrelayx.servers \
    --hidden-import impacket.examples.ntlmrelayx.utils \
    --strip \
    /opt/ntlmrelayx.py && \
    cp /opt/dist/ntlmrelayx /usr/local/bin/ntlmrelayx && \
    chmod +x /usr/local/bin/ntlmrelayx

FROM python:latest
COPY --from=compile /usr/local/bin/ntlmrelayx /usr/local/bin/ntlmrelayx
ENTRYPOINT ["/usr/local/bin/ntlmrelayx"]