
To set this up in production:
- Create an EC2 with a bunch of permissions as per https://zero-to-jupyterhub.readthedocs.io/en/latest/
- Add auth0 api keys to the end of helm_config_template.yaml
- run the scripts in this repo in the following order:
  - `./createCluster.sh`
  - wait for completion
  - `./configureJupyterHub.sh`
  - wait for completion
  - Update config.yaml to have a correct oauth_callback_url pointing at the proxy, ending in `/hub/oauth_callback`
  - Create a security group allowing NFS traffic to nodes and masters sgs
  - create an EFS cluster that uses above SG for all three SGs
  - `./setupNamespaceStorage.sh <efs id>`
  - `helm upgrade jupyterhub jupyterhub/jupyterhub --version=0.10.6 --values config.yaml`
  - Update auth0 to have this proxy in the allowed urls as well # Shouldn't be needed now that jupyterhub.openlattice.com exists
  - May have to do a `kubectl delete pod autohttps-####` b/c autohttps will fail until DNS is updated with the correct ELB. Don't worry, the autohttps service will auto start back up after delete

To run jupyterhub locally:
  - `git submodule init; git submodule update`
  - Install docker: https://desktop.docker.com/mac/stable/Docker.dmg
  - Start docker
  - go into  the `local/ subdirectory
  - run `./startStack.sh`
  - navigate to http://localhost/
  - login with any username and the password `openlattice`
  <h4>Be sure to run ./stopStack.sh</h4> when you're done or it will run forever and eat a lot of system resources
