{ config, ... }:
{
  sops.secrets."zpool_zstorage_pass" = { };

  disko.devices = {
    disk = {
      root1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_Red_SN700_1000GB_24430R801246";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      root2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WDS100T1R0A-68A4W0_234808802347";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot2";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };

      data1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD60EFRX-68L0BN1_WD-WXL1H16LX5XX";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zstorage";
              };
            };
          };
        };
      };
      data2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD60EFRX-68L0BN1_WD-WXB1HB4VCJU3";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zstorage";
              };
            };
          };
        };
      };
      data3 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD60EFPX-68C5ZN0_WD-WX42D344E417";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zstorage";
              };
            };
          };
        };
      };
      data4 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD60EFPX-68C5ZN0_WD-WX22D345SXSE";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zstorage";
              };
            };
          };
        };
      };
      data5 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD60EFPX-68C5ZN0_WD-WX52D64NC34N";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zstorage";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          acltype = "posixacl";
          dnodesize = "auto";
          canmount = "off";
          xattr = "sa";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          #keylocation = "prompt";
          keylocation = "file:///tmp/pass-zpool-zroot";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = ''
          zfs set keylocation="prompt" zroot
        '';
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          "home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
            };
          };
          "minecraft" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/minecraft";
            options = {
              mountpoint = "legacy";
            };
          };
          "nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              atime = "off";
              mountpoint = "legacy";
            };
          };
          "consume" = {
            type = "zfs_fs";
            mountpoint = "/var/media/documents/consume";
            options = {
              mountpoint = "legacy";
              quota = "5G";
            };
          };
          "containers" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/containers";
            options = {
              mountpoint = "legacy";
              recordsize = "16K";
            };
          };
          "downloads" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/var/media/downloads";
            };
          };
          "pgsql" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/postgresql";
            options = {
              atime = "off";
              logbias = "throughput";
              mountpoint = "legacy";
              primarycache = "metadata";
              recordsize = "8K";
            };
          };
          "reserved" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              reservation = "10G";
            };
          };
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };
          "var" = {
            type = "zfs_fs";
            mountpoint = "/var";
            options = {
              mountpoint = "legacy";
            };
          };
        };
      };

      zstorage = {
        type = "zpool";
        mode = "raidz1";
        rootFsOptions = {
          acltype = "posixacl";
          dnodesize = "auto";
          canmount = "off";
          xattr = "sa";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          #keylocation = "prompt";
          keylocation = "file:///tmp/pass-zpool-zstorage";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        # Hook untested! keylocation was manually set.
        postCreateHook = ''
          zfs set keylocation="file:///${config.sops.secrets.zpool_zstorage_pass.path}" zstorage
        '';
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          "cloud" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/var/cloud";
            };
          };
          "media" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
            };
          };
          "media/documents" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/var/media/documents";
            };
          };
          "media/isos" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/var/media/isos";
              recordsize = "1m";
            };
          };
          "media/videos" = {
            type = "zfs_fs";
            options = {
              compression = "off";
              mountpoint = "/var/media/videos";
              recordsize = "1m";
            };
          };
          "reserved" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              reservation = "100G";
            };
          };
        };
      };
    };
  };
}
