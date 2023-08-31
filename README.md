# CloudLab profile for deploying Kubernetes in the TNA Environment

General information for what on CloudLab profiles created via GitHub repo can be found in the example repo [here](https://github.com/emulab/my-profile) or in the CloudLab [manual](https://docs.cloudlab.us/cloudlab-manual.html)

Specifically, the goal of this repo is to create a CloudLab profile that allows for one-click creation of a Kubernetes deployment for academic research on top of a kernel custom to the research project.

## User Information

Create a CloudLab experiment using the OpenWhisk profile. It's recommended to use at least 3 nodes for the cluster. It has been testsed on d430 nodes. 

On each node, a copy of this repo is available at:
```
    /local/repository
```
Docker images are store in additional ephemeral cloudlab storage, mounted on each node at:
```
    /mydata
```

To get information on the cluster, use kubectl as expected:
```
    $ kubectl get nodes
```

## Image Creation

The [```image_setup.sh```](image_setup.sh) script is how the image was created from the base TNA image.
