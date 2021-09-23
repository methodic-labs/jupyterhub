
To set this up in production:
- Create an EC2 with a bunch of permissions as per https://zero-to-jupyterhub.readthedocs.io/en/latest/
- Add auth0 api keys to the end of helm_config_template.yaml
- run the scripts in this repo in the following order:
  - `./createCluster.sh`
  - wait for completion
  -  ./setupWeaveSecrets.sh
  - wait for completion
  - (Optional) Setup NFS following directions here: https://zero-to-jupyterhub.readthedocs.io/en/latest/kubernetes/amazon/efs_storage.html#amazon-efs
    - The NFS security group should only be applied to mount endpoints. 
    - The SGs for nodes and master should reference that NFS security group to allow incoming NFS traffic and the NFS security group should allow incoming NFS traffic from nodes and masters.
    - The NFS security group must be removed before attempting to delete the cluster otherwise it will hang on trying to delete the VPC. 
    - `./setupNamespaceStorage.sh <efs id>` automates the remaining steps.
  - `./configureJupyterHub.sh`
  - wait for completion
  - Update DNS CNAME record for jupyterhub.openlattice.com to point at new load balancer URL (if needed)  
  - (Optional) Update auth0 to have this proxy in the allowed urls as well # Shouldn't be needed now that jupyterhub.openlattice.com exists
  - May have to do a `kubectl delete pod autohttps-####` b/c autohttps will fail until DNS is updated with the correct ELB. Don't worry, the autohttps service will auto start back up after delete

To pick up future changes in config simply run:

`helm upgrade jupyterhub jupyterhub/jupyterhub --version=1.1.3 --values config.yaml`

To run jupyterhub locally:
  - `git submodule init; git submodule update`
  - Install docker: https://desktop.docker.com/mac/stable/Docker.dmg
  - Start docker
  - go into  the `local/ subdirectory
  - run `./startStack.sh`
  - navigate to http://localhost/
  - login with any username and the password `openlattice`
  <h4>Be sure to run ./stopStack.sh</h4> when you're done or it will run forever and eat a lot of system resources
