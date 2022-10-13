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
Checking elements in the lab
```
[root@dell02 clab-sr-mpls]# clab inspect --topo topo.yml
INFO[0000] Parsing & checking topology file: topo.yml
+---+--------------------------+--------------+-----------------+---------+---------+----------------+----------------------+
| # |           Name           | Container ID |      Image      |  Kind   |  State  |  IPv4 Address  |     IPv6 Address     |
+---+--------------------------+--------------+-----------------+---------+---------+----------------+----------------------+
| 1 | clab-srmpls-destination1 | 9bd285d5be17 | alpine:latest   | linux   | running | 172.20.20.2/24 | 2001:172:20:20::2/64 |
| 2 | clab-srmpls-destination2 | 18fcb789408e | alpine:latest   | linux   | running | 172.20.20.7/24 | 2001:172:20:20::7/64 |
| 3 | clab-srmpls-origin1      | 0e3edd85ea0b | alpine:latest   | linux   | running | 172.20.20.3/24 | 2001:172:20:20::3/64 |
| 4 | clab-srmpls-origin2      | 08024876191f | alpine:latest   | linux   | running | 172.20.20.5/24 | 2001:172:20:20::5/64 |
| 5 | clab-srmpls-router1      | b1c4368dc299 | vr-sros:22.5.R2 | vr-sros | running | 172.20.20.4/24 | 2001:172:20:20::4/64 |
| 6 | clab-srmpls-router2      | e3583a56107f | vr-sros:22.5.R2 | vr-sros | running | 172.20.20.6/24 | 2001:172:20:20::6/64 |
| 7 | clab-srmpls-router3      | c3fd1648a679 | vr-sros:22.5.R2 | vr-sros | running | 172.20.20.8/24 | 2001:172:20:20::8/64 |
| 8 | clab-srmpls-router4      | 97a35e3939d0 | vr-sros:22.5.R2 | vr-sros | running | 172.20.20.9/24 | 2001:172:20:20::9/64 |
+---+--------------------------+--------------+-----------------+---------+---------+----------------+----------------------+
```

You have direct access (after one min) to management interface via ssh admin/admin
Remember to change the CLI to model-driven if this is still in Classic.
You can copy and paste router settings form yaml files directly to CLI after /configure path


## Check status of services

Next commands have been done using <b>Classic command line management interface mode</b>
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
