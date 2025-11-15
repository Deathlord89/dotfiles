{
  # Hibernate and hybrid-sleep won't work correctly without
  # an on-disk swap.
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable in-memory compressed swap device
  zramSwap.enable = true;
}
