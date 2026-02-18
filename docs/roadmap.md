# Infrastructure Roadmap

---

## Phase 1 — Foundational Lab (Current State)

- Isolated lab subnet (10.10.0.0/24)
- Windows-hosted APT caching proxy
- Proxmox host + ops-01 VM
- SSH key-based authentication
- Non-root administrative model
- Documented workstation baseline
- Documented platform baseline

Operational note:

- Windows VPN must be disabled during lab updates.
- This is a temporary constraint pending infrastructure redesign.

---

## Phase 2 — Infrastructure Decoupling (Planned)

Objective:
Remove desktop dependency from core lab infrastructure.

Potential improvements:

- Move APT caching into a VM on Proxmox
- Configure Carbon as NAT gateway (WiFi WAN + Ethernet LAN)
- Introduce managed switch (VLAN segmentation)
- Introduce wireless bridge for stable WAN uplink
- Implement firewall + controlled egress policies
- Begin Infrastructure-as-Code provisioning (Terraform)

---

## Long-Term Vision

- Dedicated gateway/firewall VM
- Internal DNS service
- Reverse proxy
- Logging and monitoring stack
- Automated VM provisioning
- Full lab rebuild via code