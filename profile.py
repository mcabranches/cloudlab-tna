""" TNA + Kubernetes
"""

import time

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as rspec

BASE_IP = "10.10.1"
BANDWIDTH = 10000000
TNA_IMAGE = 'urn:publicid:IDN+emulab.net+image+CUDevOpsFall2018:tnak8s'
#'urn:publicid:IDN+emulab.net+image+CUDevOpsFall2018:xdptna.node-0'

# Note: not currently used
# XDP_IMAGE = 'urn:publicid:IDN+emulab.net+image+CUDevOpsFall2018//xdptna'

# Set up parameters
pc = portal.Context()
pc.defineParameter("nodeCount", 
                   "Number of nodes in the experiment. It is recommended that at least 3 be used for Kubernetes.",
                   portal.ParameterType.INTEGER, 
                   3)
pc.defineParameter("nodeType", 
                   "Node Hardware Type",
                   portal.ParameterType.NODETYPE, 
                   "d430",
                   longDescription="A specific hardware type to use for all nodes. This profile has been tested with d430 nodes")
pc.defineParameter("startKubernetes",
                   "Create Kubernetes cluster",
                   portal.ParameterType.BOOLEAN,
                   True,
                   longDescription="Create a Kubernetes cluster using default image setup (calico networking, etc.)")
pc.defineParameter("kubeproxyBackend",
                   "If creating a Kubernetes cluster, configure kube-proxy to use iptables or ipvs",
                   portal.ParameterType.STRING,
                   "iptables",
                   legalValues=["iptables", "ipvs"],
                   longDescription="This parameter is ignored if startKubernetes is set to false.")
pc.defineParameter("cni",
                   "If creating a Kubernetes cluster, use calico or flannel",
                   portal.ParameterType.STRING,
                   "calico",
                   legalValues=["calico", "flannel"],
                   longDescription="This parameter is ignored if startKubernetes is set to false.")
pc.defineParameter("calicoEncapsulation",
                   "Specify the encapsulation for tigera calico",
                   portal.ParameterType.STRING,
                   "VXLAN",
                   legalValues=["None", "IPIP", "VXLAN"],
                   longDescription="This parameter is ignored if startKubernetes is set to false or flannel is used.")
pc.defineParameter("calicoNAT",
                   "Specify whether to enable/disable NAT in tigera calico",
                   portal.ParameterType.STRING,
                   "Enabled",
                   legalValues=["Enabled", "Disabled"],
                   longDescription="This parameter is ignored if startKubernetes is set to false or flannel is used.")

# Below option copy/pasted directly from small-lan experiment on CloudLab
# Optional ephemeral blockstore
pc.defineParameter("tempFileSystemSize", 
                   "Temporary Filesystem Size",
                   portal.ParameterType.INTEGER, 
                   0,
                   advanced=True,
                   longDescription="The size in GB of a temporary file system to mount on each of your " +
                   "nodes. Temporary means that they are deleted when your experiment is terminated. " +
                   "The images provided by the system have small root partitions, so use this option " +
                   "if you expect you will need more space to build your software packages or store " +
                   "temporary files. 0 GB indicates maximum size.")
params = pc.bindParameters()

# Verify parameters
if params.nodeCount <= 0:
    perr = portal.ParameterWarning("An experiment must contain at least one node.",['nodeCount'])
    pc.reportError(perr)

pc.verifyParameters()
request = pc.makeRequestRSpec()

def create_node(name, nodes, lan):
  # Create node
  node = request.RawPC(name)
  node.disk_image = TNA_IMAGE
  node.hardware_type = params.nodeType
  
  # Add interface
  iface = node.addInterface("interface-1")
  iface.addAddress(rspec.IPv4Address("{}.{}".format(BASE_IP, 1 + len(nodes)), "255.255.255.0"))
  lan.addInterface(iface)
  
  # Add extra storage space
  bs = node.Blockstore(name + "-bs", "/mydata")
  bs.size = str(params.tempFileSystemSize) + "GB"
  bs.placement = "any"
  
  # Add to node list
  nodes.append(node)

nodes = []
lan = request.LAN()
lan.bandwidth = BANDWIDTH

# Create nodes
# The start script relies on the idea that the primary node is 10.10.1.1, and subsequent nodes follow the
# pattern 10.10.1.2, 10.10.1.3, ...
for i in range(params.nodeCount):
    name = "node"+str(i+1)
    create_node(name, nodes, lan)

# Iterate over secondary nodes first
for i, node in enumerate(nodes[1:]):
    node.addService(rspec.Execute(shell="bash", command="/local/repository/start.sh secondary {}.{} {} {} > /local/repository/start.log 2>&1 &".format(
      BASE_IP, i + 2, params.startKubernetes, params.kubeproxyBackend)))

# Start primary node
nodes[0].addService(rspec.Execute(shell="bash", command="/local/repository/start.sh primary {}.1 {} {} {} {} {} {} > /local/repository/start.log 2>&1".format(
  BASE_IP, params.nodeCount, params.startKubernetes, params.kubeproxyBackend, params.calicoEncapsulation, params.calicoNAT, params.cni)))

pc.printRequestRSpec()
