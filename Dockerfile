# Use uma imagem base apropriada
FROM ubuntu:20.04

# Instale dependências necessárias
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    build-essential \
    sed \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /tmp

# Copie e instale btserial
COPY linux/1.3.3/x64/btserial-1.3.3.tar.gz /tmp/

RUN tar -xvf btserial-1.3.3.tar.gz \
    && cd btserial-1.3.3 \
    && sed -i 's/sudo //g' install.sh \
    && ./install.sh \
    && cd .. \
    && rm -rf btserial-1.3.3*

# Copie e instale plugpag
COPY linux/1.3.3/x64/plugpag-1.3.3.tar.gz /tmp/
RUN tar -xvf plugpag-1.3.3.tar.gz \
    && cd plugpag-1.3.3 \
    && sed -i 's/sudo //g' install.sh \
    && ./install.sh \
    && cd .. \
    && rm -rf plugpag-1.3.3*

# Copie o binário pré-compilado da demo
COPY demos/Linux/CommandPromptTest /tmp/

COPY demos/Linux/makefile /tmp/

# Se houver código-fonte para compilar, ajuste a pasta e o comando make
# Exemplo:
# COPY path/to/source /tmp/source
# WORKDIR /tmp/source
RUN make

# Execute o binário pré-compilado
CMD ["./CommandPromptTest", "COM0", "1", "1", "1", "123", "ABC"]
