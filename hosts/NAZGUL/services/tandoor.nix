{
  config,
  inputs,
  lib,
  ...
}:
{
  sops.secrets = {
    "tandoor/web_env.enc" = {
    };
  };

  services = {
    tandoor-recipes = {
      enable = true;
      port = 3030;
      extraConfig = {
        CSRF_TRUSTED_ORIGINS = "https://recipes.${inputs.nix-secrets.domain}";
        #ALLOWED_HOSTS = "recipes.${inputs.nix-secrets.domain}";
        MEDIA_ROOT = "/var/lib/tandoor-recipes/media";
        DB_ENGINE = "django.db.backends.postgresql";
        POSTGRES_DB = "tandoor_recipes";
        POSTGRES_USER = "tandoor_recipes";
        POSTGRES_HOST = "/run/postgresql";
      };
    };

    postgresql = {
      ensureUsers = [
        {
          name = "tandoor_recipes";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "tandoor_recipes" ];
    };

    nginx = {
      enable = true;
      virtualHosts = {
        "recipes.${inputs.nix-secrets.domain}" = {
          listen = [
            {
              addr = "0.0.0.0";
              port = 8082;
            }
          ];
          locations = {
            "/media/".alias = "/var/lib/tandoor-recipes/media/";
            "/" = {
              proxyPass = "http://127.0.0.1:3030";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-Proto https;
              '';
            };
          };
        };
      };
    };
  };

  # Fix for nginx folder permissions
  users = {
    users.tandoor_recipes = {
      name = "tandoor_recipes";
      group = "tandoor_recipes";
      isSystemUser = true;
    };
    groups.tandoor_recipes.members = [ "${config.services.nginx.user}" ];
  };

  systemd.services.tandoor-recipes.serviceConfig = {
    EnvironmentFile = "${config.sops.secrets."tandoor/web_env.enc".path}";
    DynamicUser = lib.mkForce false;
    Group = lib.mkForce "tandoor_recipes";
  };

  networking.firewall.allowedTCPPorts = [ 8082 ];
}
