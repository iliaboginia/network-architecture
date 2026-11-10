# Lab validation checklist

The public snippets are fictional examples derived from operational configuration patterns. No device was modified during preparation.

1. Use an empty RouterOS 7 lab instance with console access. Review any default configuration before import; the examples are not designed to merge blindly into it.
2. Map example interfaces to lab interfaces. Keep management access independent while enabling bridge VLAN filtering.
3. For access/distribution examples, verify bridge VLAN membership and PVIDs, then test tagged uplinks and untagged endpoints. Confirm the expected RSTP root. Test DHCP snooping and BPDU guard in an isolated loop-free lab.
4. For the L3 example, verify DHCP leases, DNS reachability through the lab edge, management access from the management segment and rejection of user/guest access to management. Confirm new traffic is permitted only by the documented forward rules.
5. For policy routing, test connected and internal destinations before external traffic. Confirm the selected source uses the alternate table, remove its primary gateway and observe the backup route. Gateway ping success alone is not proof of internet health. Existing NAT sessions can break on a path change.
6. Record RouterOS version, hardware/CHR platform and results locally. Do not publish raw exports, screenshots with operational identifiers, or test logs from real equipment.
