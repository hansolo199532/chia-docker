FROM ubuntu:hirsute

# mainnet
EXPOSE 8444/tcp
# testnet
EXPOSE 58444/tcp
# RPC interface
EXPOSE 8555/tcp

VOLUME /root/.chia
VOLUME /mnt/chia-plots/tmp
VOLUME /mnt/chia-plots/final

ENV chia_dir="/opt/chia-blockchain"
ENV chia_update_on_init="true"
ENV start="farmer"
ENV keys="generate"
ENV farmer_address="localhost"
ENV farmer_port=8444
ENV full_node_port=8444
ENV testnet="false"
ENV plots_size=32
ENV plots_num=1
ENV plots_num_threads=2
ENV plots_farmer_public_key="932e56409ca64ce9ebadf3ca32e268e52acc6478d931413d8346aa6de7a054a5b87af3659b40b4175e70cfabcbb8b6c1"
ENV plots_pool_public_key="932e56409ca64ce9ebadf3ca32e268e52acc6478d931413d8346aa6de7a054a5b87af3659b40b4175e70cfabcbb8b6c1"
ENV plots_tmp_dir="/mnt/chia-plots/tmp"
ENV plots_final_dir="/mnt/chia-plots/final"
ENV plots_options=""
ENV prevent_sleep=""
ENV plots_curl_target=""

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
    bash git apt curl htop lsb-release sudo \
    python3.9 python3.9-dev python3.9-venv python3.9-distutils python-is-python3

RUN git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules /opt/chia-blockchain
RUN cd /opt/chia-blockchain && bash ./install.sh

WORKDIR /opt/chia-blockchain

COPY scripts/container_entrypoint.sh /usr/local/bin/container_entrypoint.sh
COPY scripts/chia_update.sh /usr/local/bin/chia_update.sh
COPY scripts/plots_create.sh /usr/local/bin/plots_create.sh
COPY scripts/plots_upload.sh /usr/local/bin/plots_upload.sh
RUN chmod +x /usr/local/bin/chia_update.sh /usr/local/bin/plots_create.sh /usr/local/bin/plots_upload.sh

ENTRYPOINT ["bash", "/usr/local/bin/container_entrypoint.sh"]
