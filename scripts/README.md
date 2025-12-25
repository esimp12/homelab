# Utility Scripts

- `start-qemu-vm` - create and start a UEFI booted QEMU VM from a virtual disk (.qcow2), VM can be accessed over VNC (e.g. `vncviewer :0`)
    - Networking setup
    ```
    # Setup bridge
    sudo ip link add br0 type bridge
    sudo ip addr add 10.0.0.1/24 dev br0
    sudo ip link set br0 up

    # Setup tap
    sudo ip tuntap add tap0 mode tap
    sudo ip link set tap0 up
    sudo ip link set tap0 master br0
    
    # Allow Host IP Forwarding
    echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-forward.conf

    # Add NAT masquerade on Host
    sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o wlan0 -j MASQUERADE
    sudo iptables -A FORWARD -i br0 -o wlan0 -j ACCEPT
    sudo iptables -A FORWARD -i wlan0 -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Setup DHCP w/ dnsmasq
    # write the following to /etc/dnsmasq.d/br0.conf
    interface=br0
    bind-interfaces

    dhcp-range=10.0.0.50,10.0.0.100,255.255.255.0,12h
    dhcp-option=3,10.0.0.1
    dhcp-option=6,8.8.8.8,1.1.1.1
    ```

    - A persistent setup of these networking steps are captured in the following network config files contained within this directory:
        - 10-br0.netdev
        - 10-br0.network
        - 10-tap0.netdev
        - 10-tap0.network
        - br0-nat.service

    - The following commands will need to be run to finish persisting these networking settings
        - sudo systemctl restart systemd-networkd
        - sudo systemctl restart dnsmasq
        - sudo systemctl enable --now br0-nat.service

