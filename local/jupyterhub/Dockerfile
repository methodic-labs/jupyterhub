FROM jupyterhub/jupyterhub:1.0.0

RUN wget https://raw.githubusercontent.com/jupyterhub/jupyterhub/1.0.0/examples/cull-idle/cull_idle_servers.py

COPY jupyterhub_config.py .

RUN pip install dockerspawner==0.11.1
