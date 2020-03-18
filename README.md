
To set this up:
- Create an EC2 with a bunch of permissions as per https://zero-to-jupyterhub.readthedocs.io/en/latest/
- Add auth0 api keys to the end of helm_config_template.yaml
- run the scripts in this repo in the following order:
  - ./createCluster.sh
  - wait for completion
  - ./configureJupyterHub.sh
  - wait for completion
  - Update config.yaml to have a correct oauth_callback_url pointing at the proxy, ending in `/hub/oauth_callback`
  - Create a security group allowing NFS traffic to nodes and masters sgs
  - create an EFS cluster that uses above SG for all three SGs
  - ./setupNamespaceStorage.sh <efs id>
  - helm upgrade jupyterhub jupyterhub/jupyterhub --version=0.8.2 --values config.yaml
  - Update auth0 to have this proxy in the allowed urls as well
