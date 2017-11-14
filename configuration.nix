{ config, pkgs, ...}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernel = {
      sysctl."vm.overcommit_memory" = "1";
    };

    loader = {
      grub.device = "/dev/vda";
      grub.enable = true;
      grub.version = 2;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      gcc
      git
      nix-repl
      screen
      iptables
      wget
      tcpdump
      htop
      which
      unzip
      nixops
      tree
      silver-searcher
      gnupg
    ];

    variables = {
      EDITOR = "nano";
    };
  };

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  networking = {
    hostName = "nixos";
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  programs = {
    bash = {
      enableCompletion = true;
    };

    ssh = {
      startAgent = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
    };
  };

  time.timeZone = "Europe/London";

  users = {
    extraUsers = {
      ian = {
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        openssh.authorizedKeys.keys = with import ./ssh-keys.nix; [ ian ];
      };

      root = {
        openssh.authorizedKeys.keys = with import ./ssh-keys.nix; [ ian ];
      };
    };
  };

  system.stateVersion = "17.09";
}
