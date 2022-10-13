# Segment Routing with ISIS LAB (sr-mpls)
## Requeriments
Versions used are:
* containerlab 0.25.1
* vr-sros 22.5.R2 (requires license)

SROS image was created using [VR Network Lab](https://github.com/vrnetlab/vrnetlab)
IMPORTANT: vr-sos must be set as an image in docker to be pull directly by containerlab
```
[root@dell02 clab-sr-mpls]# docker images | grep vr-sros
vr-sros                               22.5.R2                         f33cd7a3732a        3 months ago        965MB
```

## Overview
Lab built with containerlab to test sr-mpls usinf sr-isis.

If you are new with container lab, we recommed to check the post regading [Nokia SROS in the manual](https://containerlab.dev/manual/kinds/vr-sros/)

Details of SR-MPLS, TE-LSP and Fast ReRoute (FRR) capability by pre-computing Loop-Free Alternate (LFA) paths, and other technologies used on this demo, check post: [Segment Routing with Nokia 7750 on GNS3 by Derek Cheung](https://derekcheung.medium.com/segment-routing-b69f6ea2e3f5)

# Setting the lab
Use containerlab a specified topology
```
clab deploy --topo topo.yml
```


## Check status of services

Next commands have been done using classic command line management interface
```
A:router1# show router isis adjacency

===============================================================================
Rtr Base ISIS Instance 0 Adjacency
===============================================================================
System ID                Usage State Hold Interface                     MT-ID
-------------------------------------------------------------------------------
router2                  L2    Up    22   toR2                          0
router3                  L2    Up    20   toR3                          0
-------------------------------------------------------------------------------
Adjacencies : 2
===============================================================================

A:router1# oam lsp-ping sr-isis prefix 1.1.1.4/32
LSP-PING 1.1.1.4/32: 80 bytes MPLS payload
Seq=1, send from intf toR2, reply from 1.1.1.4
       udp-data-len=32 ttl=255 rtt=1.20ms rc=3 (EgressRtr)

---- LSP 1.1.1.4/32 PING Statistics ----
1 packets sent, 1 packets received, 0.00% packet loss
round-trip min = 1.20ms, avg = 1.20ms, max = 1.20ms, stddev = 0.000ms
A:router1# oam lsp-trace sr-isis prefix 1.1.1.4/32
lsp-trace to 1.1.1.4/32: 0 hops min, 0 hops max, 104 byte packets
1  1.1.1.2  rtt=1.69ms rc=8(DSRtrMatchLabel) rsc=1
2  1.1.1.4  rtt=0.734ms rc=3(EgressRtr) rsc=1
```
